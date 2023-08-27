#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/795
# Missing .lst file within lst file doesn't error

spew("${test}1.asm", "defb 1");
spew("${test}2.asm", "defb 2");
spew("${test}1.lst", <<END);
${test}1.asm
\@${test}2.lst
${test}2.asm
END
unlink "${test}2.lst";

capture_nok("z88dk-z80asm -b -o${test}.bin ".quote_os("\@${test}1.lst"), <<END);
${test}1.lst:2: error: file not found: ${test}2.lst
  ^---- \@${test}2.lst
END

spew("${test}1.lst", <<END);
${test}1.asm
\@${test}2*.lst
${test}2.asm
END
unlink "${test}2.lst";

capture_nok("z88dk-z80asm -b -o${test}.bin ".quote_os("\@${test}1.lst"), <<END);
${test}1.lst:2: error: pattern returned no files: ${test}2*.lst
  ^---- \@${test}2*.lst
END

unlink_testfiles;
done_testing;
