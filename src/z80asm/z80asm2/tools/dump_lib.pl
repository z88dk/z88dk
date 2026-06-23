#!/usr/bin/env perl

use Modern::Perl;
use Path::Tiny;
use warnings FATAL => 'all';

our $indent = 0;

my @CPU = qw(
	none
	z80
	z80_strict
	z180
	ez80_z80
	ez80
	z80n
	r2ka
	r3k
	gbz80
	i8080
	i8085
	r800
	r4k
	r5k
	kc160
	kc160_z80
	i8080_strict
	i8085_strict
	gbz80_strict
	z180_strict
	z80n_strict
	ez80_z80_strict
	ez80_strict
	r800_strict
	kc160_strict
	kc160_z80_strict
	r2ka_strict
	r3k_strict
	r4k_strict
	r5k_strict
	r6k
	r6k_strict
	ti83
	ti83_strict
	ti83plus
	ti83plus_strict
);

my @EXPR_TYPE = qw(
    Undefined
    JrOffset
    ByteUnsigned
    ByteSigned
    Word
    WordBE
    DWord
    ByteToWordUnsigned
    ByteToWordSigned
    Ptr24
    HighOffset
    Assignment
    JreOffset
    ByteToPtrUnsigned
    ByteToPtrSigned
);

my @SYM_SCOPE = qw(
    Undefined
    Local
    Public
);

my @SYM_TYPE = qw(
    Undefined
    Constant
    AddressRelative
    Computed
);

package Stream;
	sub new {
		my($class, $bin) = @_;
		bless { bin => $bin, pos => 0 }, $class;
	}

	sub get_pos {
		my($self) = @_;
		return $self->{pos};
	}

	sub set_pos {
		my($self, $pos) = @_;
		$self->{pos} = $pos;
	}

	sub get_int32 {
		my($self) = @_;
		my $v = $self->get_value("V");
		if ($v == 0xFFFFFFFF) { $v = -1; }
		return $v;
	}
	
	sub get_signature {
		my($self) = @_;
		return $self->get_value("a8");
	}
		
	sub get_value {
		my($self, $template) = @_;
		#say $self->{pos}, " ", $template;		
		my $v = unpack($template, substr($self->{bin}, $self->{pos}));
		$self->{pos} += length(pack($template, 0));
		#say $self->{pos}, " ", $template, " = ", $v;
		return $v;
	}
	
package main;

@ARGV==1 or die "usage: $0 input-file\n";
my $input_file = $ARGV[0];
my $bin = Stream->new(path($input_file)->slurp_raw);

dump_file($bin);

sub dump_file {
	my($bin) = @_;

	# extract signature
	my $signature = $bin->get_signature();
	out("Signature: $signature");

	if ($signature eq "Z80LMF18") {
		indent();
		dump_lib($bin);
		outdent();
	}
	elsif ($signature eq "Z80RMF18") {
		indent();
		dump_obj($bin);
		outdent();
	}
	else {
		die "invalid signature\n";
	}
}

sub dump_lib {
	my($bin) = @_;
	my $st_pos = $bin->get_int32();
	my $save_pos = $bin->get_pos();
	$bin->set_pos($st_pos);
	my @strings = dump_string_table($bin);
	$bin->set_pos($save_pos);

	my $next_pos = 0;
	for ($next_pos >= 0) {
		$next_pos = $bin->get_int32();
		out("Next: $next_pos");
		my $size = $bin->get_int32();
		out("Size: $size");
		
		indent();
		dump_file($bin);
		outdent();
		
		$bin->set_pos($next_pos) if $next_pos >= 0;
	}
}

