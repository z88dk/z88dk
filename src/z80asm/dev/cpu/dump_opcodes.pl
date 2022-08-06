#!/usr/bin/env perl

#------------------------------------------------------------------------------
# Build text table representation of opcodes.yaml
#------------------------------------------------------------------------------

use Modern::Perl;
use YAML::Tiny;
use Text::Table;

@ARGV==2 or die "Usage: $0 input_file.yaml output_file.txt\n";
my($input_file, $output_file) = @ARGV;

my $yaml = YAML::Tiny->read($input_file);
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

open(my $fh, ">", $output_file) or die $!;
print $fh $tb->title;
print $fh $tb->rule('=');
print $fh $tb->body;
