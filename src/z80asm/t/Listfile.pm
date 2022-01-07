#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2022
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#
# Test generation of listfiles by z80asm

package t::Listfile;

use Modern::Perl;
use Object::Tiny::RW qw(
		LINENR		
		LINENR_STACK
		ADDR 		
		LABEL_ADDR	
		LABEL_TYPE
		LABEL_SCOPE
		LIST_ASM	
		LIST_BIN	
		LIST_LST	
		LIST_ON 
		LABELS
);
use Test::More;
use Test::Differences; 
use File::Slurp;
use List::Uniq 'uniq';
BEGIN { 
	use lib '.'; 
	use t::TestZ80asm; *z80asm = \&::z80asm; # z80asm already imported in another package
};

my $LABEL_RE = qr/\b[A-Z_][A-Z0-9_]*/;
my $MAX_LINE = 255-2;
my $COLUMN_WIDTH = 32;

#------------------------------------------------------------------------------
# Class methods
#------------------------------------------------------------------------------
sub max_line { return $MAX_LINE; }

#------------------------------------------------------------------------------
# Construct a list test object
#------------------------------------------------------------------------------
sub new {
	my($class, %args) = @_;
	return bless {
		LINENR			=> 1,
		LINENR_STACK	=> [],
		ADDR 			=> 0,
		LABEL_ADDR		=> {},
		LABEL_TYPE		=> {},
		LABEL_SCOPE		=> {},
		LIST_ASM		=> [],
		LIST_BIN		=> [],
		LIST_LST		=> [],
		LIST_ON 		=> 1,
	}, $class;
}

sub line_nr {
	my($self) = @_;
	return $self->{LINENR};
}

#------------------------------------------------------------------------------
# advance list line number
#------------------------------------------------------------------------------
sub next_line {
	my($self) = @_;
	$self->LINENR( $self->LINENR + 1 );
}

