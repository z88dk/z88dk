#!/usr/bin/env perl

#------------------------------------------------------------------------------
# generate test data for z80nm
#------------------------------------------------------------------------------

use Modern::Perl;
use Getopt::Std;
use Path::Tiny;
use Data::Dump 'dump';

#------------------------------------------------------------------------------
# String table
#------------------------------------------------------------------------------
package StringTable;

use Modern::Perl;
use Object::Tiny qw( strs index );

sub new {
	my($class) = @_;
	return bless {strs => [""], index => {0 => ""}}, $class;
}

sub add {
	my($self, $str) = @_;
	if (exists $self->index->{$str}) {
		return $self->index->{$str};
	}

	my $index = $self->size;
	push @{$self->strs}, $str;
	$self->index->{$str} = $index;
	return $index;
}

sub get {
	my($self, $index) = @_;
	return $self->strs->[$index];
}

sub size {
	my($self) = @_;
	return scalar @{$self->strs};
}

#------------------------------------------------------------------------------
# Binary data
#------------------------------------------------------------------------------
package BinData;

use Modern::Perl;
use Object::Tiny qw( bytes st );

sub new {
	my($class) = @_;
	return bless {bytes => [], st => StringTable->new }, $class;
}

sub size {
	my($self) = @_;
	return scalar @{$self->bytes};
}

sub data { 
	my($self) = @_;
	return pack("C*", @{$self->bytes});
}

sub pack_byte {
	my($self, $value) = @_;
	push @{$self->bytes}, $value & 0xFF;
}

sub pack_word {
	my($self, $value) = @_;
	push @{$self->bytes}, $value & 0xFF, ($value >> 8) & 0xFF;
}

sub pack_long {
	my($self, $value) = @_;
	push @{$self->bytes}, $value & 0xFF, ($value >> 8) & 0xFF, 
						($value >> 16) & 0xFF, ($value >> 24) & 0xFF;
}

sub patch_long {
	my($self, $addr, $value) = @_;
	$addr+4 <= $self->size or die "invalid patch at address $addr";
	$self->bytes->[$addr] = $value & 0xFF;
	$self->bytes->[$addr + 1] = ($value >> 8) & 0xFF;
	$self->bytes->[$addr + 2] = ($value >> 16) & 0xFF;
	$self->bytes->[$addr + 3] = ($value >> 24) & 0xFF;
}

sub pack_string {
	my($self, $text) = @_;
	push @{$self->bytes}, map {ord} split //, $text;
}

sub pack_cstring {
	my($self, $text) = @_;
	length($text) <= 0xFF or die "string too long: $text";
	$self->pack_byte(length($text));
	$self->pack_string($text);
}

sub pack_lstring {
	my($self, $text) = @_;
	length($text) <= 0xFFFF or die "string too long: $text";
	$self->pack_word(length($text));
	$self->pack_string($text);
}

sub pack_strid {
	my($self, $text) = @_;
	my $id = $self->st->add($text);
	$self->pack_long($id);
}

sub pack_signature {
	my($self, $signature, $version) = @_;
	$self->pack_string(sprintf("%-6.6s%02d", $signature, $version));
}

#------------------------------------------------------------------------------
# main
#------------------------------------------------------------------------------
package main;

my $usage = "usage: $0 [-vNN] input...\n";
my $version = 19;
my @CPUS = parse_cpus("../../z80asm/z80asm2/cpu.def");
my %opts;
getopts('v:b', \%opts) or die $usage;
my @files = @ARGV or die $usage;

# get version
if (exists $opts{v}) {
	$version = $opts{v}+0;
	die "invalid version $version\n" if $version < 1 || $version > 19;
}

# parse files
for my $file (@files) {
	-f $file or die "file not found: $file\n";
	my $data = parse_file($file);
	say "File $file:";
	say dump($data);
	if ($data && $opts{b}) {
		my $out_file = exists $data->{module} ?  "$file.o" : 
					   exists $data->{library} ? "$file.lib" :
					   die("invalid data");
		write_obj_file($out_file, $data, $version);
	}
}

