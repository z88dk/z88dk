#!/usr/bin/env perl

#------------------------------------------------------------------------------
# Build test files for the assembler
#------------------------------------------------------------------------------

use Modern::Perl;
BEGIN { 
	use Path::Tiny;
	use lib path($0)->dirname;
	use Opcodes;
}
use List::Util qw( min max );
use Clone 'clone';
use Carp (); 
use Data::Dump 'dump'; 
$SIG{__DIE__} = \&Carp::confess;
use warnings FATAL => 'all';

@ARGV==2 or die "Usage: $0 input_file.dat output_basename\n";
my($input_file, $output_basename) = @ARGV;

my $opcodes = Opcodes->from_file($input_file);

my @test;
my %all_opcodes;

# dump cpu_ok and cpu_ixiy_ok
for my $ixiy ("", "_ixiy") {
	for my $cpu (Opcode->cpus) {
		@test = ();
		
		for my $asm (sort keys %{$opcodes->opcodes}) {
			my $asm_ixiy = $asm;
			if ($ixiy) {
				$asm_ixiy =~ s/([xyapz]i[xy]\b|\b(ix|iy))/ swap_ix_iy($1) /ge;
			}
			
			if ($opcodes->exists($cpu, $asm_ixiy)) {
				my $opcode = $opcodes->opcodes->{$asm_ixiy}{$cpu};

				add($cpu, $opcode->clone(sub {s/\Q$asm_ixiy/$asm/}, sub {}));	# make a deep copy
					}
			elsif ($opcodes->exists($cpu, $asm)) {
				my $opcode = $opcodes->opcodes->{$asm}{$cpu};
				add($cpu, $opcode->clone(sub {}, sub {}));	# make a deep copy
			}
		}
		
		open(my $fh, ">", "${output_basename}_${cpu}${ixiy}_ok.asm") or die $!;
		say $fh join("\n", compute_labels($cpu, sort @test));
	}
}

# dump cpu_error
for my $cpu (Opcode->cpus) {
	@test = ();
	
	for my $asm (sort keys %{$all_opcodes{ALL}}) {
		#say "$cpu\t$opcode->asm" if $opcode->asm =~ /ld \(sp\+/;

		if (!exists $all_opcodes{$cpu}{$asm} &&
		    !exists $all_opcodes{$cpu}{$asm =~ s/0x1234[0-9A-F]+/0x1234/r} &&
			!exists $all_opcodes{$cpu}{$asm =~ s/0x1234\b/0x123456/r} &&
			!exists $all_opcodes{$cpu}{$asm =~ s/sp[+-]\d+/sp+0/r} &&
			!exists $all_opcodes{$cpu}{$asm =~ s/sp[+-]\d+/sp-128/r} ) {
			my $skip = 0;

			# special case: 'djnz ASMPC' is translated to 'djnz NN' in 8080/8085
			if ($asm =~ /^(jr|djnz)/) {
				if ($cpu =~ /^80/) {
					$skip = 1 if $asm =~ /ASMPC/;	# DIS
				}
				else {
					$skip = 1 if $asm =~ /\d+/;		# nn
				}
			}

			# special case: cp (compare/call positive) always exists
			$skip = 1 if $asm =~ /^cp (a, )?(0x1234|-128|0|127|255)/i;

			push @test, sprintf(" %-31s; Error", $asm) unless $skip;
		}
	}
	
	open(my $fh, ">", "${output_basename}_${cpu}_err.asm") or die $!;
	say $fh join("\n", sort @test);
}


sub swap_ix_iy {
	my($str) = @_;
	$str =~ tr/xy/yx/;
	return $str;
}

