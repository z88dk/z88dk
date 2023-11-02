#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Build ZX Spectrum 48K ROM, compare result

my $ROM = 			slurp("t/data/zx48.rom");
my $patched_src = 	"${test}.asm";
my $obj = 	  		"${test}.o";
my $bin = 	  		"${test}.bin";
my $reloc =	  		"${test}.reloc";
my $map = 	  		"${test}.map";
my $sym = 	  		"${test}.sym";

# patch original source to comply with z80asm syntax
# Note: this step should not be required
my $source = slurp("t/data/zx48.asm");
for ($source) {
    s/^(\#(define|end))/;$1/gm;
    s/ORG\s+\$3D00//gm;
	s/^(ORG)/\t$1/igm;
    s/^([a-z]\w*) /$1:/igm;
}
spew("${test}.asm", $source);

# assemble as one source file
capture_ok("z88dk-z80asm -b $patched_src", "");
check_bin_file($bin, $ROM);


# assemble with separate modules
capture_ok("z88dk-z80asm -b ".quote_os("\@t/data/zx48_01.lst"), "");
check_bin_file("t/data/zx48_01.bin", $ROM);

unlink_testfiles("t/data/zx48_01.bin", <t/data/zx48_*.o>);
done_testing;
