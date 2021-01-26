class SuperRandom
  DEFAULT_BYTES = 32

  attr_accessor :first_timeout, :second_timeout, :nevermind
  attr_reader :randomness, :services

  def initialize
    @first_timeout = 3
    @second_timeout = 6
    @nevermind = true
    @randomness = 0.0
    @services = 0
  end

  def bytes(n=DEFAULT_BYTES)
    @randomness = 0.0
    @services = 0

    m = SuperRandom.services
    a = Array.new m.length
    t = Array.new m.length
    m.each_with_index do |k,i|
      t[i] = Thread.new{ a[i] = SuperRandom.send(k, n) }
    end

    begin
      Timeout.timeout(@first_timeout) do
        # Initially, would like to get them all.
        t.each{_1.join}
      end
    rescue Timeout::Error
      begin
        Timeout.timeout(@second_timeout) do
          # But at this point,
          # would like to get at least one.
          while a.all?{_1.nil?} and t.any?{_1.alive?}
            Thread.pass
          end
        end
      rescue Timeout::Error
        # If we don't care that we got nothing, go on.
        raise $! unless @nevermind
      end
    end

    r = Array.new n
    n.times{|i| r[i] = SecureRandom.random_number(256)}

    a.each do |b|
      next if b.nil?
      l = b.length
      @randomness += l.to_f/n.to_f
      @services += 1
      n.times{|i|r[i]=(r[i]+b[i%l])%256}
    end

    return r
  end

  def hexadecimal(n=DEFAULT_BYTES)
    bytes(n).map{|i|i.to_s(16).rjust(2,'0')}.join
  end

  def random_number(scale=1.0, minbytes=6, maxbytes=[minbytes,DEFAULT_BYTES].max)
    case scale
    when Float
      div = minbytes.times.inject(''){|s,i| s+'FF'}.to_i(16)
      den = hexadecimal(minbytes).to_i(16)
      return  scale * den.to_f / div.to_f
    when Integer
      n = n0 = Math.log(scale, 256).ceil
      e = e0 = 256**n
      r = r0 = e0 % scale
      while r > 0
        n0 += 1
        e0 *= 256
        r0 = e0 % scale
        if r0 <= r
          # break if repeating pattern with big enough integer
          break if r0 == r and n0 > minbytes
          r,n,e = r0,n0,e0
        end
        break if n0 >= maxbytes
      end
      max = (e/scale)*scale
      loop do
        number = hexadecimal(n).to_i(16)
        return number % scale if number < max
        # On a relatively small chance that we're above max...
        if @nevermind
          warn "using SecureRandom.random_number(#{scale})"
          return SecureRandom.random_number(scale)
        end
      end
    end
    raise "rand(scale Integer|Float)"
  end
  alias rand random_number
end
