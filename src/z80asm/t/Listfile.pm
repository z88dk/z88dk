#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2015
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Test generation of listfiles by z80asm

package t::Listfile;

use Modern::Perl;
use Object::Tiny::RW qw(
		LINENR		
		LINENR_STACK
		PAGENR		
		PAGE_LINENR	
		ADDR 		
		LABEL_PAGE	
		LABEL_ADDR	
		LABEL_GLOBAL
		LIST_ASM	
		LIST_BIN	
		LIST_LST	
		LIST_ON 	
);
use t::TestZ80asm; *z80asm = \&::z80asm; # z80asm already imported in another package
use Test::More;
use Test::Differences; 
use File::Slurp;
use List::AllUtils 'uniq';

my $LABEL_RE = qr/\b[A-Z_][A-Z0-9_]*/;
my $PAGE_SIZE = 61;
my $LINE_SIZE = 122;
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
		PAGENR			=> 1,
		PAGE_LINENR		=> 1,
		ADDR 			=> 0,
		LABEL_PAGE		=> {},
		LABEL_ADDR		=> {},
		LABEL_GLOBAL	=> {},
		LIST_ASM		=> [],
		LIST_BIN		=> [],
		LIST_LST		=> [],
		LIST_ON 		=> 1,
	}, $class;
}

