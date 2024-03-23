#!/usr/bin/env perl

#------------------------------------------------------------------------------
# z80asm
# Copyright (C) Paulo Custodio, 2011-2024
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

use Modern::Perl;
use Path::Tiny;

# get source files with unit tests and list of tests
my @test_sources;
for my $source_file (<*.cpp>) {
	my $test_source_file = "t/test_".$source_file;
	(my $header_file = $source_file) =~ s/\.cpp$/.h/;
	(my $test_driver_file = $test_source_file) =~ s/\.cpp$/_driver.cpp/;
	if (-f $test_source_file) {
		push @test_sources, [$test_source_file, $source_file, $test_driver_file, 
						     "t/test.cpp", "../../common/xassert.c"];
		
		my(@inline_tests, @exec_tests);
		for my $line (path($test_source_file)->lines) {
			if ($line =~ /^ \s* void \s+ (test_\w+) \s* \( \s* \) /x) {
				push @inline_tests, $1;
			}
			elsif ($line =~ /^ \s* int \s+ (exec_\w+) \s* \( \s* \) /x) {
				push @exec_tests, $1;
			}
		}
		
		# build driver code
		my @driver_lines = <<END;
#include "test.h"
#include "xassert.h"
#include "../$header_file"
#include <string>
using namespace std;

END
		for my $test (@inline_tests) {
			push @driver_lines, "void $test();\n";
		}
		for my $test (@exec_tests) {
			push @driver_lines, "int $test();\n";
		}
		
		push @driver_lines, <<END;

int main(int argc, char* argv[]) {
	xassert_init(argv[0]);
    start_testing(argv[0]);

    if (argc == 2) {
        string arg = argv[1];
END

		for my $test (@exec_tests) {
			push @driver_lines, <<END;
        if (arg == "$test")
            return $test();
END
		}
		
		push @driver_lines, <<END;
        FAIL();
        DIAG("invalid test " << arg);
    }
    else {
END
		for my $test (@inline_tests) {
			push @driver_lines, "        $test();\n";
		}

		push @driver_lines, <<END;
    }

    done_testing();
}
END
		
		# write if different
		my $driver_lines = join('', @driver_lines);
		my $old_driver_lines = -f $test_driver_file ?
						path($test_driver_file)->slurp : "";
		if ($driver_lines ne $old_driver_lines) {
			say $test_driver_file;
			path($test_driver_file)->spew($driver_lines);
		}
	}
}

# build Makefile include
my $makefile = "Make.tests";
my @makefile_lines;
for (@test_sources) {
	my @files = @$_;
	@files = map {s/\.c(pp)?$/.o/; $_} @files;
	(my $main_file = $files[0]) =~ s/\.o$//;
	push @makefile_lines, "\$(eval \$(call MAKE_EXE,$main_file,@files,1))\n";
}

# write if different
my $makefile_lines = join('', @makefile_lines);
my $old_makefile_lines = -f $makefile ? path($makefile)->slurp : "";
if ($makefile_lines ne $old_makefile_lines) {
	say $makefile;
	path($makefile)->spew($makefile_lines);
}
