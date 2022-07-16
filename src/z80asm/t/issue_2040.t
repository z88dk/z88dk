#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

#------------------------------------------------------------------------------
# allow filenames with spaces
unlink_testfiles;
path("${test}.dir")->remove_tree;

path("${test}.dir")->mkpath;
spew("${test}.dir/file 1.asm", "ret");

run_ok("z88dk-z80asm -b -l ".quote_os("${test}.dir/file 1.asm"));

ok -f "${test}.dir/file 1.lis", "${test}.dir/file 1.lis exists";
ok -f "${test}.dir/file 1.o", "${test}.dir/file 1.o exists";
ok -f "${test}.dir/file 1.bin", "${test}.dir/file 1.bin exists";
check_bin_file("${test}.dir/file 1.bin", bytes(0xC9));

#------------------------------------------------------------------------------
# allow filenames with spaces and handle quoting in @ files
unlink_testfiles;
path("${test}.dir")->remove_tree;

path("${test}.dir")->mkpath;
spew("${test}.dir/file 1.lst", <<END);
	"${test}.dir/file 1.asm" '${test}.dir/file 2.asm' 	; comment
	${test}.dir/file3.asm								# comment
END
spew("${test}.dir/file 1.asm", "defb 1");
spew("${test}.dir/file 2.asm", "defb 2");
spew("${test}.dir/file3.asm", "defb 3");

run_ok("z88dk-z80asm -b ".quote_os("\@${test}.dir/file 1.lst"));

ok -f "${test}.dir/file 1.o", "${test}.dir/file 1.o exists";
ok -f "${test}.dir/file 2.o", "${test}.dir/file 2.o exists";
ok -f "${test}.dir/file3.o", "${test}.dir/file3.o exists";
ok -f "${test}.dir/file 1.bin", "${test}.dir/file 1.bin exists";
check_bin_file("${test}.dir/file 1.bin", bytes(1, 2, 3));

#------------------------------------------------------------------------------
# allow options mixed with filenames
make_3_asm_files($test);

run_ok("z88dk-z80asm ${test}.1.asm -b ${test}.2.asm -l ${test}.3.asm");

check_3_object_files($test);

#------------------------------------------------------------------------------
# allow options mixed with filenames im @ files
make_3_asm_files($test);

spew("${test}.1.lst", <<END);
; comment ${test}.1.asm
# comment ${test}.2.asm
${test}.1.asm -b ${test}.2.asm	# comment ${test}.1.asm
-l ${test}.3.asm 				; comment ${test}.1.asm
END

run_ok("z88dk-z80asm -b ".quote_os("\@${test}.1.lst"));

check_3_object_files($test);


unlink_testfiles;
path("${test}.dir")->remove_tree;
done_testing;

#------------------------------------------------------------------------------
sub make_3_asm_files {
	my($base) = @_;
	local $Test::Builder::Level = $Test::Builder::Level + 1;

	unlink_testfiles;
	path("${test}.dir")->remove_tree;

	spew("${base}.1.asm", "defb 1");
	spew("${base}.2.asm", "defb 2");
	spew("${base}.3.asm", "defb 3");
}

#------------------------------------------------------------------------------
sub check_3_object_files {
	my($base) = @_;
	local $Test::Builder::Level = $Test::Builder::Level + 1;

	ok -f "${base}.1.o", "${base}.1.o exists";
	ok -f "${base}.2.o", "${base}.2.o exists";
	ok -f "${base}.3.o", "${base}.3.o exists";
	ok -f "${base}.1.lis", "${base}.1.lis exists";
	ok -f "${base}.2.lis", "${base}.2.lis exists";
	ok -f "${base}.3.lis", "${base}.3.lis exists";
	ok -f "${base}.1.bin", "${base}.1.bin exists";
	check_bin_file("${base}.1.bin", bytes(1, 2, 3));
}
