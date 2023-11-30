#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2469
# z80asm using $ from incorrect section when computing using defc constant

my %map;

capture_ok("z88dk-z80asm -mz80n -b -m -o$test.bin -DFAIL_TEST t/2469/SpriteData_Boulder.asm t/2469/SpriteData_Boulder2.asm", "");
%map = read_map_file("$test.map");
is $map{_Boulder2PalettePage}, 0x0037;
is $map{_Boulder2PalettePage2}, 0x0037;
is $map{_Boulder2PalettePage3}, 0x0037;

capture_ok("z88dk-z80asm -mz80n -b -m -o$test.bin t/2469/SpriteData_Boulder.asm t/2469/SpriteData_Boulder2.asm", "");
%map = read_map_file("$test.map");
is $map{_Boulder2PalettePage}, 0x0037;
is $map{_Boulder2PalettePage2}, 0x0037;
is $map{_Boulder2PalettePage3}, 0x0037;

unlink_testfiles(<t/2469/*.o>);
done_testing;
