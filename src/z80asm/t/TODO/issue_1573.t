#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# https://github.com/z88dk/z88dk/issues/1573
# z80asm: -O doesn't affect location of .def, .o, or .map files

mkdir "t/1573/output";
unlink <t/1573/output/*>;
chdir("t/1573/input") or die;
{
	local $ENV{PATH} = join($Config{path_sep}, 
				"../../..",
				"../../../../../bin",
				$ENV{PATH});

	run_ok("z88dk-z80asm -O../output -b -l -g -m -reloc-info file1.asm file2.asm");
}
chdir("../../..") or die;

list_files_ok("t/1573/input", qw( 
file1.asm
file2.asm
));

got_file("t/1573/output/file1.o");
got_file("t/1573/output/file1.lis");

got_file("t/1573/output/file2.o");
got_file("t/1573/output/file2.lis");

got_file("t/1573/output/file1.def");
got_file("t/1573/output/file1.bin");
got_file("t/1573/output/file1.map");
got_file("t/1573/output/file1.reloc");

list_files_ok("t/1573/output", ());


# test2.sh
unlink <t/1573/output/*>;
chdir("t/1573/input") or die;
{
	local $ENV{PATH} = join($Config{path_sep}, 
				"../../..",
				"../../../../../bin",
				$ENV{PATH});

	run_ok("z88dk-z80asm -O../output -ofoobar.bin -b -l -g -m -reloc-info file1.asm file2.asm");
}
chdir("../../..") or die;

list_files_ok("t/1573/input", qw(
file1.asm
file2.asm
));

got_file("t/1573/output/file1.o");
got_file("t/1573/output/file1.lis");

got_file("t/1573/output/file2.o");
got_file("t/1573/output/file2.lis");

got_file("t/1573/output/foobar.def");
got_file("t/1573/output/foobar.bin");
got_file("t/1573/output/foobar.map");
got_file("t/1573/output/foobar.reloc");

list_files_ok("t/1573/output", ());


unlink_testfiles;
done_testing;

sub got_file {
	my($file) = @_;
	local $Test::Builder::Level = $Test::Builder::Level + 1;

	ok -f $file, "got $file";
	unlink $file;
}

sub list_files_ok {
	my($dir, @expected) = @_;
	local $Test::Builder::Level = $Test::Builder::Level + 1;

	my @files = sort map {$_=$_->basename} path($dir)->children;
	is_deeply \@files, \@expected, "found expected files";
}
