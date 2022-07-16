#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/441
# z80asm: add command line option for specifying the output directory

my $test_dir = "${test}_dir";

my @output = (
	"${test}.o", 
	"${test}.bin", 
	"${test}.sym", 
	"${test}.lis", 
	"${test}.map", 
	"${test}.def");

my $asm = <<END;
	ret
END

my $bin = bytes(0xC9);


# first run without -O
unlink_testfiles;
path($test_dir)->remove_tree;
spew("${test}.asm", $asm);

run_ok("z88dk-z80asm -b -s -l -m -g ${test}.asm");
check_bin_file("${test}.bin", $bin);

for (@output) {
	ok -f $_, "$_";
}
ok ! -d "${test_dir}", "no ${test_dir}";

# second run with -O
for my $dir ("${test_dir}", "${test_dir}/sub/dir/") {
	unlink_testfiles;
	spew("${test}.asm", $asm);
	
	run_ok("z88dk-z80asm -b -s -l -m -g -O${dir} ${test}.asm");
	check_bin_file("${dir}/${test}.bin", $bin);

	ok -d ${dir}, ${dir};
	for (@output) {
		ok -f "$dir/$_", "$dir/$_";
	}
	path($test_dir)->remove_tree if Test::More->builder->is_passing;
}

# make trees
unlink_testfiles;
path($test_dir)->remove_tree;
path("${test_dir}/src/s1/s2")->mkpath;
spew("${test_dir}/src/s1/s2/${test}.asm", $asm);

my $output_dir = "${test_dir}/bin/${test_dir}/src/s1/s2";

run_ok("z88dk-z80asm -b -s -l -m -g ".
	   "-O${test_dir}/bin ${test_dir}/src/s1/s2/${test}.asm");
check_bin_file("${output_dir}/${test}.bin", $bin);

ok -d "${output_dir}", "${output_dir}";

for (@output) {
	ok -f "${output_dir}/$_", "${output_dir}/$_";
}

unlink_testfiles;
path($test_dir)->remove_tree;
done_testing;
