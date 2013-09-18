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
# Copyright (C) Paulo Custodio, 2011-2013
#
# Parse a list of *.h files and search for init and fini functions. Generates init.c and init.h.
# User code needs to include init.h in any module using the generated functions and in the module
# defining main(), so that main() is renamed to user_main() by init.h.
# The new main() function in init.c calls all init functions found in the parsed *.h files 
# and registers all the fini funtions to run atexit(), and then continues into user_main().
# The initialization sequence is the same as the order the function are retrieved from the
# command line arguments.
#
# Syntax of parsed *.h files:
# extern void init_XXXX(void)		--> generates a call to init_XXXX() from main() before
#	 									user_main() starts
# extern void fini_XXXX(void)		--> generates a call atexit(fini_XXXX) from main() before
#										user_main() starts
# [typedef] struct YYYY {...};
# extern void struct_YYYY_init(struct YYYY *x, ARGS)
#									--> generates a new function struct YYYY *new_YYYY(ARGS)
#									    that allocates zeroed memory for the structure, calls 
#										struct_YYYY_init() to initialize it, and registers 
#										the object for auto-delete on exit. The function is 
#										declared in init.h
# extern void struct_YYYY_fini(struct YYYY *x)
#									--> generates a new function void delete_YYYY(struct YYYY **x)
#									    that calls struct_YYYY_fini() to release any resources
#										held by the struture, then frees the allocated memory
#										and zeroes the passed pointer to avoid the freed memory
#										being referenced by mistake. The function is 
#										declared in init.h
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/tools/Attic/make_init.pl,v 1.4 2013-09-18 23:03:39 pauloscustodio Exp $
# Log at end of file

use Modern::Perl;
use File::Basename;
use File::Slurp;
use Win32::Autoglob;
use Template;
use Iterator::Simple::Lookahead;
use Data::Dump 'dump';

