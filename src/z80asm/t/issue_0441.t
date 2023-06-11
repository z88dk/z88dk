#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/441
# z80asm: add command line option for specifying the output directory

my $test_dir = "${test}_dir";

my @output_lib = (
	"${test}.o", 
	"${test}.sym", 
	"${test}.lis");
my @output_bin = (
	@output_lib,
	"${test}.map", 
	"${test}.def", 
	"${test}.bin");

my $asm = <<END;
	ret
END

my $bin = bytes(0xC9);

# first run without -O, make bin
unlink_testfiles;
path($test_dir)->remove_tree;
spew("${test}.asm", $asm);

run_ok("z88dk-z80asm -b -s -l -m -g ${test}.asm");
check_bin_file("${test}.bin", $bin);

for (@output_bin) {
	ok -f $_, "$_ exists";
}
ok ! -d "${test_dir}", "no ${test_dir}";

# first run without -O, make library
unlink_testfiles;
path($test_dir)->remove_tree;
spew("${test}.asm", $asm);

run_ok("z88dk-z80asm -x${test}.lib -s -l -m -g ${test}.asm");
ok -f "${test}.lib", "${test}.lib";

for (@output_lib) {
	ok -f $_, "$_ exists";
}

# second run with -O, make bin
for my $dir ("${test_dir}", "${test_dir}/sub/dir/") {
	unlink_testfiles;
	spew("${test}.asm", $asm);
	
	run_ok("z88dk-z80asm -b -s -l -m -g -O${dir} ${test}.asm");
	check_bin_file("${dir}/${test}.bin", $bin);

	ok -d ${dir}, ${dir};
	for (@output_bin) {
		ok -f "$dir/$_", "$dir/$_";
	}
	path($test_dir)->remove_tree if Test::More->builder->is_passing;
}

# second run with -O, make lib
for my $dir ("${test_dir}", "${test_dir}/sub/dir/") {
	unlink_testfiles;
	spew("${test}.asm", $asm);
	
	run_ok("z88dk-z80asm -x${test}.lib -s -l -m -g -O${dir} ${test}.asm");
	ok -f "${test}.lib", "${test}.lib";

	ok -d ${dir}, ${dir};
	for (@output_lib) {
		ok -f "$dir/$_", "$dir/$_";
	}
	path($test_dir)->remove_tree if Test::More->builder->is_passing;
}

# make trees, make bin
unlink_testfiles;
path($test_dir)->remove_tree;
path("${test_dir}/src/s1/s2")->mkpath;
spew("${test_dir}/src/s1/s2/${test}.asm", $asm);

my $output_dir = "${test_dir}/bin/${test_dir}/src/s1/s2";

run_ok("z88dk-z80asm -b -s -l -m -g ".
	   "-O${test_dir}/bin ${test_dir}/src/s1/s2/${test}.asm");
check_bin_file("${output_dir}/${test}.bin", $bin);

ok -d "${output_dir}", "${output_dir}";

for (@output_bin) {
	ok -f "${output_dir}/$_", "${output_dir}/$_ exists";
}

# make trees, make lib
unlink_testfiles;
path($test_dir)->remove_tree;
path("${test_dir}/src/s1/s2")->mkpath;
spew("${test_dir}/src/s1/s2/${test}.asm", $asm);

$output_dir = "${test_dir}/bin/${test_dir}/src/s1/s2";

run_ok("z88dk-z80asm -x${test}.lib -s -l -m -g ".
	   "-O${test_dir}/bin ${test_dir}/src/s1/s2/${test}.asm");
ok -f "${test}.lib", "${test}.lib";

ok -d "${output_dir}", "${output_dir}";

for (@output_lib) {
	ok -f "${output_dir}/$_", "${output_dir}/$_ exists";
}

# make trees, make bin, source and object in different dirs
unlink_testfiles;
path($test_dir)->remove_tree;
spew("${test}.asm", $asm);

$output_dir = "${test_dir}/obj";

run_ok("z88dk-z80asm -b -s -l -m -g ".
	   "-O${test_dir}/obj ${test}.asm");
check_bin_file("${output_dir}/${test}.bin", $bin);

ok -d "${output_dir}", "${output_dir}";

for (@output_bin) {
	ok -f "${output_dir}/$_", "${output_dir}/$_ exists";
}

# make trees, make lib, source and object in different dirs
unlink_testfiles;
path($test_dir)->remove_tree;
spew("${test}.asm", $asm);

$output_dir = "${test_dir}/obj";

run_ok("z88dk-z80asm -x${test}.lib -s -l -m -g ".
	   "-O${test_dir}/obj ${test}.asm");
ok -f "${test}.lib", "${test}.lib";

ok -d "${output_dir}", "${output_dir}";

for (@output_lib) {
	ok -f "${output_dir}/$_", "${output_dir}/$_ exists";
}

unlink "${test}.lib";
run_ok("z88dk-z80asm -d -x${test}.lib -s -l -m -g ".
	   "-O${test_dir}/obj ${test}.o");
ok -f "${test}.lib", "${test}.lib";

# use absolute path as input
unlink_testfiles;
path($test_dir)->remove_tree;
path("${test_dir}/src/s1/s2")->mkpath;
spew("${test_dir}/src/s1/s2/${test}.asm", $asm);

my $source_dir = path("${test_dir}/src/s1/s2")->absolute;
if ($^O eq 'msys') {
	chomp(my $abs_path = `cygpath -m -a '${test_dir}/src/s1/s2'`);
	$abs_path =~ s/://g;
	$output_dir = "${test_dir}/bin/${abs_path}";
}
elsif ($^O eq 'MSWin32') {
	$output_dir = "${test_dir}/bin/${source_dir}";
	$output_dir =~ s/://g;
}
else {
	$output_dir = "${test_dir}/bin/${source_dir}";
}

run_ok("z88dk-z80asm -b -s -l -m -g ".
	   "-O${test_dir}/bin ${source_dir}/${test}.asm");
check_bin_file("${output_dir}/${test}.bin", $bin);

ok -d "${output_dir}", "${output_dir}";

for (@output_bin) {
	ok -f "${output_dir}/$_", "${output_dir}/$_ exists";
}

# use ** for files and directories
# need to use list file to avoid the shell parsing the **
unlink_testfiles;
path($test_dir)->remove_tree;
path("${test_dir}/src/s1/s2")->mkpath;
spew("${test_dir}/src/s1/s2/${test}.asm", $asm);
spew("${test}.lis", "${test_dir}/**");

run_ok("z88dk-z80asm -b -s -l -m -g ".quote_os("\@${test}.lis"));
check_bin_file("${test_dir}/src/s1/s2/${test}.bin", $bin);

for (@output_bin) {
	ok -f "${test_dir}/src/s1/s2/$_", "${test_dir}/src/s1/s2/$_ exists";
}

# error if ** returns no files
unlink_testfiles;
path($test_dir)->remove_tree;
path("${test_dir}/src/s1/s2")->mkpath;
spew("${test}.lis", "${test_dir}/**");
capture_nok("z88dk-z80asm -b -s -l -m -g ".quote_os("\@${test}.lis"), <<END);
${test}.lis:2: error: source file expected
END

path($test_dir)->remove_tree if Test::More->builder->is_passing;
unlink_testfiles;
done_testing;
