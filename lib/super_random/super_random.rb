class SuperRandom

  def self.randbyte(r,n,s)
    return r.randbyte(n)
  rescue Exception
    warn "RealRand's #{s} failed."
    return nil
  end

  attr_accessor :first_timeout, :second_timeout, :length, :nevermind, :randomness
  def initialize
    @first_timeout = 3
    @second_timeout = 6
    @nevermind = true
    @randomness = 0
  end

  def bytes(n=32)
    @randomness = 0

    r1 = RealRand::RandomOrg.new
    r2 = RealRand::EntropyPool.new
    r3 = RealRand::FourmiLab.new

    a1 = a2 = a3 = nil

    t1 = Thread.new{ a1 = SuperRandom.randbyte(r1,n,'RandomOrg') }
    t2 = Thread.new{ a2 = SuperRandom.randbyte(r2,n,'EntropyPool') }
    t3 = Thread.new{ a3 = SuperRandom.randbyte(r3,n,'FourmiLab') }

    begin
      Timeout.timeout(@first_timeout) do
        # Initially, would like to get them all.
        t1.join and t2.join and t3.join
      end
    rescue Timeout::Error
      begin
        Timeout.timeout(@second_timeout) do
          # But at this point,
          # would like to get at least one.
          while a1.nil? and a2.nil? and a3.nil? and (t1.alive? or t2.alive? or t3.alive?)
            Thread.pass
          end
        end
      rescue Timeout::Error
        # If we don't care that we got nothing, go on.
        raise $! unless @nevermind
      end
    end

    a = n.times.inject([]){|b,i|b.push(SecureRandom.random_number(256))}

    [a1, a2, a3].each do |b|
      if b
        @randomness += 1
        n.times{|i|a[i]=(a[i]+b[i])%256}
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
