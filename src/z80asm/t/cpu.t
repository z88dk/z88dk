#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# test error
z80asm_nok("-mcc", "", "", <<END);
error: invalid cpu: cc; expected: 8080,8085,ez80,ez80_z80,gbz80,kc160,kc160_z80,r2ka,r3k,r4k,r5k,r800,z180,z80,z80_strict,z80n,ti83,ti83plus
END

z80asm_nok("-m=cc", "", "", <<END);
error: invalid cpu: cc; expected: 8080,8085,ez80,ez80_z80,gbz80,kc160,kc160_z80,r2ka,r3k,r4k,r5k,r800,z180,z80,z80_strict,z80n,ti83,ti83plus
END

# Test cpu opcode files created by ../dev/cpu/cpu.pl

for my $file (<dev/cpu/cpu_test*.asm>) {
	# build cpu, ixiy, ok options from file name
	my $base = path($file)->basename(".asm");
	my $ok = $base =~ s/_ok//; $base =~ s/_err//;
	my $ixiy = $base =~ s/_ixiy//;
	my($cpu) = $base =~ /cpu_test_(\w+)$/;
	
	# assembler output files
	(my $file_bin = $file) =~ s/\.asm$/.bin/;
	(my $file_o   = $file) =~ s/\.asm$/.o/;
	(my $file_lis = $file) =~ s/\.asm$/.lis/;
	(my $file_map = $file) =~ s/\.asm$/.map/;
	unlink "$test.err", $file_bin, $file_o, $file_lis, $file_map;
	
	my $asm_cmd = "z88dk-z80asm -m$cpu ".($ixiy ? "-IXIY " : "")." -m -l -b $file 2> $test.err";
	
	if ($ok) {
		# build binary image, check output of assembler
		my $addr = 0;
		my %labels;
		my @patch;
		my @bin;
		{
			local(@ARGV) = $file;
			while (<>) {
				s/.*;// or next;
				for (split(' ', $_)) {
					if (/^@(\w+)/) {
						push @patch, [$addr, $1];
						$bin[$addr++] = 0;
						$bin[$addr++] = 0;
						$bin[$addr++] = 0 if $cpu eq 'ez80';
					}
					else {
						$bin[$addr++] = hex($_);							
					}
				}
			}
		}
		my $length = $addr;		# only compare output up to $length
		
		# run assembler
		run_ok($asm_cmd);

		# read labels from map file and patch @bin
		{
			local(@ARGV) = $file_map;
			while (<>) {
				if (/^ (\w+) \s* = \s* \$ ([0-9a-f]+) \s* ; \s* \w+ , \s+ public /ix) {
					my($name, $addr) = ($1, hex($2));
					if (exists $labels{$name}) {
						$labels{$name} == $addr or die "$name address mismatch";
					}
					else {
						$labels{$name} = $addr;
					}
				}
			}
			for (@patch) {
				my($addr, $name) = @$_;
				defined(my $value = $labels{$name}) or die "$name not found";
				$bin[$addr++] = $value & 0xFF;
				$bin[$addr++] = ($value >> 8) & 0xFF;
				$bin[$addr++] = ($value >> 16) & 0xFF if $cpu eq 'ez80';
			}
		}
		my $bin = join('', map {chr} @bin);
		
		# read output binary
		my $out_bin = substr(slurp($file_bin), 0, $length);
		ok $out_bin eq $bin, "$file_bin ok";
		if ($out_bin ne $bin) {
			my $addr = 0;
			while ($addr < length($out_bin) && $addr < length($bin) 
					&& substr($out_bin, $addr, 1) eq substr($bin, $addr, 1)) {
				$addr++;
			}
			diag sprintf("Output difers at \$%04X", $addr);
			diag "expected ", unpack("H*", substr($bin, $addr, 10));
			diag "got      ", unpack("H*", substr($out_bin, $addr, 10));
		}
		
		if (!$ixiy) {
			# run disassembler and assemble again; check binary
			(my $dis_cpu = $cpu) =~ s/_strict//;
			run_ok("z88dk-dis -m$dis_cpu $file_bin > $test.asm");

			# assemble
			run_ok("z88dk-z80asm -m$cpu -b -l $test.asm 2> $test.err");
			is slurp("$test.err"), "", "check errors";
			
			# compare
			check_bin_file("$test.bin", slurp("$file_bin"));
		}
	}
	else {
		# check that all lines have error messages
		my @lines = path($file)->lines;
		my $num_lines = scalar @lines;
		my @err_lines;
		
		# run assembler
		run_nok($asm_cmd);
		{
			local(@ARGV) = "$test.err";
			while (<>) {
				if (/^[^:]+:(\d+): (error|warning: interpreting indirect value as immediate)/) {
					$err_lines[$1]++;
				}			
			}
		}
		
		my @failed;
		for (1..$num_lines) {
			if (!$err_lines[$_]) { push @failed, $_; }
		}
		ok @failed==0, "all lines output errors";
		if (@failed) { diag "Failed tests: @failed"; }
	}
	
	if (Test::More->builder->is_passing) {
		unlink "$test.err", $file_bin, $file_o, $file_lis, $file_map;
	}
    else { 
        die "Tests failed, aborted\n";
    }
}

unlink_testfiles;
done_testing;
