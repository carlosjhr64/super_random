# SuperRandom

* [VERSION 2.0.221231](https://github.com/carlosjhr64/super_random/releases)
* [github](https://github.com/carlosjhr64/super_random)
* [rubygems](https://rubygems.org/gems/super_random)

## DESCRIPTION:

You can't get more random than random, but you can try really, really, really hard.

SuperRandom combines three online real random services to create a more perfect random byte.

## INSTALL:

    $ gem install super_random

## SYNOPSIS:

```ruby
require 'super_random'
super_random = SuperRandom.new

super_random.bytes(32) #~> ^\[\d+(, \d+){31}\]$
# Example:
# [142, 36, 107, 199, 1, 222, 69, 238, 130, 159, 236, 201, 199,
#   33, 237, 166, 189, 166, 95, 246, 111, 103, 113, 126, 27, 31,
#  244, 215, 200, 60, 255, 184]

sleep 1 # rate limit to be nice
super_random.hexadecimal(32) #~> ^\h{64}$
# Example:
# "3e0dffe42c08b849dc3c1290e7aa87dff4ad3037b29694136786a4db1e3efab8"

sleep 1
super_random.random_number(100.0) #~> ^\d{1,2}\.\d+$
# Example:
# 16.882225652425537

sleep 1
super_random.random_number(100) #~> ^\d{1,2}$
# Example:
# 85

# The "services" attribute gives the number of online services used.
# It's possible for a service to fail.
# Ultimately, SuperRandom uses SecureRandom as a failsafe.
super_random.services   #=> 3
super_random.randomness #=> 3.0
```

## LICENSE:

(The MIT License)

Copyright (c) 2022 carlosjhr64

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
