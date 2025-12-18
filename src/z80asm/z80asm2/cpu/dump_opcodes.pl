#!/usr/bin/env perl

#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2025
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

# Build text table representation of opcodes.dat

use Modern::Perl;
BEGIN { 
	use Path::Tiny;
	use lib path($0)->dirname;
	use Opcodes;
}
use Clone 'clone';
use Text::Table;
use Carp (); 
$SIG{__DIE__} = \&Carp::confess;
use warnings FATAL => 'all';

@ARGV==2 or die "Usage: $0 input_file.dat output_file.txt\n";
my($input_file, $output_file) = @ARGV;

my $opcodes = Opcodes->from_file($input_file);

my $sep = \"|";

$opcodes = expand_consts($opcodes);
my $opcode_table = make_opcode_table($opcodes);
my $hex_table = make_hex_table($opcodes);

open(my $fh, ">", $output_file) or die $!;
print $fh $opcode_table->rule('=');
print $fh $opcode_table->title;
print $fh $opcode_table->rule('=');
print $fh $opcode_table->body;
print $fh $opcode_table->rule('=');
print $fh "\n\n";
print $fh $hex_table->rule('=');
print $fh $hex_table->title;
print $fh $hex_table->rule('=');
print $fh $hex_table->body;
print $fh $hex_table->rule('=');


sub expand_consts {
	my($opcodes_in) = @_;
	my $opcodes_out = Opcodes->new;

	for my $asm (sort keys %{$opcodes_in->opcodes}) {
		for my $cpu (sort keys %{$opcodes_in->opcodes->{$asm}}) {
			my $opcode = $opcodes_in->opcodes->{$asm}{$cpu};
			
			if ($asm =~ /%c/) {
				my @range = @{$opcode->const};
				for my $c (@range) {
					my $opcode1 = replace_const($c, $opcode);
					$opcodes_out->add($opcode1);
				}
			}
			else {
				$opcodes_out->add($opcode);
			}
		}
	}
	
	return $opcodes_out;
}	

sub replace_const {
	my($c, $opcode) = @_;
	
	my $opcode1 = clone $opcode; 	# deep copy
	
	my $c_str = ($opcode1->{asm} =~ /rst/ || $c >= 10) ? sprintf("%02Xh", $c) : $c;
	$opcode1->{asm} =~ s/%c/$c_str/;
	
	for my $op (@{$opcode1->ops}) {
		for my $byte (@$op) {
			if ($byte =~ s/%c/$c/g) {
				$byte = eval($byte); die "$byte: $@" if $@;
			}
		}
	}
	
	return $opcode1;
}
	
sub make_opcode_table {
	my($opcodes) = @_;
	my $tb = Text::Table->new($sep, "Assembly", $sep, "CPUs", $sep);

	for my $asm (sort keys %{$opcodes->opcodes}) {
		my @cpus;
		for my $cpu (Opcode->cpus()) {
			if ($opcodes->exists($cpu, $asm)) {
				push @cpus, $cpu;
			}
			else {
				push @cpus, "-".(" " x (length($cpu)-1));
			}
		}
		$tb->add($asm, "@cpus");
	}
	return $tb;
}

sub make_hex_table {
	my($opcodes) = @_;
	my $tb = Text::Table->new($sep, "Assembly", $sep, "CPU", $sep, "Synth", $sep, "Opcodes", $sep);

	for my $asm (sort keys %{$opcodes->opcodes}) {
		for my $cpu (sort keys %{$opcodes->opcodes->{$asm}}) {
			my $opcode = $opcodes->opcodes->{$asm}{$cpu};
			my @ops = @{$opcode->ops};
			my @bytes;
			for my $op (@ops) {
				for my $byte (@$op) {
					if ($byte =~ /^\d+$/) {
						push @bytes, sprintf("%02X", $byte);
					}
					else {
						push @bytes, $byte;
					}
				}
			}
			$tb->add($asm, $cpu, $opcode->synth ? "X" : "-", "@bytes");
		}
	}
	return $tb;
}
