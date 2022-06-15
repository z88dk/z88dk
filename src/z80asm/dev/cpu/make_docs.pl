#!/usr/bin/env perl

use Modern::Perl;
use Path::Tiny;

my $opcodes = path("opcodes.txt")->slurp;

open(my $md, ">", "Tool---z80asm---opcodes.md") or die $!;

print $md <<END;
## Recognized Opcodes
[[Top](Tool---z80asm)]

*z80asm* recognizes the following opcodes:

```
$opcodes
```
END