sub add {
	my($cpu, $opcode) = @_;
	my $asm = $opcode->asm;
	my @bytes = $opcode->bytes();
	my $bytes = "@bytes";
	
	#say "$cpu\t$asm\t",$opcode->to_string if $asm =~ /adc/;
	
	# special case for intel: jr and djnz %j is converted to %m
	if ($opcode->cpu =~ /^80/ && $asm =~ /^(jr|djnz)/) {
		$opcode = $opcode->clone(sub { s/%j/%m/; }, sub {});
	}
	
	if ($asm =~ /^ldh .*\(c\)/ && !$opcode->{done_ldh}) {
		my $opcode1 = $opcode->clone(sub {}, sub {});
		$opcode1->{done_ldh} = 1;
		add($cpu, $opcode1);

		$opcode1 = $opcode->clone(sub {s/ldh /ld /; s/\(c\)/(0xff00+c)/}, sub {}); 
		$opcode1->{done_ldh} = 1;
		add($cpu, $opcode1);
	}
	elsif ($asm =~ /%d/) {
		add($cpu, $opcode->clone(sub {s/%d/126/}, sub {s/%d/0x7E/e; s/%D/0x7F/e}));
		add($cpu, $opcode->clone(sub {s/%d/0/}, sub {s/%d/0x00/e; s/%D/0x01/e}));
		add($cpu, $opcode->clone(sub {s/%d/-128/; s/\+-/-/}, sub {s/%d/0x80/e; s/%D/0x81/e}));
	}
	elsif ($asm =~ /%u/) {
		if (! $asm =~ /ld \w\w, \w\w\+%u/) {
			add($cpu, $opcode->clone(sub {s/%d/0/; s/\+0//}, sub {s/%d/0x00/e; s/%D/0x01/e}));
		}
		add($cpu, $opcode->clone(sub {s/%u/0/}, sub {s/%u/0x00/e}));
		add($cpu, $opcode->clone(sub {s/%u/128/}, sub {s/%u/0x80/e}));
		add($cpu, $opcode->clone(sub {s/%u/255/}, sub {s/%u/0xFF/e}));
	}
	# must be 1-byte opcode so that call to __z80asm__add_sp_s with defb %s after
	# is diassembled correctly during z80asm tests in cpu.t
	elsif ($asm =~ /%s/) {
		my $state = 0;	
		add($cpu, $opcode->clone(sub {s/%s/-128/; s/\+-/-/}, 
								 sub {
								 	if ($state == 0) {
								 		if (s/%s/0x80/e) {
								 			$state = 1;
										}
									}
								 	elsif ($state == 1) {
								 		s/0/0xFF/e or die $_;
								 		$state = 2;
									}
									elsif ($state == 2) {
										s/0/0xFF/e;			# for ez80
										$state = 3;
									}
								 }));
			
		$state = 0;
		add($cpu, $opcode->clone(sub {s/%s/0/}, 
								 sub {
								 	if ($state == 0) {
								 		if (s/%s/0x00/e) {
								 			$state = 1;
										}
								 	}
								 	elsif ($state == 1) {
								 		s/0/0x00/e or die $_;
								 		$state = 2;
								 	}
									elsif ($state == 2) {
										s/0/0x00/e;			# for ez80
										$state = 3;
									}
								 }));
			
		if ($asm =~ /%s\+/) {
			$state = 0;
			add($cpu, $opcode->clone(sub {s/%s/0/; s/\+0//}, 
									sub {
										if ($state == 0) {
											if (s/%s/0x00/e) {
												$state = 1;
											}
										}
										elsif ($state == 1) {
											s/0/0x00/e or die $_;
											$state = 2;
										}
									}));
		}

		# 7F is a prefix in r4k and r5k, is not single-opcode; use 7E instead
		$state = 0;	
		add($cpu, $opcode->clone(sub {s/%s/126/}, 
								 sub {
								 	if ($state == 0) {
								 		if (s/%s/0x7E/e) {
								 			$state = 1;
										}
									}
								 	elsif ($state == 1) {
								 		s/0/0x00/e or die $_;
								 		$state = 2;
								 	}
								 }));
	}
	elsif ($asm =~ /%n/) {
		add($cpu, $opcode->clone(sub {s/%n/-128/g; s/\+-/-/}, sub {s/%n/0x80/e}));
		add($cpu, $opcode->clone(sub {s/%n/0/g}, sub {s/%n/0x00/e}));
		add($cpu, $opcode->clone(sub {s/%n/127/g}, sub {s/%n/0x7F/e}));
		add($cpu, $opcode->clone(sub {s/%n/255/g}, sub {s/%n/0xFF/e}));
	}
	elsif ($asm =~ /%h/) {
		add($cpu, $opcode->clone(sub {s/%h/0/}, sub {s/%h/0x00/e}));
		add($cpu, $opcode->clone(sub {s/%h/127/}, sub {s/%h/0x7F/e}));
		add($cpu, $opcode->clone(sub {s/%h/255/}, sub {s/%h/0xFF/e}));
	}
	elsif ($bytes =~ /%m %m %m %m/) {
		my $state = 0;
		add($cpu, $opcode->clone(sub {s/%m/0x12345678/}, 
								 sub {
								 	if (/%m/) {
								 		if    ($state == 0) { s/%m/0x78/e; $state = 1; }
								 		elsif ($state == 1) { s/%m/0x56/e; $state = 2; }
								 		elsif ($state == 2) { s/%m/0x34/e; $state = 3; }
								 		elsif ($state == 3) { s/%m/0x12/e; $state = 4; }
								 	}
								 }));
	}
	elsif ($bytes =~ /%m %m %m/) {
		my $state = 0;
		add($cpu, $opcode->clone(sub {s/%m/0x123456/}, 
								 sub {
								 	if (/%m/) {
								 		if    ($state == 0) { s/%m/0x56/e; $state = 1; }
								 		elsif ($state == 1) { s/%m/0x34/e; $state = 2; }
								 		elsif ($state == 2) { s/%m/0x12/e; $state = 3; }
								 	}
								 }));
	}
	elsif ($bytes =~ /%m1 %m1/) {
		my $state = 0;
		add($cpu, $opcode->clone(sub {s/%m1/0x1235/; s/%m/0x1234/}, 
								 sub {
								 	if (/%m/) {
								 		if    ($state == 0) { s/%m/0x34/e; $state = 1; }
								 		elsif ($state == 1) { s/%m/0x12/e; $state = 2; }
								 		elsif ($state == 2) { s/%m1/0x35/e; $state = 3; }
								 		elsif ($state == 3) { s/%m1/0x12/e; $state = 4; }
								 	}
								 }));
	}
	elsif ($bytes =~ /%m %m/) {
		my $state = 0;
		add($cpu, $opcode->clone(sub {s/%m/0x1234/}, 
								 sub {
								 	if (/%m/) {
								 		if    ($state == 0) { s/%m/0x34/e; $state = 1; }
								 		elsif ($state == 1) { s/%m/0x12/e; $state = 2; }
									}
								 }));
	}
	elsif ($bytes =~ /%x %x/) {
		my $state = 0;
		add($cpu, $opcode->clone(sub {s/%x/0x5678/}, 
								 sub {
								 	if (/%x/) {
								 		if    ($state == 0) { s/%x/0x78/e; $state = 1; }
								 		elsif ($state == 1) { s/%x/0x56/e; $state = 2; }
									}
								 }));
	}
	elsif ($bytes =~ /%x/) {
		add($cpu, $opcode->clone(sub {s/%x/0x56/}, sub {s/%x/0x56/e}));
	}
	elsif ($asm =~ /%M/) {
		my $state = 0;
		add($cpu, $opcode->clone(sub {s/%M/0x1234/}, 
								 sub {
								 	if (/%M/) {
								 		if    ($state == 0) { s/%M/0x12/e; $state = 1; }
								 		elsif ($state == 1) { s/%M/0x34/e; $state = 2; }
								 	}
								 }));
	}
	elsif ($bytes =~ /^[0-9A-F]{2} %j [0-9A-F]{2} %j$/) {
		my $state = 0;
		add($cpu, $opcode->clone(sub {s/%j/ASMPC/}, 
								 sub {
								 	if (/%j/) {
								 		if    ($state == 0) { s/%j/0xFE/e; $state = 1; }
								 		elsif ($state == 1) { s/%j/0xFC/e; $state = 2; }
								 	}
								 }));
	}
	elsif ($asm =~ /%j/) {
		my $dist = -scalar($opcode->bytes);
		add($cpu, $opcode->clone(sub {s/%j/ASMPC/}, sub {s/%j/ $dist & 0xFF /e}));
	}
	elsif ($asm =~ /%J/) {
		my $dist = -scalar($opcode->bytes);
		my $state = 0;
		add($cpu, $opcode->clone(sub {s/%J/ASMPC/}, 
								 sub {
								 	if (/%J/) {
								 		if    ($state == 0) { s/%J/ $dist & 0xFF /e; $state = 1; }
								 		elsif ($state == 1) { s/%J/ ($dist >> 8) & 0xFF /e; $state = 2; }
								 	}
								 }));
	}
	elsif ($asm =~ /%c/) {
		my @const = sort {$a <=> $b} @{$opcode->const};
		for my $c (@const) {
			my $opcode1 = $opcode->clone(sub { s/%c/$c/; }, 
									     sub { if (s/%c/$c/g) {
										  		  $_ = eval($_); $@ and die $@;
											   }});
			add($cpu, $opcode1);
		}
		
		# create error cases
		my %const; $const{$_} = 1 for @const;
		for my $c (min(@const)-1 .. max(@const)+1) {
			if (!$const{$c}) {
				my $asm_ixiy = $asm =~ s/%c/$c/r;
				$all_opcodes{ALL}{$asm_ixiy} = 1;
			}
		}
	}
	else {
		my @hex_bytes = @bytes;
		for (@hex_bytes) {
			if (/^\d+$/) {
				$_ = sprintf("%02X", $_);
			}
		}
		push @test, sprintf(" %-31s; %s", $asm, "@hex_bytes");
		$all_opcodes{$cpu}{$asm} = 1;
		$all_opcodes{ALL}{$asm} = 1;
	}
}

sub compute_labels {
	my($cpu, @test) = @_;
	my $asmpc = 0;
	for (@test) {
		my($asm, $bytes) = split(/;/, $_, 2);
		my @bytes = split ' ', $bytes;
		my $num_bytes = scalar(@bytes);
		if ($bytes =~ /\@/) {
			if ($cpu eq 'ez80') {
				$num_bytes += 2;
			}
			else {
				$num_bytes += 1;
			}
		}
		
		while ($bytes =~ /%t(\d*) %t\1 %t\1/) {
			my $before = $`; my @before = split ' ', $before;
			my $after  = $'; my @after  = split ' ', $after;
			my $target = $asmpc + $num_bytes - ($1 || 0);
			@bytes = (@before, sprintf("%02X", ($target) & 0xFF),
							   sprintf("%02X", ($target >> 8) & 0xFF),
							   sprintf("%02X", ($target >> 16) & 0xFF), @after);
			$bytes = join ' ', @bytes;
		}
		
		while ($bytes =~ /%t(\d*) %t\1/) {
			my $before = $`; my @before = split ' ', $before;
			my $after  = $'; my @after  = split ' ', $after;
			my $target = $asmpc + $num_bytes - ($1 || 0);
			@bytes = (@before, sprintf("%02X", ($target) & 0xFF),
							   sprintf("%02X", ($target >> 8) & 0xFF), @after);
			$bytes = join ' ', @bytes;
		}
		
		while ($bytes =~ /%t(\d*)/) {
			my $before = $`; my @before = split ' ', $before;
			my $after  = $'; my @after  = split ' ', $after;
			my $target = $asmpc + $num_bytes - ($1 || 0) - ($asmpc + scalar(@before) + 1);
			@bytes = (@before, sprintf("%02X", ($target) & 0xFF), @after);
			$bytes = join ' ', @bytes;
		}
		
		#say "$asm; @bytes";
		
		die $bytes if $bytes =~ /%/;

		$asmpc += $num_bytes;
		
		$_ = "$asm; @bytes";
	}
	return @test;
}
