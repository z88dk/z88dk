#!/usr/bin/env perl

use Modern::Perl;
use YAML::Tiny;
use Text::Table;

my $yaml = YAML::Tiny->read("opcodes.yaml");
my %opcodes = %{$yaml->[0]};

my $sep = \"|";
my $tb = Text::Table->new($sep, "Assembly", $sep, "CPU", $sep, "Opcodes", $sep);

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
		$tb->add($asm, $cpu, "@bytes");
	}
}

open(my $fh, ">", "opcodes.txt") or die $!;
print $fh $tb->title;
print $fh $tb->rule('=');
print $fh $tb->body;