#------------------------------------------------------------------------------
# C lexer
#------------------------------------------------------------------------------
my $tokens = qr/ (?<space>		(?:	^ [ \t]* \# (?: \\ \n | . )* \n 
								|	\/ \* (?: . | \n )*? \* \/
								|	\/ \/ .* \n 
								|	\\ $
								|	[ \t\f]+ 
								|  	\n
								)+
				 )
			   | (?<string>		L? \" (?: \\ . | [^\"\n] )*? \" )
			   | (?<char>		\' (?: \\ . | [^\'\n] )+? \' )
			   | (?<name>		[_a-z]\w* )
			   | (?<number>		0x [0-9a-f]+ |
								\d+ (?: \. \d+ )? (?: e [+-]? \d+ )? )
			   | (?<delimiter> 	[\(\)\[\]\{\}\,\;] )
			   | (?<operator>	\+\+ | \+\= | \+ |
								\-\- | \-\= | \- |
								       \*\= | \* | 
									   \/\= | \/ |
									   \%\= | \% |
								\<\<\= | \<\= | \<\< | \< |
								\>\>\= | \>\= | \>\> | \> | 
								\=\= | \!\= | \= | \! |
								\&\&\= | \&\= | \&\& | \& | 
								\|\|\= | \|\= | \|\| | \| | 
								\^\= | \^ |
								\~ |
								\. | \-\> |
								\: | \? )
			   | (?<error> .* )
			   /ixm;

#------------------------------------------------------------------------------
# Global parse tree
#------------------------------------------------------------------------------
my $VARS = {
	prog		=> basename($0),
	input		=> basename($0, ".pl"),
	args		=> [],
	init_module	=> [], 	# { type => 'init', func => 'init_1' },
	init_struct => 	[],	# { struct => 'Person', 
						#	methods => { 
						#		init => { 
						#			func => 'struct_Person_init',
						#			decl => 'Person *self, char *name, int age',
						#			call => 'self, name, age',
						#		}, 
						#		new => {
						#			decl => 'char *name, int age',
						#		fini => {
						#			func => 'struct_Person_fini',
						#		} 
						#	}
						# } 
};

#------------------------------------------------------------------------------
# main
#------------------------------------------------------------------------------
@ARGV or die "Usage: $VARS->{prog} files.h\n";

for my $file (@ARGV) {
	push $VARS->{args}, $file;
	parse($file);
}

#warn dump $VARS;

my $tt = Template->new(
	INCLUDE_PATH	=> dirname($0),
	OUTPUT_PATH 	=> ".",
	TRIM			=> 1,
	START_TAG		=> '{{',
	END_TAG			=> '}}',
);

for my $file ('c', 'h') {
	$tt->process($VARS->{input}.".$file", $VARS, "init.$file") or die $tt->error;
}

#------------------------------------------------------------------------------
# C lexer
#------------------------------------------------------------------------------
sub make_lexer {
	my($file) = @_;
	my $text = read_file($file);
	
	return sub {
		while (1) {
			for ($text) {
				return if /\G\z/gcx;
				/\G $tokens /gcx or die;
				die "Cannot parse '$file' at '$+{error}'\n" if defined $+{error};
				next if defined $+{space};
				
				for my $kw (qw( string char name number delimiter operator )) {
					return [$kw, $+{$kw}] if defined $+{$kw};
				}
				die;
			}
		}
	};
}

#------------------------------------------------------------------------------
# Parse header file, build $VARS
#------------------------------------------------------------------------------
sub parse {
	my($file) = @_;
	my $lex = Iterator::Simple::Lookahead->new( make_lexer($file) );

	my %init_struct;
	my($type, $func, $struct);
	while ($lex->peek) {
		if ( match($lex,	name		=> sub { $_[0] =~ /^(extern|static|typedef)$/ } ) ) {
			next;
		}
		elsif ( match($lex,	name		=> 'void',
							name		=> sub { ($func, $type) = ($_[0] =~ /^((init|fini)_\w+)$/) }, 
							delimiter	=> '(',
							name		=> 'void',
							delimiter	=> ')',
							delimiter	=> ';' ) ) {
			push @{$VARS->{init_module}}, { type => $type, func => $func };
		}
		elsif ( match($lex,	name		=> 'void',
							name		=> sub { ($func, $type) = ($_[0] =~ /^((init|fini)_\w+)$/) }, 
							delimiter	=> '(',
							delimiter	=> ')',
							delimiter	=> ';' ) ) {
			push @{$VARS->{init_module}}, { type => $type, func => $func };
		}
		elsif ( match($lex,	name		=> 'struct',
							name		=> sub { $struct = $_[0] }, 
							delimiter	=> '{' ) ) {
			if (! $init_struct{$struct} ) {
				$init_struct{$struct} = {};
				push @{$VARS->{init_struct}}, $init_struct{$struct};
			}
			$init_struct{$struct}{struct} = $struct;
			$init_struct{$struct}{methods}{new}{decl}  = "void";
			skip_block($lex);
			skip_statement($lex);
		}
		elsif ( match($lex,	name		=> 'void',
							name		=> sub { ($func, $struct, $type) = 
													($_[0] =~ /^(struct_(\w+)_(init|fini))$/) }, 
							delimiter	=> '(' ) ) {
			if ( ! match($lex, 
							name 		=> 'struct',
							name		=> $struct,
							operator	=> '*',
							name		=> sub {1} ) &&
			     ! match($lex, 
							name		=> $struct,
							operator	=> '*',
							name		=> sub {1} ) ) {
				skip_paren($lex);
				skip_statement($lex);
			}
			else {
				if ($type eq 'fini') {
					if (match($lex,	delimiter => ')', delimiter => ';')) {
						$init_struct{$struct}{methods}{fini}{func} = $func;
					}
					else {
						die "$func: extra arguments\n";
					}
				}
				else { # $type = 'init'
					if (match($lex,	delimiter => ')', delimiter => ';')) {
						$init_struct{$struct}{methods}{init}{func} = $func;
						$init_struct{$struct}{methods}{init}{decl} = "$struct *self";
						$init_struct{$struct}{methods}{init}{call} = "self";
					}
					else { # collect arguments
						if (! match($lex, delimiter => ',') ) {
							die "$func: comma expected\n";
						}
						my %args = get_arguments($struct, $lex);
						skip_statement($lex);

						$init_struct{$struct}{methods}{init}{func} = $func;
						$init_struct{$struct}{methods}{init}{decl} = $args{init}{decl};
						$init_struct{$struct}{methods}{init}{call} = $args{init}{call};
						$init_struct{$struct}{methods}{new}{decl}  = $args{new}{decl};
					}
				}
			}
		}
		else {
			skip_statement($lex);
		}
	}
}

sub match {
	my($lex, @find) = @_;
	
	my @found;
	my $tok;
	while (@find >= 2 && ($tok = $lex->next)) {
		push @found, $tok;
		last if ($tok->[0] ne $find[0]);
		
		if (ref($find[1])) {
			last if (! $find[1]->($tok->[1]));
		}
		else {
			last if ($tok->[1] ne $find[1]);
		}
		splice(@find, 0, 2);
	}
	
	if (@find) {
		# failed
		$lex->unget(@found);
		return;
	}
	else {
		# passed
		return @found;
	}
}
	
sub skip_statement {
	my($lex) = @_;
	
	while ($lex->peek) {
		if ( match($lex,	delimiter	=> ';' ) ) {
			return;
		}
		elsif ( match($lex,	delimiter	=> '{' ) ) {
			skip_block($lex);
		}
		else {
			$lex->next;
		}
	}
}

sub skip_block {
	my($lex) = @_;
	
	while ($lex->peek) {
		if ( match($lex,	delimiter	=> '}' ) ) {
			return;
		}
		elsif ( match($lex,	delimiter	=> '{' ) ) {
			skip_block($lex);
		}
		else {
			$lex->next;
		}
	}
}

sub skip_paren {
	my($lex) = @_;
	
	while ($lex->peek) {
		if ( match($lex,	delimiter	=> ')' ) ) {
			return;
		}
		elsif ( match($lex,	delimiter	=> '(' ) ) {
			skip_paren($lex);
		}
		else {
			$lex->next;
		}
	}
}

sub get_arguments {
	my($struct, $lex) = @_;

	my @init_decl = ("$struct * self", "");
	my @init_call = ("self", "");
	my @new_decl  = ("");

	while ($lex->peek) {
		if ($lex->peek->[0] eq 'delimiter' && $lex->peek->[1] eq ')') {
			last;
		}
		elsif ($lex->peek->[0] eq 'delimiter' && $lex->peek->[1] eq ',') {
			push @init_decl, "";
			push @init_call, "";
			push @new_decl,  "";
			$lex->next;
		}
		else {
			my $token = $lex->next->[1];
			$init_decl[-1] .= " ".$token;
			$init_call[-1]  = $token;		# grab last token in each argument
			$new_decl[-1]  .= " ".$token;
		}
	}
	$lex->next;	# get ')'

	my %args;
	$args{init}{decl} = join(", ", @init_decl);
	$args{init}{call} = join(", ", @init_call);
	$args{new}{decl}  = join(", ", @new_decl);
	
	return %args;
}

exit 0;

__END__
# $Log: make_init.pl,v $
# Revision 1.4  2013-09-18 23:03:39  pauloscustodio
# Separate parsing code from templates.
# Add object registry to auto-delete objects on exit.
#
# Revision 1.3  2013/09/08 00:39:28  pauloscustodio
# '\n' was being output as '\\n'
#
# Revision 1.2  2013/09/01 11:59:05  pauloscustodio
# Force memalloc to be the first include, to be able to use MSVC memory debug tools
#
# Revision 1.1  2013/09/01 00:08:55  pauloscustodio
# - Included GLIB in the Makefile options.
# - Created a code-generation mechanism for automatic execution of initialize
#   code before the main() function starts, and methods for struct malloc
#   and free calling constructors and destructors.
#
