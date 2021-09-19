#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

# z80asm: Can't generate labels with > 255 characters
# https://github.com/z88dk/z88dk/issues/1856

for my $len (255, 256, 1023, 1024, 8192) {
#for my $len (255) {
	my $var1 = "x" x $len;
	my $var2 = "y" x $len;
	my $module = "m" x $len;
	my $section = "s" x $len;
	my $file = "f" x $len;
	path("$test.asm")->spew(<<END);
		module $module
		extern $var1, $var2
		section $section
		line $len, "$file"
		defw $var1, $var2
END
	path("$test-1.asm")->spew(<<END);
		public $var1
		extern $var2
		defc $var1 = 0+$var2
END
	path("$test-2.asm")->spew(<<END);
		public $var2
		defc $var2 = $len
END
	note $len;
	capture_ok("z88dk-z80asm $test.asm $test-1.asm $test-2.asm", "");
	capture_ok("z88dk-z80asm -b $test.o $test-1.o $test-2.o", "");
	check_bin_file("$test.bin", words($len, $len));
}

#unlink_testfiles;
done_testing;
