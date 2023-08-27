#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test source lists (@files)

make_test_files();
capture_ok("z88dk-z80asm -b ${test}1.asm ${test}2.asm ${test}3.asm ${test}4.asm", "");
check_bin_file("${test}1.bin", bytes(1..4));


# list file with blank lines and comments
make_test_files();
spew("${test}1.lst", <<END);
; comment followed by blank line

# comment
 ${test}2.asm 
 \@${test}2.lst 
 ; comment
END

# list file with different EOL chars
spew("${test}2.lst", 
	"\r\r\n\n  ".
	"${test}3.asm".
	"  \r\r\n\n    ".
	"${test}4.asm".
	"\n");

capture_ok("z88dk-z80asm -b ${test}1.asm ".quote_os("\@${test}1.lst"), "");
check_bin_file("${test}1.bin", bytes(1..4));


# recursive includes
make_test_files();
spew("${test}1.lst", 
	"\r\r\n\n  ".
	"${test}2.asm".
	"  \r\r\n\n  ".
	"\@${test}2.lst");
	
spew("${test}2.lst", 
	"\r\r\n\n  ".
	"${test}2.asm".
	"  \r\r\n\n  \@".
	"${test}1.lst");
	
capture_nok("z88dk-z80asm -b ${test}1.asm ".quote_os("\@${test}1.lst"), <<END);
${test}2.lst:7: error: include recursion: ${test}1.lst
  ^---- \@${test}1.lst
END


# expand environment variables in sources and list files
make_test_files();
$ENV{TEST_ENV} = $test;

capture_ok("z88dk-z80asm -b ".
		   quote_os("\${TEST_ENV}1.asm")." ".
		   quote_os("\${TEST_ENV}2.asm")." ".
		   quote_os("\${TEST_ENV}3.asm")." ".
		   quote_os("\${TEST_ENV}4.asm"), "");
check_bin_file("${test}1.bin", bytes(1..4));


# expand environment variables in list files
make_test_files();
spew("${test}1.lst", <<END);
  \${TEST_ENV}1.asm
  \${TEST_ENV}2.asm

# see #440
\@\${TEST_ENV}2.lst
END

spew("${test}2.lst", <<END);
  \${TEST_ENV}3.asm
  \${TEST_ENV}4.asm
END

capture_ok("z88dk-z80asm -b ".quote_os("\@${test}1.lst"), "");
check_bin_file("${test}1.bin", bytes(1..4));


# non-existent environment variable is empty
delete $ENV{TEST_ENV};

make_test_files();
capture_ok("z88dk-z80asm -b ".
		   "${test}\${TEST_ENV}1.asm ".
		   "${test}\${TEST_ENV}2.asm ".
		   "${test}\${TEST_ENV}3.asm ". 
		   "${test}\${TEST_ENV}4.asm ", "");
check_bin_file("${test}1.bin", bytes(1..4));

make_test_files();
spew("${test}1.lst", <<END);
  ${test}\${TEST_ENV}1.asm
  ${test}\${TEST_ENV}2.asm

# see #440
\@${test}\${TEST_ENV}2.lst
END

spew("${test}2.lst", <<END);
  ${test}\${TEST_ENV}3.asm
  ${test}\${TEST_ENV}4.asm
END

capture_ok("z88dk-z80asm -b ".quote_os("\@${test}1.lst"), "");
check_bin_file("${test}1.bin", bytes(1..4));


# use globs in command line
make_test_files("${test}dir");

capture_ok("z88dk-z80asm -b ".quote_os("${test}dir/*.asm"), "");
check_bin_file("${test}dir/${test}1.bin", bytes(1..4));

path("${test}dir")->remove_tree if Test::More->builder->is_passing;


# use globs in list file
make_test_files("${test}dir");

spew("${test}1.lst", <<END);
	${test}dir/*.asm
END

capture_ok("z88dk-z80asm -b ".quote_os("\@${test}1.lst"), "");
check_bin_file("${test}dir/${test}1.bin", bytes(1..4));


# error if no files are returned
unlink_testfiles;
path("${test}dir")->remove_tree;

spew("${test}1.lst", <<END);
	${test}dir/*.asm
END

capture_nok("z88dk-z80asm -b ".quote_os("\@${test}1.lst"), <<END);
${test}1.lst:1: error: pattern returned no files: ${test}dir/*.asm
  ^---- ${test}dir/*.asm
END


# use globs in recursive list file name
make_test_files("${test}dir");

spew("${test}1.lst", <<END);
	\@${test}dir/*.lst
END

for (1..4) {
	spew("${test}dir/${test}$_.lst", "${test}dir/${test}$_.asm");
}

capture_ok("z88dk-z80asm -b ".quote_os("\@${test}1.lst"), "");
check_bin_file("${test}dir/${test}1.bin", bytes(1..4));


# use ** glob for any number of directories
unlink_testfiles;
path("${test}dir")->remove_tree;
path("${test}dir")->mkpath;

for (1..4) {
	my $dir = "${test}dir/$_/a/b";
	path($dir)->mkpath;
	spew("$dir/${test}$_.asm", "defb $_");
}

spew("${test}1.lst", <<END);
	${test}dir/**/*.asm
END

capture_ok("z88dk-z80asm -b ".quote_os("\@${test}1.lst"), "");
check_bin_file("${test}dir/1/a/b/${test}1.bin", bytes(1..4));


# run again, .o files are not read as asm
capture_ok("z88dk-z80asm -b ".quote_os("\@${test}1.lst"), "");
check_bin_file("${test}dir/1/a/b/${test}1.bin", bytes(1..4));


path("${test}dir")->remove_tree if Test::More->builder->is_passing;
unlink_testfiles;
done_testing;


sub make_test_files {
	my($dir) = @_;
	$dir ||= ".";
	
	unlink_testfiles; 
	path($dir)->mkpath;
	for (1..4) {
		spew("$dir/${test}$_.asm", "defb $_");
		ok -f "$dir/${test}$_.asm", "create $dir/${test}$_.asm"
	}
}
