#!/usr/bin/env perl

use Modern::Perl;
use YAML::Tiny;

my $yaml = YAML::Tiny->read("opcodes.yaml");
my %opcodes = %{$yaml->[0]};

open(my $fh, ">", "opcodes.txt") or die $!;
for my $asm (sort keys %opcodes) {
	for my $cpu (sort keys %{$opcodes{$asm}}) {
		my @ops = @{$opcodes{$asm}{$cpu}};
		my @bytes;
		for my $op (@ops) {
			for my $byte (@$op) {
				next unless defined $byte;
				if ($byte =~ /^\d+$/) {
					push @bytes, sprintf("%02X", $byte);
				}
				else {
					push @bytes, $byte;
				}
			}
		}
		say $fh sprintf("%-32s%-8s%s", $asm, $cpu, "@bytes");
	}
}
