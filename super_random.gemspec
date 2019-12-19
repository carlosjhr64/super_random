Gem::Specification.new do |s|

  s.name     = 'super_random'
  s.version  = '1.0.0'

  s.homepage = 'https://github.com/carlosjhr64/super_random'

  s.author   = 'carlosjhr64'
  s.email    = 'carlosjhr64@gmail.com'

  s.date     = '2019-12-18'
  s.licenses = ['MIT']

  s.description = <<DESCRIPTION
You can't get more random than random, but you can try really, really, really hard.

SuperRandom combines five online real random services to create a more perfect random byte.
DESCRIPTION

  s.summary = <<SUMMARY
You can't get more random than random, but you can try really, really, really hard.
SUMMARY

  s.require_paths = ['lib']
  s.files = %w(
README.md
lib/super_random.rb
lib/super_random/super_random.rb
  )

  s.requirements << 'ruby: ruby 2.6.5p114 (2019-10-01 revision 67812) [x86_64-linux]'

end
