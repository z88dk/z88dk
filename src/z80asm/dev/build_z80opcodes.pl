#!/usr/bin/perl

#     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
#   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
#                ZZZZZ      888           888  0000         0000
#              ZZZZZ        88888888888888888  0000         0000
#            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
#          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
#        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
#      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
#    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
#  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM
#
# Copyright (C) Paulo Custodio, 2011-2014
#
# Code to test z80asm features, using Udo Munk's z80pack assembler as a reference implementation
#
# Copyright (C) Paulo Custodio, 2011-2014
# 
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/dev/Attic/build_z80opcodes.pl,v 1.3 2014-04-26 08:34:18 pauloscustodio Exp $
#

use Modern::Perl;
use File::Basename;
use File::Slurp;
use Iterator::Array::Jagged;
use Iterator::Simple::Lookahead;
use List::Util qw( max );

my $UDOMUNK_ASM = "dev/z80pack-1.21/z80asm/z80asm.exe";
my $Z80EMU_SRCDIR = '../../libsrc/z80_crt0s/z80_emu';
my @Z80EMU = qw(
		rcmx_cpd
		rcmx_cpdr
		rcmx_cpi
		rcmx_cpir
		rcmx_rld
		rcmx_rrd
);

my $define_opt;
if (@ARGV && $ARGV[0] =~ /-D(.*)/) {
	$define_opt = $1;
	shift;
}
@ARGV==3 or die "Usage: ",basename($0)," [-DDEFINE] DAT_FILE ASM_FILE BIN_FILE\n";

my($dat_file, $asm_file, $bin_file) = @ARGV;
build_z80emu();

# compute assembly test file
my @asm;
my $iter = compute_if( expand_iter( file_iter( $dat_file )));
push @asm, $_ while (defined($_ = $iter->()));
my @hex = assemble(@asm);
merge_asm_hex($asm_file, \@asm, \@hex);
exit 0;

#------------------------------------------------------------------------------
# Iterator to read a file
#------------------------------------------------------------------------------
sub file_iter {
	my($filename) = @_;
	open(my $fh, $filename) or die "open $filename: $!";
	return Iterator::Simple::Lookahead->new( sub {scalar <$fh>} );
}

#------------------------------------------------------------------------------
# Iterator to expand sequences of {a b c} into lines with a,b,c
#------------------------------------------------------------------------------
sub expand_iter {
	my($in) = @_;
	my %neg_flag = qw(  z  nz  nz z
						c  nc  nc c
						po pe  pe po
						p  m   m  p
					);

	return Iterator::Simple::Lookahead->new( sub {
		while (1) {
			my $line = $in->next or return;

			$line =~ s/\$(Header|Log|Id).*//;
			
			my @args = split(/ ( \{ [^\}]+ \} ) /x, $line);		# separate lists
			if (@args == 1) {
				return $line;					# no lists
			}
			else {
				my @out;
				
				# expand each {a b c} into [a,b,c] and {1} into @item_ref
				my @item_ref = (undef);		# $item_ref[1] = item-1-pos
				my $i = 0;
				for (@args) {
					if (/ \{ (.*) \} /x) {
						my @items = split(' ', $1);
						if (@items == 1 && $items[0] =~ /^\d+/) {		# {1}
							$_ = [$_];
						}
						else {
							$_ = \@items;
							push @item_ref, $i;
						}
					}
					else {
						$_ = [$_];
					}
					$i++;
				}
				
				# iterate through lists
				my $iter = Iterator::Array::Jagged->new(data => \@args);
				while (my @set = $iter->next) {
					# expand {1}, {2}, ...
					for (@set) {
						if (/ \{ (\d+) (.*) \} /x) {
							$_ = $set[ $item_ref[ $1 ] ];
							if ($2) {
								# transformations: -XXX -> remove XXX
								my $transf = $2;
								if ($transf =~ /-(.*)/) {
									my $remove = $1;
									s/$remove//g;
								}
								elsif ($transf eq '!') {
									defined $neg_flag{$_} or die "flag '$_' not found";
									$_ = $neg_flag{$_};
								}
								else {
									die "unknown transformation '$transf'";
								}
							}
						}
					}
					push @out, join("", @set);
				}
				
				# push lines to input stream
				$in->unget( @out );
			}
		}
	} );
}

#------------------------------------------------------------------------------
# Iterator to handle IF/ELSE/ENDIF based on $define_opt
#------------------------------------------------------------------------------
sub compute_if {
	my($in) = @_;

	my @state = (1);
	return Iterator::Simple::Lookahead->new( sub {
		while (1) {
			my $line = $in->next or return;
			if ($line =~ /^\s*IF\s+(.*)/i) {
				my $expr = $1;
				my $not = $expr =~ s/^\s*!\s*//;
				$expr =~ /^(\w+)\s*(;.*)?$/ or die "IF expression must be identifier";
				push @state, (uc($1) eq uc($define_opt || ""));
				$state[-1] = ! $state[-1] if $not;
			}
			elsif ($line =~ /^\s*ELSE/i) {
				$state[-1] = ! $state[-1];
			}
			elsif ($line =~ /^\s*ENDIF/i) {
				@state > 1 or die "ENDIF without IF";
				pop @state;
			}
			else {
				return $line if $state[-1];
			}
		}		
	} );
}

