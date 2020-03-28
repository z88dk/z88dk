#------------------------------------------------------------------------------
# z80asm tests
# Copyright (C) Paulo Custodio, 2020
# License: http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

package testlib;

use strict;
use warnings;
use File::Basename;
use Test::More;
use Path::Tiny;
use Config;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw( ok nok diag note test_name run_ok run_nok end_test path );

my $exe = $Config{osname} eq 'MSWin32' ? '.exe' : '';
my $test = basename($0, '.t');
$ENV{PATH} = '.'.$Config{path_sep}.
			 '../z80nm'.$Config{path_sep}.
			 $ENV{PATH};

sub test_name { return $test; }

sub run {
	my($ok, $test, $cmd, $expout, $experr) = @_;

	ok open(my $out, ">", "$test.expout"), "write $test.expout";
	print $out $expout;
	close $out;

	ok open(my $err, ">", "$test.experr"), "write $test.experr";
	print $err $experr;
	close $err;

	$cmd .= " > $test.gotout 2> $test.goterr";
	if ($ok) {
		ok 0 == system($cmd), $cmd;
	}
	else {
		ok 0 != system($cmd), $cmd;
	}

	$cmd = "diff -w $test.gotout $test.expout";
	ok 0 == system($cmd), $cmd;

	$cmd = "diff -w $test.goterr $test.experr";
	ok 0 == system($cmd), $cmd;
}

sub run_ok  { run(1, $test, @_); }
sub run_nok { run(0, $test, @_); }

sub end_test {
	if (Test::More->builder->is_passing) {
		unlink("$test.gotout", "$test.goterr", "$test.expout", "$test.experr",
				"$test.asm", "$test.o", "$test.bin");
	}
	done_testing();
}

1;
