# SuperRandom

* [VERSION 3.0.230110](https://github.com/carlosjhr64/super_random/releases)
* [github](https://github.com/carlosjhr64/super_random)
* [rubygems](https://rubygems.org/gems/super_random)

## DESCRIPTION:

You can't get more random than random, but you can try really, really, really hard.

`SuperRandom` combines sources of entropy to generate super-random bytes!

## INSTALL:

    $ gem install super_random

## Intended usage:

`SuperRandom` uses `Digest#SHA2.new(512)` to digest your entropy sources.
And uses `OpenUri` to read your sources.
It's only meant to be used sparingly as there's no point in
re-reading sources that may just change daily.
To keep things nice, `SuperRandom` has a hard coded rate limit of one minute.
More frequent calls just make use of `SecureRandom` on top of previous results.

## SYNOPSIS:
```ruby
require 'super_random'
SuperRandom::VERSION              #=> "3.0.230110"
super_random = SuperRandom.new
super_random.sources
#=> ["https://news.google.com", "https://news.yahoo.com", "https://nytimes.com"]
super_random.bytes                #~> ^\[\d+(, \d+){63}\]$
# The `source_count` attribute gives the number of sources successfully used.
# It's possible for a source to fail.
# Ultimately, `SuperRandom` uses `SecureRandom` as a failsafe.
super_random.source_count         #=> 3
# The `byte_count` attribute gives the total bytes digested from sources.
super_random.byte_count           #~> ^\d+$
super_random.hexadecimal          #~> ^\h{128}$
super_random.random_number(100.0) #~> ^\d{1,2}\.\d+$
super_random.random_number(100)   #~> ^\d{1,2}$
# There's a hard coded rate limit of 1 minute for accessing sources
# so the immediate subsequent source counts are zero.
super_random.source_count         #=> 0
super_random.byte_count           #=> 0
# You can specify your own sources.
# Snapshots from your webcam can be a good source:
super_random = SuperRandom.new('/var/lib/motion/lastsnap.jpg')
super_random.sources #=> ["/var/lib/motion/lastsnap.jpg"]
```
## LICENSE:

(The MIT License)

Copyright (c) 2023 carlosjhr64

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