#------------------------------------------------------------------------------
# advance list line number
#------------------------------------------------------------------------------
sub next_line {
	my($self) = @_;
	$self->LINENR( $self->LINENR + 1 );
	$self->PAGE_LINENR( $self->PAGE_LINENR + 1 );
	if ($self->PAGE_LINENR > $PAGE_SIZE) {
		$self->PAGE_LINENR( 1 );
		$self->PAGENR( $self->PAGENR + 1 );
	}
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
			$self->LABEL_PAGE->{$1} ||= [];
			unshift @{$self->LABEL_PAGE->{$1}}, $self->PAGENR;
			$self->LABEL_ADDR->{$1} = $self->ADDR;
		}
		elsif ($asm =~ /^\s*defc\s+($LABEL_RE)\s*=\s*(.*)/) {		# define constant
			$self->LABEL_PAGE->{$1} ||= [];
			unshift @{$self->LABEL_PAGE->{$1}}, $self->PAGENR;
			$self->LABEL_ADDR->{$1} = 0+eval($2);
		}
		elsif ($asm =~ /(?i:xdef|xlib|public)\s+($LABEL_RE)/) {	# global label
			$self->LABEL_PAGE->{$1} ||= [];
			push @{$self->LABEL_PAGE->{$1}}, $self->PAGENR;
			$self->LABEL_GLOBAL->{$1}++;
		}
		elsif ($asm =~ /^\s*lstoff\s*$/i) {
			$new_list_on = 0;
		}
		elsif ($asm =~ /^\s*lston\s*$/i) {
			$new_list_on = 1;
		}
		else {
			while ($asm =~ /($LABEL_RE)/g) {	# use label
				$self->LABEL_PAGE->{$1} ||= [];
				push @{$self->LABEL_PAGE->{$1}}, $self->PAGENR 
			}
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
# get version and date from hist.c
#------------------------------------------------------------------------------
sub get_copyright {
	our $copyrightmsg;
	unless ($copyrightmsg) {
		my $hist = read_file("hist.c");
		my($version) = 	 $hist =~ /\#define \s+ VERSION   \s+ \" (.*?) \"/x or die;
		my($copyright) = $hist =~ /\#define \s+ COPYRIGHT \s+ \" (.*?) \"/x or die;
		$copyrightmsg = "Z80 Module Assembler ".$version.", (c) ".$copyright;
	}
	
	return $copyrightmsg;
}

#------------------------------------------------------------------------------
# get UNIX date from input text
#------------------------------------------------------------------------------
sub get_unix_date {
	my($text) = @_;

	$text =~ /( (Mon|Tue|Wed|Thu|Fri|Sat|Sun) \s
				(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) \s
				\d\d \s \d\d:\d\d:\d\d \s \d\d\d\d
			  )/x
		or die "Date not found in $text";
	return $1;
}

#------------------------------------------------------------------------------
# compare result file with list of expected lines
#------------------------------------------------------------------------------
sub compare_list_file {
	my($self, $file, @expected) = @_;

	note "Test at ",join(" ", caller);
	
	my @got = read_file($file);
	chomp(@got);
	
	insert_headers(get_copyright(), get_unix_date($got[0]), $file, \@expected);
	
	eq_or_diff \@got, \@expected, "compare $file";
}

#------------------------------------------------------------------------------
# insert headers every $PAGE_SIZE lines
sub insert_headers {
	my($copyright, $date, $file, $lines) = @_;
	my $i = 0;
	my $page = 1;
	
	while ($i <= @$lines) {
		my @insert;
		push @insert, "\f" if $i > 0;
		push @insert, $copyright . " " x ($LINE_SIZE - length($copyright) - length($date)) . $date;
		push @insert, "Page ".sprintf("%03d", $page) . " " x ($LINE_SIZE - 10 - length($file)) . "'$file'";
		push @insert, "";
		push @insert, "";
		
		splice(@$lines, $i, 0, @insert);
		
		$page++;
		$i += @insert + $PAGE_SIZE;
	}
	push @$lines, "\f";
}

#------------------------------------------------------------------------------
# Return list of lines of symbol table
sub sym_lines {
	my($self, $show_pages) = @_;
	my @sym;
	
	push @sym, "";
	push @sym, "";
	push @sym, "Local Module Symbols:";
	push @sym, "";
	
	for (sort {$a cmp $b} keys %{$self->LABEL_ADDR}) {
		push @sym, $self->format_sym_line($_, $show_pages) unless $self->LABEL_GLOBAL->{$_};
	}
	
	push @sym, "";
	push @sym, "";
	push @sym, "Global Module Symbols:";
	push @sym, "";
	
	for (sort {$a cmp $b} keys %{$self->LABEL_ADDR}) {
		push @sym, $self->format_sym_line($_, $show_pages) if $self->LABEL_GLOBAL->{$_};
	}
	
	return @sym;
}

#------------------------------------------------------------------------------
sub format_sym_line {
	my($self, $label, $show_pages) = @_;
	my @ret;
	
	my $line = $label;
	if (length($line) >= $COLUMN_WIDTH) {
		push @ret, $line;
		$line = '';
	}
	$line .= sprintf("%-*s= %04X", 
					 $COLUMN_WIDTH - length($line), '', 
					 $self->LABEL_ADDR->{$label});
	
	if ($show_pages) {
		$line .= " :";
		
		my @pages = uniq @{$self->LABEL_PAGE->{$label}};
		my $first = 1;
		while (my @block = splice(@pages, 0, 15)) {
			my $page = shift @block;
			$line .= sprintf("%4d%s", $page, $first ? '*' : ' ');
			$first = 0;
			
			while (@block) {
				my $page = shift @block;
				$line .= sprintf("%4d ", $page);
			}
			
			if (@pages) {
				push @ret, $line;
				$line = sprintf("%*s", $COLUMN_WIDTH + 2 + 8 + 2, '');
			}
		}
	}
	push @ret, $line;
	
	return @ret;
}

#------------------------------------------------------------------------------
# test list file
#------------------------------------------------------------------------------
sub test {
	my($self) = @_;
	
	my $asm = join("\n", @{$self->LIST_ASM});
	my $bin = join('',   @{$self->LIST_BIN});

	$self->push_asm();
	
	unlink('test.lst', 'test.sym');
	z80asm(
		asm		=> $asm,
		bin		=> $bin,
		options	=> "-ns -nl -r0 -b",
	);
	ok ! -f "test.lst", "no test.lst file";
	ok ! -f "test.sym", "no test.sym file";

	unlink('test.lst', 'test.sym');
	z80asm(
		asm		=> $asm,
		bin		=> $bin,
		options	=> "-ns -l -r0 -b",
	);
	ok   -f "test.lst", "test.lst file";
	ok ! -f "test.sym", "no test.sym file";
	$self->compare_list_file("test.lst", @{$self->LIST_LST});

	unlink('test.lst', 'test.sym');
	z80asm(
		asm		=> $asm,
		bin		=> $bin,
		options	=> "-s -nl -r0 -b",
	);
	ok ! -f "test.lst", "no test.lst file";
	ok   -f "test.sym", "test.sym file";
	$self->compare_list_file("test.sym", $self->sym_lines(0));
	
	unlink('test.lst', 'test.sym');
	z80asm(
		asm		=> $asm,
		bin		=> $bin,
		options	=> "-s -l -r0 -b",
	);
	ok   -f "test.lst", "test.lst file";
	ok ! -f "test.sym", "no test.sym file";
	$self->compare_list_file("test.lst", @{$self->LIST_LST}, $self->sym_lines(1));
}

1;
