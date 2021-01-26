class SuperRandom
  def self.services
    [:quantum, :atmospheric, :hotbits]
  end

  # https://qrng.anu.edu.au/
  # https://qrng.anu.edu.au/contact/api-documentation/
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
end
