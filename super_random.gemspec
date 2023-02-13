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
  s.add_development_dependency 'colorize', '~> 0.8', '>= 0.8.1'
  s.add_development_dependency 'cucumber', '~> 8.0', '>= 8.0.0'
  s.add_development_dependency 'help_parser', '~> 8.2', '>= 8.2.230210'
  s.add_development_dependency 'rubocop', '~> 1.45', '>= 1.45.1'
  s.add_development_dependency 'test-unit', '~> 3.5', '>= 3.5.7'
  s.requirements << 'git: 2.30'
  s.requirements << 'ruby: 3.2'
end
