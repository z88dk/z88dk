#!perl

#------------------------------------------------------------------------------
# Test cpu opcode files created by ../tools/cpu.pl
#------------------------------------------------------------------------------
use strict;
use warnings;
use v5.10;
use Test::More;
use File::Basename;

for my $file (<tools/cpu_test*.asm>) {
	# build cpu, ixiy, ok options from file name
	my $base = basename($file, ".asm");
	my $ok = $base =~ s/_ok//; $base =~ s/_err//;
	my $ixiy = $base =~ s/_ixiy//;
	my($cpu) = $base =~ /cpu_test_(\w+)$/;
	
	# build command line
	my $cmd = "z80asm --cpu=$cpu --no-emul ".
			($ixiy ? "--IXIY " : "").
			" -l -b $file 2> test.err";
	
	# assembler output files
	(my $file_bin = $file) =~ s/\.asm$/.bin/;
	(my $file_o   = $file) =~ s/\.asm$/.o/;
	(my $file_err = $file) =~ s/\.asm$/.err/;
	(my $file_lis = $file) =~ s/\.asm$/.lis/;
	unlink "test.err", $file_bin, $file_o, $file_err, $file_lis;
	
	if ($ok) {
		# build binary image
		my $bin = '';
		if ($ok) {
			local(@ARGV) = $file;
			while (<>) {
				s/.*;//;
				for (split(' ', $_)) {
					$bin .= chr(hex($_));
				}
			}
		}
		
		# run assembler
		ok system($cmd)==0, $cmd;
		ok -s "test.err" == 0, "no errors in stderr";
		ok !-f $file_err, "no $file_err";
		ok slurp($file_bin) eq $bin, "$file_bin ok";
	}
	else {
		# check that all lines have error messages
		my $num_lines = (slurp($file) =~ tr/\n/\n/);
		my @err_lines;
		
		# run assembler
		ok system($cmd)!=0, $cmd;
		ok -s "test.err", "errors in stderr";
		ok -f $file_err, "$file_err exists";
		local(@ARGV) = $file_err;
		while (<>) {
			/^Error .*? line (\d+)/ and $err_lines[$1]++;
		}
		for (1..$num_lines) {
			ok $err_lines[$_], "expected error at line $_";
		}
	}
	
	if (Test::More->builder->is_passing) {
		unlink "test.err", $file_bin, $file_o, $file_err, $file_lis;
	}
}

done_testing;

sub slurp {
	my($file) = @_;
	local $/;
	open(my $fh, "<:raw", $file) or die "$file: $!";
	return <$fh>;
}
