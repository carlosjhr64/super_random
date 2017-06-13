Gem::Specification.new do |s|

  s.name     = 'super_random'
  s.version  = '0.2.0'

  s.homepage = 'https://github.com/carlosjhr64/super_random'

  s.author   = 'carlosjhr64'
  s.email    = 'carlosjhr64@gmail.com'

  s.date     = '2017-06-13'
  s.licenses = ['MIT']

  s.description = <<DESCRIPTION
You can't get more random than random, but you can try really, really, really hard.

SuperRandom combines RealRand's three online real random services to create a more perfect random byte.
DESCRIPTION

  s.summary = <<SUMMARY
You can't get more random than random, but you can try really, really, really hard.
SUMMARY

  s.extra_rdoc_files = ['README.rdoc']
  s.rdoc_options     = ['--main', 'README.rdoc']

  s.require_paths = ['lib']
  s.files = %w(
README.rdoc
lib/super_random.rb
lib/super_random/super_random.rb
lib/super_random/version.rb
  )

  s.add_runtime_dependency 'realrand', '~> 2.0', '>= 2.0.2'
  s.requirements << 'ruby: ruby 2.3.3p222 (2016-11-21 revision 56859) [x86_64-linux]'

end