#------------------------------------------------------------------------------
# push list line - interpreets any ALL_CAPS word as a label
#------------------------------------------------------------------------------
sub push_asm {
	my($self, $asm, @bytes) = @_;

	my $new_list_on = $self->LIST_ON;
	
	# handle asm, interpreet labels
	if ($asm) {				
		push @{$self->LIST_ASM}, $asm 
			unless @{$self->LINENR_STACK};			# not if inside include
		
		if ($asm =~ /^\s*($LABEL_RE)\s*:/) {		# define label
			$self->LABEL_ADDR->{$1} = $self->ADDR;
			$self->LABEL_TYPE->{$1} = 'addr';
			$self->LABEL_SCOPE->{$1} ||= 'local';
		}
		elsif ($asm =~ /^\s*defc\s+($LABEL_RE)\s*=\s*(.*)/) {		# define constant
			$self->LABEL_ADDR->{$1} = 0+eval($2);
			$self->LABEL_TYPE->{$1} = 'const';
			$self->LABEL_SCOPE->{$1} ||= 'local';
		}
		elsif ($asm =~ /(?i:public)\s+($LABEL_RE)/) {	# global label
			$self->LABEL_SCOPE->{$1} = 'public';
		}
		elsif ($asm =~ /^\s*lstoff\s*$/i) {
			$new_list_on = 0;
		}
		elsif ($asm =~ /^\s*lston\s*$/i) {
			$new_list_on = 1;
		}
		else {
		}
	}
	
	# handle bin
	push @{$self->LIST_BIN}, pack("C*", @bytes);
	
	# handle list
	my $lst = sprintf("%-5d %04X  ", $self->LINENR, $self->ADDR);
	
	my @lst_bytes = @bytes;
	while (@lst_bytes) {
		my @lst_block = splice(@lst_bytes, 0, 32);
		$lst .= join('', map {sprintf("%02X ", $_)} @lst_block);
		$self->ADDR( $self->ADDR + @lst_block );

		# still for another row?
		if (@lst_bytes) {
			if ($self->LIST_ON) {
				push @{$self->LIST_LST}, $lst;
				$self->next_line(); 
				$self->LINENR( $self->LINENR - 1 );
			}
			$lst = sprintf("%5s %04X  ", "", $self->ADDR);
		}
	}
	
	# assembly
	if (@bytes <= 4) {
		$lst = sprintf("%-24s%s", $lst, $asm // '');
	}
	else {
		if ($self->LIST_ON) {
			push @{$self->LIST_LST}, $lst;
			$self->next_line(); 
			$self->LINENR( $self->LINENR - 1 );
		}
		$lst = sprintf("%-24s%s", "", $asm // '');
	}		

	if ($self->LIST_ON) {
		push @{$self->LIST_LST}, $lst;
		$self->next_line(); 
	}
	else {
		$self->LINENR( $self->LINENR + 1 );
	}
	
	$self->LIST_ON( $new_list_on );
}

#------------------------------------------------------------------------------
# hanble includes
#------------------------------------------------------------------------------
sub push_include {
	my($self, $file) = @_;
	$self->push_asm("include \"$file\"");
	push @{$self->LINENR_STACK}, $self->LINENR;
	$self->LINENR( 1 );
}

sub pop_include {
	my($self) = @_;
	$self->push_asm();
	@{$self->LINENR_STACK} or die;
	$self->LINENR( pop( @{$self->LINENR_STACK} ) );
}
	
#------------------------------------------------------------------------------
# compare result file with list of expected lines
#------------------------------------------------------------------------------
sub compare_list_file {
	my($self, $file, @expected) = @_;

	note "Test at ",join(" ", caller);
	
	my @got = sort(read_file($file));
	chomp(@got);
	@expected = sort(@expected);
	
	is_text( \@got, \@expected, "compare $file" );
}

#------------------------------------------------------------------------------
# Return list of lines of symbol table
sub sym_lines {
	my($self) = @_;
	my @sym;
	
	for (keys %{$self->LABEL_ADDR}) {
		my $line = sprintf("%-*s = \$%04X ; %-7s %-7s", 
					 $COLUMN_WIDTH - 1, $_, 
					 $self->LABEL_ADDR->{$_},
					 $self->LABEL_TYPE->{$_},
					 $self->LABEL_SCOPE->{$_});
		$line =~ s/\s+$//;
		push @sym, $line;

	}
	return @sym;
}

#------------------------------------------------------------------------------
# test list file
#------------------------------------------------------------------------------
sub test {
	my($self) = @_;
	
	my $asm = join("\n", @{$self->LIST_ASM});
	my $bin = join('',   @{$self->LIST_BIN});

	$self->push_asm();
	
	unlink('test.lis', 'test.sym');
	z80asm(
		asm		=> $asm,
		bin		=> $bin,
		options	=> "-b",
	);
	ok ! -f "test.lis", "no test.lis file";
	ok ! -f "test.sym", "no test.sym file";

	unlink('test.lis', 'test.sym');
	z80asm(
		asm		=> $asm,
		bin		=> $bin,
		options	=> "-l -b",
	);
	ok   -f "test.lis", "test.lis file";
	ok ! -f "test.sym", "no test.sym file";
	$self->compare_list_file("test.lis", @{$self->LIST_LST});

	unlink('test.lis', 'test.sym');
	z80asm(
		asm		=> $asm,
		bin		=> $bin,
		options	=> "-s -b",
	);
	ok ! -f "test.lis", "no test.lis file";
	ok   -f "test.sym", "test.sym file";
	$self->compare_list_file("test.sym", $self->sym_lines());
	
	unlink('test.lis', 'test.sym');
	z80asm(
		asm		=> $asm,
		bin		=> $bin,
		options	=> "-s -l -b",
	);
	ok -f "test.lis", "test.lis file";
	ok -f "test.sym", "test.sym file";
	$self->compare_list_file("test.lis", @{$self->LIST_LST});
	$self->compare_list_file("test.sym", $self->sym_lines());
}

1;
