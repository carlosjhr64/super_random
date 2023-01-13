require 'timeout'
require 'securerandom'
require 'open-uri'
require 'digest'
# Requires:
#`ruby`

class SuperRandom
  VERSION = '3.0.230113'
  DEFAULT_SOURCES = [
    'https://www.random.org/strings/?num=10&len=20&digits=on&upperalpha=on&loweralpha=on&unique=on&format=plain&rnd=new',
  ]
  MUTEX = Mutex.new
  DIV = 128.times.inject(''){|h,_|h<<'f'}.to_i(16)
  RATE_LIMIT = 60 # One minute, be nice!
  @@LAST_TIME = Time.now.to_i - RATE_LIMIT - 1

  attr_accessor :first_timeout, :second_timeout, :nevermind
  attr_reader   :sources, :source_count, :byte_count
  def initialize(*sources)
    @sources = sources.empty? ? DEFAULT_SOURCES.dup : sources
    @byte_count,@source_count = 0,0
    @first_timeout,@second_timeout,@nevermind = 3,6,true
  end

  # Returns 64 random bytes(at least from SecureRandom's)
  def bytes
    @byte_count,@source_count = 0,0
    _do_updates if Time.now.to_i - @@LAST_TIME > RATE_LIMIT
    _get_bytes
  end

  def hexadecimal
    bytes.map{_1.to_s(16).rjust(2,'0')}.join
  end

  def random_number(scale=1.0)
    case scale
    when Float
      return scale * Rational(hexadecimal.to_i(16), DIV)
    when Integer
      return ((hexadecimal.to_i(16) + SecureRandom.random_number(scale)) % scale)
    end
    raise "rand(scale Integer|Float)"
  end
  alias rand random_number

  private

  SHASUM = Digest::SHA2.new(512)
  def _get_bytes
    MUTEX.synchronize do
      SHASUM.update SecureRandom.bytes(64)
      SHASUM.digest.chars.map{_1.ord}
    end
  ensure
    MUTEX.synchronize{SHASUM.update SecureRandom.bytes(64)}
  end

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
    $stderr.puts $!
  end

  def _do_updates
    @@LAST_TIME = Time.now.to_i
    threads = @sources.inject([]){|t,s|t.push Thread.new{_update_with s}}
    begin
      # Initially, would like to get them all.
      Timeout.timeout(@first_timeout){threads.each{_1.join}}
    rescue Timeout::Error
      begin
        Timeout.timeout(@second_timeout) do
          # But at this point,
          # would like to get at least one.
          while @services<1 and threads.any?{_1.alive?}
            Thread.pass
          end
        end
      rescue Timeout::Error
        Mutex.sychronize{threads.each{_1.exit}} # Exit each thread
        raise $! unless @nevermind # Go on if never-minding
      end
    end
  end
end
