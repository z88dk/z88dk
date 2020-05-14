#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/441
# z80asm: add command line option for specifying the output directory

use Modern::Perl;
use Test::More;
use File::Find 'finddepth';
require './t/testlib.pl';

my @output = ("test.o", "test.bin", "test.sym", "test.lis", "test.map", "test.def");
spew("test.asm",<<END);
	ret
END

# first run without -O
unlink_output();
run("z80asm -s -l -m -g -b test.asm");
for (@output) {
	ok -f $_, "$_";
}
check_bin_file("test.bin", pack("C*", 0xC9));
ok ! -d "test_dir", "! test_dir";

# second run with -O
for my $opt('-O', '--out-dir') {
	for my $dir ('test_dir', 'test_dir////sub//dir//') {	# use pairs of /, as they will be converted to \ in run()
		unlink_output();
		run("z80asm -s -l -m -g -b $opt=$dir test.asm");
		ok -d $dir, $dir;
		for (@output) {
			ok -f "$dir/$_", "$dir/$_";
		}
		check_bin_file("$dir/test.bin", pack("C*", 0xC9));
	}
}

# make trees
unlink_output();
unlink_testfiles();
mkdir("test_src");
mkdir("test_src/s1");
mkdir("test_src/s1/s2");
spew("test_src/s1/s2/test.asm",<<END);
	ret
END
run("z80asm -s -l -m -g -b -O=test_dir test_src/s1/s2/test.asm");
ok -d "test_dir/test_src/s1/s2", "test_dir/test_src/s1/s2";
for (@output) {
	ok -f "test_dir/test_src/s1/s2/$_", "test_dir/test_src/s1/s2/$_";
}
check_bin_file("test_dir/test_src/s1/s2/test.bin", pack("C*", 0xC9));

finddepth(sub {-f $_ and unlink $_;}, 'test_src');
finddepth(sub {-d $_ and rmdir $_;}, 'test_src');
rmdir("test_src");

unlink_output();
unlink_testfiles();
done_testing();


sub unlink_output {
	finddepth(sub {-f $_ and unlink $_;}, 'test_dir') if -d 'test_dir';
	finddepth(sub {-d $_ and rmdir $_;}, 'test_dir') if -d 'test_dir';
	unlink @output;
	rmdir "test_dir";

	for (@output) {
		ok ! -f $_, "! $_";
	}
	ok ! -d "test_dir", "! test_dir";
}
