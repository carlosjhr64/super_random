require 'timeout'
require 'securerandom'
require 'open-uri'
require 'digest'
# Requires:
#`ruby`

class SuperRandom
  VERSION = '3.2.230213'
  DEFAULT_SOURCES = [
    'https://www.random.org/strings/?' \
    'num=10&len=20&digits=on&upperalpha=on&loweralpha=on&unique=on&' \
    'format=plain&rnd=new'
  ]
  MUTEX = Mutex.new
  DIV = 128.times.inject(''){|h,_|h<<'f'}.to_i(16)
  RATE_LIMIT = 60 # One minute, be nice!
  @@last_time = Time.now.to_i - RATE_LIMIT - 1

  attr_accessor :first_timeout, :second_timeout, :nevermind
  attr_reader   :sources, :source_count, :byte_count

  def initialize(*sources)
    @sources = sources.empty? ? DEFAULT_SOURCES.dup : sources
    @byte_count,@source_count = 0,0
    @first_timeout,@second_timeout,@nevermind = 3,3,true
  end

  # Returns 64 random bytes(at least from SecureRandom's)
  def bytes
    @byte_count,@source_count = 0,0
    _do_updates if Time.now.to_i - @@last_time > RATE_LIMIT
    _get_bytes
  end

  def hexadecimal
    bytes.map{_1.to_s(16).rjust(2,'0')}.join
  end

  def integer
    hexadecimal.to_i(16)
  end

  def xy
    hex = hexadecimal
    x = hex[0...64].to_i(16)
    y = hex[64..128].to_i(16)
    [x,y]
  end

  def integer2
    # An alternate way to generate an integer
    x,y = xy
    # I think this is Binomial(Gaussian in the limit) around zero?
    x - y
  end

  def float
    Rational(integer, DIV).to_f
  end

  def float2
    # An alternate way to generate a float...
    x,y = xy
    # ...but what distribution is this?
    Rational(x+1,y+1).to_f
  end

  def random_number(scale=1.0)
    case scale
    when Float
      return scale * float
    when Integer
      return ((integer + SecureRandom.random_number(scale)) % scale)
    end
    raise 'rand(scale Integer|Float)'
  end
  alias rand random_number

  class Dice
    private def set_big
      @big = @rng.integer + SecureRandom.random_number(@sides)
    end
    def initialize(sides, minimum:1, rng:SuperRandom.new)
      @sides,@minimum,@rng = sides,minimum,rng
      set_big
    end
    def roll
      @big,roll = @big.divmod(@sides)
      roll+@minimum
    ensure
      set_big unless @big.positive?
    end
  end
  def dice(sides, minimum:1)
    Dice.new(sides, minimum:minimum, rng:self)
  end

  private

  SHASUM = Digest::SHA2.new(512)
  def _get_bytes
    MUTEX.synchronize do
      SHASUM.update SecureRandom.bytes(64)
      SHASUM.digest.chars.map(&:ord)
    end
  ensure
    MUTEX.synchronize{SHASUM.update SecureRandom.bytes(64)}
  end

  # source in @sources may be anything URI.open can handle:
  def _update_with(source)
    URI.open(source) do |tmp|
      MUTEX.synchronize do
        tmp.each_line do |line|
          SHASUM.update line
          @byte_count += line.bytesize
        end
        @source_count += 1
      end
    end
  rescue
    warn $!.message
  end

  def _do_updates
    @@last_time = Time.now.to_i
    threads = @sources.inject([]){|t,s|t.push Thread.new{_update_with s}}
    begin
      # Initially, would like to get them all.
      Timeout.timeout(@first_timeout){threads.each(&:join)}
    rescue Timeout::Error
      begin
        Timeout.timeout(@second_timeout) do
          # But at this point,
          # would like to get at least one.
          Thread.pass while @source_count.zero? && threads.any?(&:alive?)
        end
      rescue Timeout::Error
        MUTEX.synchronize{threads.each(&:exit)} # Exit each thread
        raise $! unless @nevermind # Go on if never-minding
      end
    end
  end
end
