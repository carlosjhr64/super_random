# SuperRandom

* [github](https://www.github.com/carlosjhr64/super_random)
* [rubygems](https://rubygems.org/gems/super_random)

## DESCRIPTION:

You can't get more random than random, but you can try really, really, really hard.

SuperRandom combines five online real random services to create a more perfect random byte.

## SYNOPSIS:

    require 'super_random' #=> true
    super_random = SuperRandom.new # => #<SuperRandom:...

    # bytes returns 32 bytes by default (256 bits).
    super_random.bytes # => [123, 219, 128, ...,  248, 164, 100]

    # hexadecimal returns a 32 bytes hexadecimal by default.
    super_random.hexadecimal #=> "2ae...37b"

    # rand as the typical use
    super_random.rand #=> 0.16882225652425537
    super_random.rand(100) #=> 85

    # The "services" attribute gives the number of online services used.
    # It's possible for a service to fail.
    # Ultimately, SuperRandom uses SecureRandom as a failsafe.
    super_random.services #=> 5

## INSTALL:

    $ gem install super_random

## LICENSE:

(The MIT License)

Copyright (c) 2017 carlosjhr64

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
