require 'super_random'

# IRB Tools
require 'irbtools/configure'
_ = SuperRandom::VERSION.split('.')[0..1].join('.')
Irbtools.welcome_message = "### SuperRandom(#{_}) ###"
require 'irbtools'
IRB.conf[:PROMPT][:SuperRandom] = {
  PROMPT_I:    '> ',
  PROMPT_N:    '| ',
  PROMPT_C:    '| ',
  PROMPT_S:    '| ',
  RETURN:      "=> %s \n",
  AUTO_INDENT: true,
}
IRB.conf[:PROMPT_MODE] = :SuperRandom
