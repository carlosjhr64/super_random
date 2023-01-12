# SuperRandom

* [VERSION 3.0.230112](https://github.com/carlosjhr64/super_random/releases)
* [github](https://github.com/carlosjhr64/super_random)
* [rubygems](https://rubygems.org/gems/super_random)

## DESCRIPTION:

You can't get more random than random, but you can try really, really, really hard.

`SuperRandom` combines sources of entropy to generate super-random bytes!

## INSTALL:

    $ gem install super_random

## SYNOPSIS:
```ruby
require 'super_random'
SuperRandom::VERSION              #=> "3.0.230112"
SuperRandom::DEFAULT_SOURCES      #~> www.random.org
super_random = SuperRandom.new
super_random.sources              #~> www.random.org
super_random.bytes                #~> ^\[\d+(, \d+){63}\]$
# The source_count attribute gives the number of sources successfully used.
super_random.source_count         #=> 1
# The byte_count attribute gives the total bytes digested from sources.
super_random.byte_count           #=> 210
super_random.hexadecimal          #~> ^\h{128}$
super_random.random_number(100.0) #~> ^\d{1,2}\.\d+$
super_random.random_number(100)   #~> ^\d{1,2}$
# Because of a 1 minute rate limit, subsequent source counts are zero:
super_random.source_count         #=> 0
super_random.byte_count           #=> 0
# Snapshots from your webcam can be a good entropy source:
super_random = SuperRandom.new('/var/lib/motion/lastsnap.jpg')
super_random.sources #=> ["/var/lib/motion/lastsnap.jpg"]
```
## METHODOLOGY:

`SuperRandom` uses `OpenUri` to read your sources, which
can be http, https, or ftp URLs.
`Digest::SHA2.new(512)` is used to digest your sources.
Finally, `SecureRandom.bytes` are fed to the digest as a fail safe.
This generates the final 64 random bytes.

## SOURCES:

I could only find one good source expressly for this purpose, `www.random.org`.
Another good one is `qrng.anu.edu.au`, but you'll need an API key.
Consider using:

* Snapshots from your webcam
* List of market spot prices
* Weather forecasts
* News or micro-logging feeds

Be very nice about your calls,
specially when you're not using the source as intended.
`SuperRandom` enforces a one minute rate limit in the use of sources.
Here are ways to set custom sources:
```ruby
# Sources specified in the constructor: 
super_random = SuperRandom.new('/var/lib/motion/lastsnap.jpg', 'https://wttr.in')
super_random.sources
#=> ["/var/lib/motion/lastsnap.jpg", "https://wttr.in"]

# Sources appended on the instance: 
super_random.sources.append 'https://text.npr.org'
super_random.sources
#=> ["/var/lib/motion/lastsnap.jpg", "https://wttr.in", "https://text.npr.org"]

# Sources appended to the DEFAULT_SOURCES
SuperRandom::DEFAULT_SOURCES.append 'https://coinmarketcap.com'
super_random = SuperRandom.new
super_random.sources
#~> random.org.*coinmarketcap.com
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
