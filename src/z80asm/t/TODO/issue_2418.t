#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;
use File::Copy;

# Test https://github.com/z88dk/z88dk/issues/2418
# z80asm: Trouble with defc label1 = label2

# run zcc to force the error
if (0) {
	# convert C to assembly
	spew("$test.c", <<END);
	#define ANSI_STDIO

	#include <fcntl.h>
	#include <stdio.h>

	FILE *_freopen1(const char* name, int fd, const char* mode, FILE* fp);

	int main() {
		_freopen1("$test.bin", 0, "r", NULL);
	}
END

	my $count = 0;
	my $link;
	my $list_file;
	my $temp_dir;
	run_ok("zcc +test -no-cleanup -v -DAMALLOC -O3 -m --opt-code-speed=inlineints ".
		   "$test.c ../../libsrc/stdio/_freopen1.c -o$test.bin > $test.out");
	ok open(my $fh, "<", "$test.out"), "open $test.out";
	while (<$fh>) {
		if (/z88dk-ucpp\s+.*"([^"\n]+)"\s+"([^"\n]+)"\s*$/) {
			my($f1, $f2) = norm_filenames($1, $2);
			#print "$f1 -> $f2\n";
			#show_diff($f1, $f2);
		}
		elsif (/z88dk-zpragma\s+.*<\s*"([^"\n]+)"\s*>\s*"([^"\n]+)"\s*$/) {
			my($f1, $f2) = norm_filenames($1, $2);
			#print "$f1 -> $f2\n";
			#show_diff($f1, $f2);
		}
		elsif (/z88dk-sccz80\s+.*"([^"\n]+)"\s*-o\s*"([^"\n]+)"\s*$/) {
			my($f1, $f2) = norm_filenames($1, $2);
			#print "$f1 -> $f2\n";
			#show_diff($f1, $f2);		
			#	SECTION	code_crt_exit
			#	EXTERN	closeall
			#	call	closeall
			#; --- Start of Optimiser additions ---
			#	defc	i_13 = i_11
			#	defc	i_11 = i_9
		}
		elsif (/z88dk-copt\s+.*z80rules.9.*<\s*"([^"\n]+)"\s*>\s*"([^"\n]+)"\s*$/) {
			my($f1, $f2) = norm_filenames($1, $2);
			#print "$f1 -> $f2\n";
			#show_diff($f1, $f2);
			# no difference in defc
		}
		elsif (/z88dk-copt\s+.*z80rules.2.*<\s*"([^"\n]+)"\s*>\s*"([^"\n]+)"\s*$/) {
			my($f1, $f2) = norm_filenames($1, $2);
			#print "$f1 -> $f2\n";
			#show_diff($f1, $f2);
			# no difference in defc
		}
		elsif (/z88dk-copt\s+.*z80rules.1.*<\s*"([^"\n]+)"\s*>\s*"([^"\n]+)"\s*$/) {
			my($f1, $f2) = norm_filenames($1, $2);
			#print "$f1 -> $f2\n";
			#show_diff($f1, $f2);
			# no difference in defc
		}
		elsif (/z88dk-copt\s+.*z80rules.0.*<\s*"([^"\n]+)"\s*>\s*"([^"\n]+)"\s*$/) {
			my($f1, $f2) = norm_filenames($1, $2);
			#print "$f1 -> $f2\n";
			#show_diff($f1, $f2);
			# no difference in defc
		}
		elsif (/z88dk-copt\s+.*z80rules.8.*<\s*"([^"\n]+)"\s*>\s*"([^"\n]+)"\s*$/) {
			my($f1, $f2) = norm_filenames($1, $2);
			#print "$f1 -> $f2\n";
			#show_diff($f1, $f2);
			# no difference in defc
		}
		elsif (/z88dk-z80asm.*"([^"\n\@]+)"\s*$/) {
			my($f1) = norm_filenames($1);
			my $f2 = $test.".".(++$count).".asm";
			print "$f1 -> $f2\n";
			copy($f1, $f2);
		}
		elsif (/z88dk-z80asm\s+-mz80\s+-b.*"\@([^"\n]+)"\s*$/) {
			$link = $&;
			$list_file = $1;
			$link =~ /-I.*?(zcc\w+)/ and $temp_dir = $1;
		}
	}

	# assemble and link
	run_ok(qq{z88dk-z80asm -b -d  -o"test_t_issue_2418.bin" -m -L.  -L"C:/msys64/home/T0071173/git/z88dk/lib/config/../../lib/clibs/z80"   -I"C:/msys64/tmp/$temp_dir" -L"C:/msys64/home/T0071173/git/z88dk/lib/config/../../lib/clibs" -I"C:/msys64/home/T0071173/git/z88dk/lib/config/../../lib" -ltest_clib -l"z80_crt0"     "\@$list_file" });
}
# run z80asm to force the error
else {
	path("$test.dir/crt/classic")->mkpath;

	spew("$test.asm", <<'END');
SECTION code_compiler
SECTION code_crt_exit

SECTION code_compiler
	jp i_9
	jp i_11
.i_9
	ret

SECTION code_crt_exit
	defc	i_11 = i_9
SECTION	code_compiler
END

	run_ok("z88dk-z80asm -b -m $test.asm");
	
	check_bin_file("$test.bin", bytes(0xC3, 6, 0, 0xC3, 6, 0, 0xC9));

	capture_ok("z88dk-z80nm -a $test.o", <<'END');
Object  file test_t_issue_2418.o at $0000: Z80RMF18
  Name: test_t_issue_2418
  CPU:  z80 
  Section "": 0 bytes
  Section code_compiler: 7 bytes
    C $0000: C3 00 00 C3 00 00 C9
  Section code_crt_exit: 0 bytes
  Symbols:
    L A $0006: i_9 (section code_compiler) (file test_t_issue_2418.asm:7)
    L A $0006: i_11 (section code_compiler) (file test_t_issue_2418.asm:11)
  Expressions:
    E W $0000 $0001 3: i_9 (section code_compiler) (file test_t_issue_2418.asm:5)
    E W $0003 $0004 3: i_11 (section code_compiler) (file test_t_issue_2418.asm:6)
END

}

# check that DEFC labels are the same
my %map;
ok open(my $fh, "<", "$test.map"), "open $test.map";
while (<$fh>) {
	/^(\w+)\s*=\s*\$([0-9a-fA-F]+)/ and $map{$1} = hex($2);
}

is $map{i_11}, $map{i_9}, "i_11==i_9";


path("$test.dir")->remove_tree;
unlink_testfiles;
done_testing;


sub norm_filenames {
	my(@files) = @_;
	for (@files) {
		s/\\/\//g;
	}
	return @files;
}

sub show_diff {
	if ($ENV{DEBUG}) {
		system "/c/bin/WinMergePortable/WinMergePortable.exe @_";
	}
}
