Gem::Specification.new do |s|

  s.name     = 'super_random'
  s.version  = '2.0.210126'

  s.homepage = 'https://github.com/carlosjhr64/super_random'

  s.author   = 'carlosjhr64'
  s.email    = 'carlosjhr64@gmail.com'

  s.date     = '2021-01-26'
  s.licenses = ['MIT']

  s.description = <<DESCRIPTION
You can't get more random than random, but you can try really, really, really hard.

SuperRandom combines three online real random services to create a more perfect random byte.
DESCRIPTION

  s.summary = <<SUMMARY
You can't get more random than random, but you can try really, really, really hard.
SUMMARY

  s.require_paths = ['lib']
  s.files = %w(
README.md
lib/super_random.rb
lib/super_random/generator.rb
lib/super_random/services.rb
  )

  s.requirements << 'ruby: ruby 3.0.0p0 (2020-12-25 revision 95aff21468) [x86_64-linux]'

end