sub dump_obj {
	my($bin) = @_;
	
	my $base = $bin->get_pos() - 8;		# start of file
	out("Base address: $base");
	
	# get header
	my $cpu = $bin->get_int32();
	out("CPU: $cpu ($CPU[$cpu])");
	my $swap_ix_iy = $bin->get_int32();
	out("Swap IX/IY: $swap_ix_iy");
	
	# File pointer to Module Name
	my $modname_pos = $bin->get_int32();
	out("Module name pos: $modname_pos");
	
	# File pointer to Expressions
	my $expr_pos = $bin->get_int32();
	out("Expressions pos: $expr_pos");
	
	# File pointer to Defined Symbols
	my $symbols_pos = $bin->get_int32();
	out("Symbols pos: $symbols_pos");
	
	# File pointer to External Symbols
	my $externs_pos = $bin->get_int32();
	out("Externs pos: $externs_pos");
	
	# File pointer to Sections
	my $sections_pos = $bin->get_int32();
	out("Sections pos: $sections_pos");
	
	# File pointer to String Table
	my $st_pos = $bin->get_int32();
	out("String table pos: $st_pos");
	
	# dump string table
	$bin->set_pos($base + $st_pos);
	my @strings = dump_string_table($bin);
	
	# dump module name
	$bin->set_pos($base + $modname_pos);
	my $modname_id = $bin->get_int32();
	out("Module name: $strings[$modname_id]");
	
	# dump expressions
	if ($expr_pos >= 0) {
		$bin->set_pos($base + $expr_pos);
		out("Expressions:");
		my $type = 1;
		while ($type > 0) {
			indent();
				$type = $bin->get_int32();
				if ($type > 0) {
					out("Expression:");
					indent();
						out("Type: $type ($EXPR_TYPE[$type])");
						my $file_id = $bin->get_int32();
						out("File: $strings[$file_id]");
						my $line = $bin->get_int32();
						out("Line: $line");
						my $section_id = $bin->get_int32();
						out("Section: $strings[$section_id]");
						my $asmpc = $bin->get_int32();
						out("ASMPC: $asmpc");
						my $patch_ptr = $bin->get_int32();
						out("Patch ptr: $patch_ptr");
						my $opcode_size = $bin->get_int32();
						out("Opcode size: $opcode_size");
						my $target_id = $bin->get_int32();
						out("Target: $strings[$target_id]");
						my $expr_id = $bin->get_int32();
						out("Text: $strings[$expr_id]");
					outdent();
				}
			outdent();
		}
	}
	
	# dump symbols
	if ($symbols_pos >= 0) {
		$bin->set_pos($base + $symbols_pos);
		out("Symbols:");
		my $scope = 1;
		while ($scope > 0) {
			indent();
				$scope = $bin->get_int32();
				if ($scope > 0) {
					out("Symbol:");
					indent();
						out("Scope: $scope ($SYM_SCOPE[$scope])");
						my $type = $bin->get_int32();
						out("Type: $type ($SYM_TYPE[$type])");
						my $section_id = $bin->get_int32();
						out("Section: $strings[$section_id]");
						my $value = $bin->get_int32();
						out("Value: $value");
						my $name_id = $bin->get_int32();
						out("Name: $strings[$name_id]");
						my $file_id = $bin->get_int32();
						out("File: $strings[$file_id]");
						my $line = $bin->get_int32();
						out("Line: $line");
					outdent();
				}
			outdent();
		}
	}

	# dump externs
	if ($externs_pos >= 0) {
		$bin->set_pos($base + $externs_pos);
		out("Externs:");
		my $name_id = 1;
		while ($name_id > 0) {
			indent();
				$name_id = $bin->get_int32();
				if ($name_id > 0) {
					out("Name: $strings[$name_id]");
				}
			outdent();
		}
	}
	
	# dump sections
	if ($sections_pos >= 0) {
		$bin->set_pos($base + $sections_pos);
		out("Sections:");
		my $size = 0;
		while ($size >= 0) {
			indent();
				$size = $bin->get_int32();
				if ($size >= 0) {
					out("Section:");
					indent();
						out("Size: $size");
						my $section_id = $bin->get_int32();
						out("Section: $strings[$section_id]");
						my $org = $bin->get_int32();
						out("ORG: $org");
						my $align = $bin->get_int32();
						out("ALIGN: $align");
						my $bytes = $bin->get_value("a$size");
						out("Bytes: ".join(" ", map {sprintf "%02X", ord($_)} split //, $bytes));
						while ($bin->get_pos() % 4 != 0) {
							my $padding = $bin->get_value("c");
						}
					outdent();
				}
			outdent();
		}
	}
}

sub dump_string_table {
	my($bin) = @_;
	out("String table:");
	indent();
	my $num_strings = $bin->get_int32();
	out("Num strings: $num_strings");
	my $strings_size = $bin->get_int32();
	out("Strings size: $strings_size");
	
	# start position of each string
	my @pos;
	for (0 .. $num_strings-1) {
		push @pos, $bin->get_int32();
	}

	# string blob
	my $blob = $bin->get_value("a".$strings_size);

	# extract each string
	my @strings;
	for (0 .. $num_strings-1) {
		my $start = $pos[$_];
		substr($blob, $start) =~ /\A([^\0]*)\0/
			or die "No null-terminated string found";
		my $str = $1;
		push @strings, $str;
	}
	
	# output
	for (0 .. $num_strings-1) {
		out("$_ : \"$strings[$_]\"");
	}
	
	outdent();
	
	return @strings;
}

sub out {
	say " " x (4*$indent), @_;
}

sub indent {
	$indent++;
}

sub outdent {
	$indent--;
}