#------------------------------------------------------------------------------
# parse files
#------------------------------------------------------------------------------
sub parse_file {
	my($file) = @_;
	if ($file =~ /\.def$/) {
		parse_def_file($file);
	}
	elsif ($file =~ /\.o$|\.lib$/) {
		parse_obj_file($file);
	}
	else {
		die "invalid extension in $file\n";
	}
}

sub parse_def_file {
	my($file) = @_;
	
	# collect lines, remove comments and white space
	my @lines = path($file)->lines({chomp=>1});
	for (@lines) {
		s/^\s+|\s+$//g;	# trim white space
		s/;.*//;		# remove comments
	}
	@lines = map {[$lines[$_], $file, $_+1]} 0..$#lines; # [text, file, line]
	@lines = grep {$_->[0] ne ''} @lines;
	
	my $data = parse_def(\@lines);
	return $data;
}

sub error {
	my($msg, $lines) = @_;
	if (@$lines) {
		die "error at $lines->[0][1] line $lines->[0][2]: $msg\n\t$lines->[0][0]\n";
	}
	else {
		die "error at end of file: $msg\n";
	}
}

sub parse_def {
	my($lines) = @_;
	@$lines == 0 and error("unexpected end of input", $lines);
	if ($lines->[0][0] =~ /^Module$/i) {
		shift @$lines;
		my $mod = parse_module($lines);
		$lines->[0][0] =~ /^EndModule$/ or error("EndModule expected", $lines);
		shift @$lines;
		
		@$lines == 0 or error("cannot parse", $lines);
		return { module => $mod };
	}
	else {
		error("cannot parse", $lines);
	}
}

sub parse_module {
	my($lines) = @_;
	my $mod = { name=>'', cpu=>lookup_cpu('z80'), ixiy=>0, 
				exprs=>[], symbols=>[], externs=>[], sections=>[] };
	while (@$lines) {
		if ($lines->[0][0] =~ /^Name:\s*(.*)/i) {
			my $name = $1;
			$name =~ /^\w+$/ or error("invalid name: $name", $lines);
			$mod->{name} = $name;
			shift @$lines;
		}
		elsif ($lines->[0][0] =~ /^CPU:\s*(.*)/i) {
			my $cpu = lookup_cpu($1) or error("invalid CPU: $1", $lines);
			$mod->{cpu} = $cpu;
			shift @$lines;
		}
		elsif ($lines->[0][0] =~ /^IXIY:\s*(.*)/i) {
			my $ixiy = $1;
			$ixiy =~ /^\d+$/ or error("invalid ixiy: $ixiy", $lines);
			$ixiy >= 0 && $ixiy <= 2 or error("invalid ixiy: $ixiy", $lines);
			$mod->{ixiy} = $ixiy;
			shift @$lines;
		}
		elsif ($lines->[0][0] =~ /^Org:\s*(.*)/i) {
			my $org = eval($1);
			$@ and error("invalid org $1: $@", $lines);
			$mod->{org} = $org;
			shift @$lines;
		}
		elsif ($lines->[0][0] =~ /^Expressions$/) {
			shift @$lines;
			my @exprs = parse_exprs($lines);
			$lines->[0][0] =~ /^EndExpressions$/ or error("EndExpressions expected", $lines);
			shift @$lines;
			
			push @{$mod->{exprs}}, @exprs;
		}
		elsif ($lines->[0][0] =~ /^Symbols$/) {
			shift @$lines;
			my @symbols = parse_symbols($lines);
			$lines->[0][0] =~ /^EndSymbols$/ or error("EndSymbols expected", $lines);
			shift @$lines;
			
			push @{$mod->{symbols}}, @symbols;
		}
		elsif ($lines->[0][0] =~ /^Externs$/) {
			shift @$lines;
			my @externs = parse_externs($lines);
			$lines->[0][0] =~ /^EndExterns$/ or error("EndExterns expected", $lines);
			shift @$lines;
			
			push @{$mod->{externs}}, @externs;
		}
		elsif ($lines->[0][0] =~ /^Sections$/) {
			shift @$lines;
			my @sections = parse_sections($lines);
			$lines->[0][0] =~ /^EndSections$/ or error("EndSections expected", $lines);
			shift @$lines;
			
			push @{$mod->{sections}}, @sections;
		}
		else {
			last;
		}
	}
	return $mod;
}

