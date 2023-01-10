Gem::Specification.new do |s|

  s.name     = 'super_random'
  s.version  = '3.0.230110'

  s.homepage = 'https://github.com/carlosjhr64/super_random'

  s.author   = 'carlosjhr64'
  s.email    = 'carlosjhr64@gmail.com'

  s.date     = '2023-01-10'
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

  s.requirements << 'ruby: ruby 3.2.0 (2022-12-25 revision a528908271) [aarch64-linux]'

end
