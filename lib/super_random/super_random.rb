class SuperRandom

  def self.quantum(n)
    s = Net::HTTP.get(URI(
      "https://qrng.anu.edu.au/API/jsonI.php?length=#{n}&type=uint8"))
    a = JSON.parse(s)['data']
    raise unless a.is_a?(Array) and a.length==n
    raise unless a.all?{|i| i.is_a?(Integer) and i>-1 and i<256}
    return a
  rescue StandardError
    warn "quantum (qrng.anu.edu.au) failed."
    return nil
  end

  def self.atmospheric(n)
    s = Net::HTTP.get(URI(
      "https://www.random.org/integers/?num=#{n}&min=0&max=255&col=1&base=10&format=plain&rnd=new"))
    a = s.strip.split(/\s+/).map{|j|j.to_i}
    raise unless a.length==n
    raise unless a.all?{|i| i>-1 and i<256}
    return a
  rescue StandardError
    warn "atmospheric (www.random.org) failed."
    return nil
  end

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

  attr_accessor :first_timeout, :second_timeout, :nevermind
  attr_reader :randomness, :services

  def initialize
    @first_timeout = 3
    @second_timeout = 6
    @nevermind = true
    @randomness = 0.0
    @services = 0
  end

  def bytes(n=32)
    @randomness = 0.0
    @services = 0

    a1 = a2 = a3 = a4 = nil

    t1 = Thread.new{ a1 = SuperRandom.quantum(n)}
    t2 = Thread.new{ a2 = SuperRandom.atmospheric(n)}
    t3 = Thread.new{ a3 = SuperRandom.entropy_pool(n)}
    t4 = Thread.new{ a4 = SuperRandom.hotbits(n)}

    begin
      Timeout.timeout(@first_timeout) do
        # Initially, would like to get them all.
        t1.join and t2.join and t3.join and t4.join
      end
    rescue Timeout::Error
      begin
        Timeout.timeout(@second_timeout) do
          # But at this point,
          # would like to get at least one.
          while a1.nil? and a2.nil? and a3.nil? and a4.nil?
              (t1.alive? or t2.alive? or t3.alive? or t4.alive?)
            Thread.pass
          end
        end
      rescue Timeout::Error
        # If we don't care that we got nothing, go on.
        raise $! unless @nevermind
      end
    end

    a = n.times.inject([]){|b,i|b.push(SecureRandom.random_number(256))}
    [a1, a2, a3, a4].each do |b|
      if b
        bl = b.length
        @randomness += bl.to_f/n.to_f
        @services += 1
        n.times{|i|a[i]=(a[i]+b[i%bl])%256}
      end
    end

    return a
  end

  def hexadecimal(n=32)
    bytes(n).map{|i|i.to_s(16).rjust(2,'0')}.join
  end

  def rand(m=nil, n=6)
    div = n.times.inject(''){|s,i| s+'FF'}.to_i(16).to_f
    r = hexadecimal(n).to_i(16).to_f / div
    m.nil? ? r : (m*r).to_i
  end
end