sub parse_exprs {
	my($lines) = @_;
	my @exprs;
	return @exprs;
}

sub parse_symbols {
	my($lines) = @_;
	my @symbols;
	return @symbols;
}

sub parse_externs {
	my($lines) = @_;
	my @externs;
	return @externs;
}

sub parse_sections {
	my($lines) = @_;
	my @sections;
	return @sections;
}

#------------------------------------------------------------------------------
# output files
#------------------------------------------------------------------------------
sub write_obj_file {
	my($file, $data, $version) = @_;
	my $bin = BinData->new;
	pack_module($data, $bin, $version);
	my $bytes = $bin->data;
	path($file)->spew_raw($bytes);
}

sub pack_module {
	my($data, $bin, $version) = @_;
	if (exists $data->{module}) {
		pack_obj($data->{module}, $bin, $version);
	}
	elsif (exists $data->{library}) {
		pack_lib($data->{library}, $bin, $version);
	}
	else {
		die "invalid data";
	}
}

sub pack_obj {
	my($data, $bin, $version) = @_;
	
	# header
	$bin->pack_signature("Z80RMF", $version);
	$bin->pack_word(exists $data->{org} ? $data->{org} : 0xFFFF);

	# pointers to sections
	my $header_ptr = $bin->size;
	for (1..5) {
		$bin->pack_long(-1);
	}
	
	# sections
	my $exprs_ptr;
	if (@{$data->{exprs}}) {
		$exprs_ptr = $bin->size;
		pack_exprs($data->{exprs}, $bin, $version);
	}
	
	my $symbols_ptr;
	if (@{$data->{symbols}}) {
		$symbols_ptr = $bin->size;
		pack_symbols($data->{symbols}, $bin, $version);
	}
	
	my $externs_ptr;
	if (@{$data->{externs}}) {
		$externs_ptr = $bin->size;
		pack_externs($data->{externs}, $bin, $version);
	}
	
	my $modname_ptr = $bin->size;
	pack_modname($data->{name}, $bin, $version);
	
	my $sections_ptr;
	if (@{$data->{sections}}) {
		$sections_ptr = $bin->size;
		pack_sections($data->{sections}, $bin, $version);
	}
	
	# patch pointers
	if ($modname_ptr) {
		$bin->patch_long($header_ptr + 0*4, $modname_ptr);
	}
	if ($exprs_ptr) {
		$bin->patch_long($header_ptr + 1*4, $exprs_ptr);
	}
	if ($symbols_ptr) {
		$bin->patch_long($header_ptr + 2*4, $symbols_ptr);
	}
	if ($externs_ptr) {
		$bin->patch_long($header_ptr + 3*4, $externs_ptr);
	}
	if ($sections_ptr) {
		$bin->patch_long($header_ptr + 4*4, $sections_ptr);
	}
}

sub pack_exprs {
	my($exprs, $bin, $version) = @_;
}

sub pack_symbols {
	my($symbols, $bin, $version) = @_;
}

sub pack_externs {
	my($externs, $bin, $version) = @_;
}

sub pack_sections {
	my($sections, $bin, $version) = @_;
}

sub pack_modname {
	my($modname, $bin, $version) = @_;
	$bin->pack_cstring($modname);
}

#------------------------------------------------------------------------------
# CPUS
#------------------------------------------------------------------------------
sub parse_cpus {
	my($file) = @_;
	my @cpus;
	for (path($file)->lines({chomp=>1})) {
		next unless /^\s*X\(\s*(\d+)\s*,\s*\w+\s*,\s*"(\w+)"/;
		push @cpus, [$1, $2];
	}
	return @cpus;
}

sub lookup_cpu {
	my($key) = @_;
	for (@CPUS) {
		my($id, $name) = @$_;
	
		if ($key =~ /^\d+$/ && $key != 8080 && $key != 8085) {
			return $name if $id == $key;
		}
		else {
			return $id if $name eq $key;
		}
	}
	return undef;
}
