class SuperRandom
  DEFAULT_BYTES = 32

  # http://qrng.anu.edu.au/index.php
  # https://qrng.anu.edu.au/API/api-demo.php
  def self.quantum(n)
    s = Net::HTTP.get(URI(
      "https://qrng.anu.edu.au/API/jsonI.php?length=#{n}&type=uint8"))
    a = JSON.parse(s)['data']
    raise unless a.is_a?(Array) and a.length==n
    raise unless a.all?{|i| i.is_a?(Integer) and i.between?(0,255)}
    return a
  rescue StandardError
    warn "quantum (qrng.anu.edu.au) failed."
    return nil
  end

  # https://www.random.org/
  # https://www.random.org/integers/
  def self.atmospheric(n)
    s = Net::HTTP.get(URI(
      "https://www.random.org/integers/?num=#{n}&min=0&max=255&col=1&base=10&format=plain&rnd=new"))
    a = s.strip.split(/\s+/).map{|j|j.to_i}
    raise unless a.length==n
    raise unless a.all?{|i| i.between?(0,255)}
    return a
  rescue StandardError
    warn "atmospheric (www.random.org) failed."
    return nil
  end

  # http://random.hd.org/
  # http://random.hd.org/getBits.jsp
  def self.entropy_pool(n)
    s = Net::HTTP.get(URI(
      "http://random.hd.org/getBits.jsp?numBytes=#{n}&type=bin"))
    a = s.bytes
    # As of the time of this writting, not guaranteed to get more than 8 bytes.
    raise unless (n>8)? a.length.between?(8,n) : a.length==n
    return a
  rescue StandardError
    warn "entropy_pool (random.hd.org) failed."
    return nil
  end

  # https://www.fourmilab.ch/hotbits/
  def self.hotbits(n, k='Pseudorandom')
    s = Net::HTTP.get(URI(
      "https://www.fourmilab.ch/cgi-bin/Hotbits.api?nbytes=#{n}&fmt=bin&apikey=#{k}"))
    a = s.bytes
    raise unless a.length==n
    return a
  rescue StandardError
    warn "hotbits (www.fourmilab.ch) failed."
    return nil
  end

  # http://www.randomnumbers.info
  def self.quantis(n)
    s = Net::HTTP.get(URI(
      "http://www.randomnumbers.info/cgibin/wqrng.cgi?amount=#{n}&limit=255"))
    a = s.scan( /\s\d\d?\d?\b/ ).map{|i| i.to_i}
    raise unless a.length == n and a.all?{|i| i.between?(0,255)}
    return a
  rescue
    warn "quantis (www.randomnumbers.info) failed."
    return nil
  end

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

    a1 = a2 = a3 = a4 = a5 = nil

    t1 = Thread.new{ a1 = SuperRandom.quantum(n)}
    t2 = Thread.new{ a2 = SuperRandom.atmospheric(n)}
    t3 = Thread.new{ a3 = SuperRandom.entropy_pool(n)}
    t4 = Thread.new{ a4 = SuperRandom.hotbits(n)}
    t5 = Thread.new{ a5 = SuperRandom.quantis(n)}

    begin
      Timeout.timeout(@first_timeout) do
        # Initially, would like to get them all.
        t1.join and t2.join and t3.join and t4.join and t5.join
      end
    rescue Timeout::Error
      begin
        Timeout.timeout(@second_timeout) do
          # But at this point,
          # would like to get at least one.
          while [a1,a2,a3,a4,a5].all?{|a|a.nil?} and [t1,t2,t3,t4,t5].any?{|t|t.alive?}
            Thread.pass
          end
        end
      rescue Timeout::Error
        # If we don't care that we got nothing, go on.
        raise $! unless @nevermind
      end
    end

    a = n.times.inject([]){|b,i|b.push(SecureRandom.random_number(256))}
    [a1, a2, a3, a4, a5].each do |b|
      if b
        bl = b.length
        @randomness += bl.to_f/n.to_f
        @services += 1
        n.times{|i|a[i]=(a[i]+b[i%bl])%256}
      end
    end

    return a
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