#------------------------------------------------------------------------------
# use z80pack to assemble the code after ;; and return the hex bytes per line
#------------------------------------------------------------------------------
sub assemble {
	my(@asm_code) = @_;
	our $label_n;
	
	my @pack_code = build_pack_code(@asm_code);
	
	# Append used libraries
	my %used_libs; for (@Z80EMU) { $used_libs{$_} = 0; }
	for (@pack_code) {
		my $line = $_;
		$line =~ s/;.*//;
		if ($line =~ /call\s+(\w+)/i && exists $used_libs{$1}) {
			$used_libs{$1} = 1;
		}
	}
	for my $lib (@Z80EMU) {
		if ($used_libs{$lib}) {
			my $lib_asm = read_file($Z80EMU_SRCDIR.'/'.$lib.'.asm');
			$label_n++;
			
			# remove invalid asm
			for ($lib_asm) {
				s/^\s*(PUBLIC|EXTERN|XDEF|XREF|LIB|XLIB).*//igm;
				while (/^\.(\w+)/im) {
					my $label = $1;
					my $new_label = (uc($label) eq uc($lib)) ? $label : $label.$label_n;
					s/^\.$label\b/$new_label:/igm;
					s/\b$label\b/$new_label/igm;
				}
			}
			
			# make labels local
			push @pack_code, $lib_asm;
		}
	}
	write_file("test.asm", @pack_code);
	call_assembler("test.asm");
	my @hex = read_hex("test.lis");
	
	unlink('test.asm', 'test.lis', 'test.bin');
	
	return @hex;
}

# add LINE markers, followed by code after ;;
sub build_pack_code {
	my(@asm_code) = @_;
	my @pack_code;
	
	for my $i (0 .. $#asm_code) {
		my $line = $asm_code[$i];
		push @pack_code, ";;LINE $i\n";
		
		if ($line !~ /^;/ && $line =~ /;;(.*)/) {
			for (split(/;;/, $1)) {
				push @pack_code, "$_\n";
			}
		}
		else {
			push @pack_code, $line;
		}
	}
	
	return @pack_code;
}
		
sub call_assembler {
	my($asm_file) = @_;
	
	my $args = ($define_opt ? "-d".$define_opt : "")." -fb -l -o$bin_file $asm_file";
	
	-f $UDOMUNK_ASM && -x _ or die "cannot find assembler $UDOMUNK_ASM";
	print "$UDOMUNK_ASM $args\n";
	system "$UDOMUNK_ASM $args" and die "$UDOMUNK_ASM $args failed";
}

# read hex between LINE markers
sub read_hex {
	my($lis_file) = @_;
	my @hex;
	
	open(my $in, "<", $lis_file) or die $!;
	while(<$in>) {
		next if /^\f/;
		next if /^Source file:/;
		next if /^Title:/;
		next if /^LOC/;
		next unless /\S/;
		
		if (/^([0-9a-f]{4} )(( [0-9a-f]{2}){1,4})/i) {
			@hex or die;
			$hex[-1]  = uc($1) unless $hex[-1];
			$hex[-1] .= uc($2);
		}
		elsif (/;;LINE (\d+)/) {
			$hex[$1] ||= "";
		}
	}
	return @hex;
}

#------------------------------------------------------------------------------
# merge asm code with hex code
#------------------------------------------------------------------------------
sub merge_asm_hex {
	my($out_file, $asm, $hex) = @_;
	
	# write z80asm code with hex representation
	open(my $out, ">", $out_file) or die "write $out_file: $!";
	for my $i (0 .. max( $#$asm, $#$hex ) ) {
		local $_ = $asm->[$i];
		chomp;
		
		if (! defined $_) {
			if ($hex->[$i]) {
				print $out sprintf("%-39s ;=> %s\n", "", $hex->[$i]);
			}
		}
		elsif (/^\s*;/) {
			print $out "$_\n";
			if ($hex->[$i]) {
				print $out sprintf("%-39s ;=> %s\n", "", $hex->[$i]);
			}
		}
		else {
			s/;.*//;
			s/\s+/ /g;
			s/^\s+/        /;
			s/^(\s+)(\S+)\s+/ sprintf("%s%-4s ", $1, $2) /e;
			
			if ($hex->[$i]) {
				$_ = sprintf("%-39s ;=> %s", $_, $hex->[$i]);
			}
			print $out "$_\n";
		}
	}
}

#------------------------------------------------------------------------------
# build z80emu library
#------------------------------------------------------------------------------
sub build_z80emu {
	my @z80emu_src = map {$Z80EMU_SRCDIR.'/'.$_.'.asm'} @Z80EMU;
	my $cmd = "./z80asm -l -d @z80emu_src";	
	print "$cmd\n";
	system $cmd and die "assembly failed";
}


# $Log: build_z80opcodes.pl,v $
# Revision 1.3  2014-04-26 08:34:18  pauloscustodio
# No RCS keywords in generated files
#
# Revision 1.2  2014/04/26 08:28:30  pauloscustodio
# Was missing z80emu library code at end of benchmark asm file
#
# Revision 1.1  2014/04/25 23:55:48  pauloscustodio
# Create asm and binary files at dev/Makefile using z80pack's assembler as benchmarks
# to test the z80asm assembler. These files are used during testing.
#
#
