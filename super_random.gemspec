Gem::Specification.new do |s|

  s.name     = 'super_random'
  s.version  = '0.0.3'

  s.homepage = 'https://github.com/carlosjhr64/super_random'

  s.author   = 'carlosjhr64'
  s.email    = 'carlosjhr64@gmail.com'

  s.date     = '2015-12-16'
  s.licenses = ['MIT']

  s.description = <<DESCRIPTION
You can't get more random than random, but you can try really, really, really hard.

SuperRandom combines RealRand's three online real random services to create a more perfect random byte.
DESCRIPTION

  s.summary = <<SUMMARY
You can't get more random than random, but you can try really, really, really hard.
SUMMARY

  s.extra_rdoc_files = ['README.rdoc']
  s.rdoc_options     = ["--main", "README.rdoc"]

  s.require_paths = ["lib"]
  s.files = %w(
README.rdoc
lib/super_random.rb
lib/super_random/super_random.rb
lib/super_random/version.rb
  )

  s.add_runtime_dependency 'realrand', '~> 2.0', '>= 2.0.1'
  s.requirements << 'ruby: ruby 2.2.3p173 (2015-08-18 revision 51636) [x86_64-linux]'

end
