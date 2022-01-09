#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

# test1.sh
mkdir "t2/1573/output";
unlink <t2/1573/output/*>;
run_ok("cd t2/1573/input; ../../../z88dk-z80asm -O../output -b -l -g -m -reloc-info file1.asm file2.asm");

capture_ok("ls t2/1573/input", <<END);
file1.asm
file2.asm
END

got_file("t2/1573/output/file1.o");
got_file("t2/1573/output/file1.lis");

got_file("t2/1573/output/file2.o");
got_file("t2/1573/output/file2.lis");

got_file("t2/1573/output/file1.def");
got_file("t2/1573/output/file1.bin");
got_file("t2/1573/output/file1.map");
got_file("t2/1573/output/file1.reloc");

capture_ok("ls t2/1573/output", "");


# test2.sh
unlink <t2/1573/output/*>;
run_ok("cd t2/1573/input; ../../../z88dk-z80asm -O../output -ofoobar.bin -b -l -g -m -reloc-info file1.asm file2.asm");

capture_ok("ls t2/1573/input", <<END);
file1.asm
file2.asm
END

got_file("t2/1573/output/file1.o");
got_file("t2/1573/output/file1.lis");

got_file("t2/1573/output/file2.o");
got_file("t2/1573/output/file2.lis");

got_file("t2/1573/output/foobar.def");
got_file("t2/1573/output/foobar.bin");
got_file("t2/1573/output/foobar.map");
got_file("t2/1573/output/foobar.reloc");

capture_ok("ls t2/1573/output", "");


unlink_testfiles;
done_testing;

sub got_file {
	my($file) = @_;
	local $Test::Builder::Level = $Test::Builder::Level + 1;

	ok -f $file, "got $file";
	unlink $file;
}
