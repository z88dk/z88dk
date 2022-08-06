#!/usr/bin/env perl

#------------------------------------------------------------------------------
# Merge several files with parser rules into one
#------------------------------------------------------------------------------

use Modern::Perl;
use YAML::Tiny;

@ARGV>=2 or die "Usage: $0 input_files.yaml... output_file.yaml\n";
my $output_file = pop @ARGV;
my @input_files = @ARGV;

my %merged_parser;

for my $input_file (@input_files) {
	my $yaml = YAML::Tiny->read($input_file);
	my %parser = %{$yaml->[0]};
	%merged_parser = (%merged_parser, %parser);
}

my $yaml = YAML::Tiny->new(\%merged_parser);
$yaml->write($output_file);
