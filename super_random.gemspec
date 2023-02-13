Gem::Specification.new do |s|
  ## INFO ##
  s.name     = 'super_random'
  s.version  = '3.2.230213'
  s.homepage = 'https://github.com/carlosjhr64/super_random'
  s.author   = 'CarlosJHR64'
  s.email    = 'carlosjhr64@gmail.com'
  s.date     = '2023-02-13'
  s.licenses = ['MIT']
  ## DESCRIPTION ##
  s.summary  = <<~SUMMARY
    You can't get more random than random, but you can try really, really, really hard.
  SUMMARY
  s.description = <<~DESCRIPTION
    You can't get more random than random, but you can try really, really, really hard.
    
    `SuperRandom` combines sources of entropy to generate super-random bytes!
  DESCRIPTION
  ## FILES ##
  s.require_paths = ['lib']
  s.files = %w[
    README.md
    lib/super_random.rb
  ]
  
  ## REQUIREMENTS ##
  s.requirements << 'ruby: 3.2'
end
