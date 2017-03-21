#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#
# Preprocessor that translates z80asm source code for CP/M's Z80MR, generates .i file with
# standard Z80 asm code and calls z80asm. Any error message is mapped back to the original
# source file line.
# 
# Added features:
# - Assembly MACROs with named parameters and optional local symbols: MACRO .. LOCAL xx .. ENDM
# - DEFL to redefine a symbol, maybe using the previous value
# - EQU to define a symbol, translated to DEFC
# - Label fields start on column 1 and don't need dot-prefix or colon-suffix
# - END ends the assembly
# - DW as synonym to DEFW
# - DDB to back word in big-endian form
# - DB, DEFM, DATA as synonym to DEFB
# - DS as synonym to DEFS
# - *INCLUDE to include files
# - new expression operators: .AND. .OR. .XOR. .NOT. .SHR. .SHL. .HIGH. .LOW. .EQU. .GT. .LT.
# - $ as synonym to ASMPC
# - optional upper case all source before assembly

use strict;
use warnings;
use Capture::Tiny 'capture';
use File::Basename;
use IO::File;
use File::Spec;
use Iterator::Simple qw( iter ienumerate iflatten imap igrep );
use Iterator::Simple::Lookahead;
use Regexp::Common;
use FindBin;
use Data::Dump 'dump';

#------------------------------------------------------------------------------
# Globals
#------------------------------------------------------------------------------
our @OPTIONS;		# list of options to pass to z80asm
our %DEFINE;		# list of -D defines from command line, or DEFL vars
our %MACRO;			# macros { args, local, lines }
our %DEFL;			# variable-value macros
our $DEFL_RE;		# match any DEFL name
our $UCASE;			# if TRUE all text is capitalized on reading from file

our $NAME_RE = 
	qr/ [_a-z]  \w* /ix;
our $MACRO_PARAM_RE =
	qr/ [_a-z#] \w* /ix;
our $LABEL_RE = 
	qr/ (?| ^ 		     (?<label> $NAME_RE) (?: \s+ | \s* : \s* )
		  | ^ \s* \. \s* (?<label> $NAME_RE) \s+
		  | ^ \s*        (?<label> $NAME_RE) \s* : \s*
		  ) /ix;
our $OPT_LABEL_RE =
	qr/ ^ (?<label_field> $LABEL_RE | \s+ ) /ix;
our $QSTR_RE = 
	qr/ (?| ' (?<str> [^']* ) ' 
		  | " (?<str> [^"]* ) " 
		  ) /ix;
our $QFILE_RE = 
	qr/ (?| ' ( [^']+ ) ' 
		  | " ( [^"]+ ) " 
		  | < ( [^>]+ ) >
		  |   ( \S+   )
		  ) /ix;

our $EXPR_RE =
	qr/	\s* (?&EXPR) 
	
		(?(DEFINE)
			(?<TERM>	\s*
						(?> \d+ 
						|   \w+ 
						|   \( \s* (?&EXPR) \s* \) 
						) 
			)
			(?<UN_OP>	\s*
						[\-\+\!\~] )
			(?<BIN_OP>	\s*
						(?: << | >> 
						  | >= | <= | == | <> | != 
						  | \&\& | \|\| 
						  | \*\*
						  |	[\-\+\*\/\%\&\|\^] 
						) 
			)
			(?<FACTOR>	\s* (?&UN_OP)* 
						\s* (?&TERM) 
			)
			(?<EXPR>	\s*	(?&FACTOR) 
						(?> \s* (?&BIN_OP) 
							\s* (?&FACTOR) 
						)* 
			)
		)
	  /ix;

#------------------------------------------------------------------------------
# Handle include path
#------------------------------------------------------------------------------
sub add_path {
	my(@dirs) = @_;
	our @INC_PATH;
	
	push @INC_PATH, @dirs;
}

sub search_path {
	my($file) = @_;
	our @INC_PATH;
	
	return $file if -f $file;	# found
	for my $dir (@INC_PATH) {
		my $path = File::Spec->catfile($dir, $file);
		return $path if -f $path;
	}
	
	die "File $file not found in path (@INC_PATH)\n";
}										

#------------------------------------------------------------------------------
# Handle defines
#------------------------------------------------------------------------------
sub add_define {
	my($name, $value) = @_;
	$DEFINE{$name} = $value || 1;
}

#------------------------------------------------------------------------------
# errors
#------------------------------------------------------------------------------
sub error {
	my($line, $message) = @_;
	die "Error at file ", $line->{file}, " line ", $line->{line_nr},
		": ", $message, "\n";
}		

#------------------------------------------------------------------------------
# autolabel
#------------------------------------------------------------------------------
sub autolabel {
	my($template) = @_;
	our $LABEL_NUM;
	$LABEL_NUM++;
	$template =~ s/\W//g;
	return "AUTOLABEL_".$template."_".$LABEL_NUM;
}

#------------------------------------------------------------------------------
# expressions
#------------------------------------------------------------------------------
sub eval_expr {
	my($expr) = @_;

	# try to eval as arithmetic expression
	use integer;
	my $new_value = eval("0+($expr)");
	if (! $@) {		# ok
		return $new_value;
	}
	else {
		return $expr;
	}
}

sub high_expr {
	my($arg) = @_;
	return eval_expr("((($arg) >> 8) & 255)");
}

sub low_expr {
	my($arg) = @_;
	return eval_expr("(($arg) & 255)");
}

#------------------------------------------------------------------------------
# macro utilities
#------------------------------------------------------------------------------
sub extract_macro_params {
	my($text, $line) = @_;
	my @params = split(/,/, $text);
	for (@params) {
		s/^\s+//; 
		s/\s+$//; 
		/^ $MACRO_PARAM_RE $/ix
			or error($line, "invalid macro parameter: $_");
	}
	return @params;
}

sub parse_macro_args {
	my($args) = @_;
	$args =~ s/^\s+//; 
	$args =~ s/\s+$//;
	return () if $args eq '';
	
	my @values = ('');
	while (! ($args =~ /\G $ /gcx)) {
		if ( $args =~ /\G ( $QSTR_RE ) /gcx) {
			$values[-1] .= $1;
		}
		elsif ( $args =~ /\G \s* , \s* /gcx) {
			push @values, '';
		}
		elsif ( $args =~ /\G ( . ) /gcxs) {
			$values[-1] .= $1;
		}
		else { 
			die; 
		}
	}
	
	# unquote quoted macro arguments
	for (@values) {
		if (/^ $QSTR_RE $/ix) {
			$_ = $+{str};
		}
	}
	
	return @values;
}

sub expand_macro {
	my($call_line, $label, $name, $args) = @_;
	my @ret;
	
	my $macro = $MACRO{uc($name)} or die;
	my %line = %$call_line;
	
	# copy label
	if ($label) {
		$line{text} = "$label:";
		push @ret, {%line};
	}
	
	# expand macro
	my @values = parse_macro_args($args);
	my $text = join("\n", @{$macro->{lines}});

	for my $local (@{$macro->{local}}) {
		my $autolabel = autolabel($local);
		$text =~ s/$local/$autolabel/ig;
	}
	
	for my $arg (@{$macro->{args}}) {
		my $value = shift(@values) // '';
		$text =~ s/$arg/$value/ig;
	}
	
	error($call_line, "extra macro arguments") if @values;
	
	for (split(/\n/, $text)) {
		$line{text} = $_;
		push @ret, {%line};
	}

	return iter(\@ret);
}

#------------------------------------------------------------------------------
# DEFL utilities
#------------------------------------------------------------------------------
sub define_defl {
	my($name, $expr) = @_;
	$expr =~ s/^\s+//;
	$expr =~ s/\s+$//;
	
	my $old_value = $DEFL{uc($name)} || 0;
	
	# use old value
	$expr =~ s/ \b $name \b /($old_value)/gix;
	
	# try to eval as arithmetic expression
	$expr = eval_expr($expr);
	
	# store
	$DEFL{uc($name)} = $expr;
	my $re = join("|", keys %DEFL);
	$DEFL_RE = qr/ \b ( $re ) \b /ix;
}

#------------------------------------------------------------------------------
# read parsed lines - stack of iterators
#------------------------------------------------------------------------------
sub read_lines_it {
	my($file) = @_;
	return 
		remove_blank_lines(
		parse_directives_it(
		expand_defl_it(
		define_asmpc_it(
		convert_expr_it(
		expand_macros_it(
		parse_macros_it(
		remove_comments_it(
		convert_ucase_it(
		parse_include_it( 
		add_label_suffix(
		read_file_it($file))))))))))));
}

# read lines from file { text, file, line_nr }, text is chompped
sub read_file_it {
	my($file) = @_;
	my $path = search_path($file);
	return 
		imap { {text => $_->[1], file => $path, line_nr => 1+$_->[0]} }
	    ienumerate 
		imap { s/\s+$//; $_ }
		iter( IO::File->new($path) );
}

# add ':' after label names
sub add_label_suffix {
	my($in) = @_;
	return 
		imap {
			for ($_->{text}) {
				s/^(\w+)\s+(\w+)/$1: $2/;
				s/^(\w+)\s*$/$1:/;
			}
			$_;
		}
		$in;
}

# parse INCLUDE
sub parse_include_it {
	my($in) = @_;
	return 
		iflatten 
		sub {
			defined(my $line = <$in>) or return;
			if ( $line->{text} =~ 
				/^ [\#\*]? \s* INCLUDE \s+ $QFILE_RE /ix ) {
				return read_file_it($1);
			}
			return $line;
		};
}

# remove comments
sub remove_comments_it {
	my($in) = @_;
	return 
		imap {
			for ($_->{text}) {
				s/^\s*;.*//;
				s/^\s*\#.*//;
				s/ (?:  (?<af1>		af\'		)
				   |	(?<qstr>	$QSTR_RE	)
				   |	(?<comment>	\s* ; .*	)
				   |    (?<any>		.	    	)
				   )
				 / defined($+{af1}) 			? $+{af1} 
				 : defined($+{qstr}) 			? $+{qstr} 
				 : defined($+{any})				? $+{any} 
				 : ""
				 /egsxi;
				s/\s+$//;
			}
			$_;
		}
		$in;
}

# parse macro .. endm
sub parse_macros_it { 
	my($in) = @_;
	return iter sub {
		while (1) {
			defined(my $line = <$in>) or return;
			if ($line->{text} =~ 
				/^ $LABEL_RE \b MACRO \b (?<args> .*)/ix) {
				# get NAME and ARGS
				my $name = $+{label}; 
				my @args = extract_macro_params($+{args}, $line);
				
				# search for LOCAL and ENDM, collect lines
				my @lines;
				my @local;
				while (1) {
					defined(my $macro_line = <$in>)
						or error($line, "missing ENDM");
						
					last if $macro_line->{text} =~ /^ \s+ ENDM \b /ix;
					
					if ($macro_line->{text} =~ 
						/^ \s+ LOCAL \b (?<args> .*)/ix) {
						push @local, extract_macro_params($+{args}, $macro_line);
					}
					else {
						push @lines, $macro_line->{text};
					}
				}
				
				# save macro
				$MACRO{uc($name)} and error($line, "macro multiply defined");
				$MACRO{uc($name)} = { 
					args 	=> \@args, 
					local 	=> \@local,
					lines	=> \@lines,
				};
			}
			else {
				return $line;
			}
		}
	}
}

# expand macros
sub expand_macros_it {
	my($in) = @_;
	return 
		iflatten
		imap { 
			if ( $_->{text} =~ 
				 /^ $OPT_LABEL_RE \b
				    (?<name> $NAME_RE) \b 
				    (?<args> .*) $/ix &&
			     defined( $MACRO{ uc( $+{name} ) } ) ) {
				return expand_macro($_, $+{label}, $+{name}, $+{args});
			}
			else {
				return $_;
			}
		}
		$in;
}

# convert expression to z80asm format:
# - convert strings to lists of character codes
# - numbers to decimal
# - Z80MR operators to C-standard operators
# - $ to ASMPC
sub convert_expr_it {
	my($in) = @_;
	return imap {
		for ($_->{text}) {
			s{ [\%\@] ( [\'\"] ) (?<str> [\-\#]+ ) \g{-2} 
			 }{ oct('0b'.join('', 
							  map {$_ eq '#' ? '1' : '0'}
							  split(//, $+{str} ) ) )
			  }egxi;
			s{ $QSTR_RE }{ join(",", map {ord} split(//, $+{str})) }egxi;
			s/ (?| \b   ( \d [0-9A-F]* ) h \b 
				 | \$   (    [0-9A-F]+ ) \b
				 | \#   (    [0-9A-F]+ ) \b
				 | \&h  (    [0-9A-F]+ ) \b
				 | 0x   (    [0-9A-F]+ ) \b
				 ) / hex($1) /egxi;
			s/ (?| \b   (    [01]+ ) b \b 
				 | \%   (    [01]+ ) \b 
				 | \@   (    [01]+ ) \b 
				 | \&b  (    [01]+ ) \b
				 | 0b   (    [01]+ ) \b
				 ) / oct("0b".$1) /egxi;
			s/ \$ / ASMPC /gxi;
			s/ \. AND \. / & /gxi;
			s/ \. OR  \. / | /gxi;
			s/ \. XOR \. / ^ /gxi;
			s/ \. NOT \. / ! /gxi;
			s/ \. SHR \. / >> /gxi;
			s/ \. SHL \. / << /gxi;
			s/ \. EQU \. / == /gxi;
			s/ \. GT  \. / > /gxi;
			s/ \. LT  \. / < /gxi;
			
			s/ \. HIGH \. \s* ( $EXPR_RE ) / '('.high_expr($1).')' /egxi;
			s/ \. LOW  \. \s* ( $EXPR_RE ) / '('.low_expr($1).')'  /egxi;
		}
		$_;
	} $in;
}

# replace $ and ASMPC by newly generated autolabel
sub define_asmpc_it {
	my($in) = @_;
	return 
		iflatten
		imap {
			if ($_->{text} =~ / \$ | \b ASMPC \b /ix) {
				my @ret;
				my $label = autolabel("pc");
				$_->{text} =~ s/ \$ | \b ASMPC \b / $label /gix;
				
				my %line = %$_;
				$line{text} = "$label:";
				push @ret, { %$_, text => "$label:" };
				push @ret, { %$_ };
				return iter(\@ret);
			}
			else {
				return $_;
			}
		}
		$in;
}
				
# expand LABEL DEFL VALUE replacing all occurences of LABEL by VALUE
# Note: hides z80asm's DEFL for define long
sub expand_defl_it {
	my($in) = @_; 
	return 
		imap {
			if ($_->{text} =~ 
				/^ $LABEL_RE \b DEFL \b \s* (?<expr> .*)/ix) {
				define_defl( $+{label}, $+{expr} );
				$_->{text} = "";
			}
			elsif (%DEFL) {
				$_->{text} =~ s/ \b ( $DEFL_RE ) \b /$DEFL{uc($1)}/gix;
			}
			$_;
		}
		$in;
}

# parse assembly directives, replace with z80asm version
sub parse_directives_it {
	my($in) = @_;
	return iter sub {
		while (1) {
			defined(my $line = <$in>) or return;
			
			if ($line->{text} =~
				/^ $OPT_LABEL_RE \b END \b/ix) {
				# END: ignore rest of input
				1 while (defined($line = <$in>));
			}
			elsif ($line->{text} =~
				/^ $OPT_LABEL_RE \b DDB \b \s* (?<args> .*)/ix) {
				# DDB: words with MSB first
				my $label_field = $+{label_field};
				my @args = split(/\s*,\s*/, $+{args});
				my @bytes;
				for (@args) {
					push @bytes, high_expr($_), low_expr($_);
				}
				$line->{text} = $label_field."DEFB ".join(",", @bytes);
			}
			else {
				for ($line->{text}) {
					s/^ ( $OPT_LABEL_RE ) DW \b /${1}DEFW/ix;
					s/^ ( $OPT_LABEL_RE ) ( DB | DEFM | DATA ) \b /${1}DEFB/ix;
					s/^ ( $OPT_LABEL_RE ) DS \b /${1}DEFS/ix;
					s/^ $LABEL_RE \b EQU \b \s* (?<args> .*) /
						"\tDEFC ".$+{label}." = ".eval_expr($+{args}) /eix;
				}
			}

			return $line;
		}
	};
}
		
# capitalize code if --ucase
sub convert_ucase_it {
	my($in) = @_;
	if ($UCASE) {
		return imap { $_->{text} = uc($_->{text}); $_ } $in;
	}
	else {
		return $in;
	}
}

# remove blank lines
sub remove_blank_lines {
	my($in) = @_;
	return 
		igrep { $_->{text} =~ /\S/ }
		$in;
}

#------------------------------------------------------------------------------
# assemble the source file
#------------------------------------------------------------------------------
sub assemble_file {
	my($src_file) = @_;
	my $it = read_lines_it($src_file);
	
	# build .i file and line map for error messages
	my $i_file = $src_file;	$i_file =~ s/\.\w+$/.i/;
	
	my @line_map;
	my $line_nr;
	open(my $fh, ">", $i_file) or die "write $i_file: $!";
	my $last_line = "";
	while (defined(my $in = <$it>)) {
		my $this_line = ";;".$in->{file}.":".$in->{line_nr}."\n";
		if ($this_line ne $last_line) {
			$line_nr++;
			print $fh $this_line;
			$last_line = $this_line;
		}
		
		$line_nr++;
		print $fh $in->{text}, "\n";
		$line_map[$line_nr] = $in;
	}
	close $fh;
	
	# assemble, translate error messages
	my @cmd = ('z80asm', @OPTIONS, $i_file);
	print "@cmd\n";
	$cmd[0] = $FindBin::Bin.'/z80asm';
	my ($stdout, $stderr, $exit) = capture {
		system @cmd;
	};
	
	$stderr =~ s/(at file ')([^']+)(' line )(\d+)/
				 $1 . $line_map[$4]{file} . $3 . $line_map[$4]{line_nr} /ge;
	print $stdout;
	print STDERR $stderr;
	
	exit 1 if $exit != 0;
}

#------------------------------------------------------------------------------
while (@ARGV && $ARGV[0] =~ /^-/) {
	local $_ = shift;
	if    (/^-I(.*)/ ) {					add_path($1); }
	elsif (/^-D($NAME_RE)(?:=(.*))?/ ) {	define_defl(uc($1), $2 || 1); }
	elsif (/^--ucase$/ ) {					$UCASE = 1; }
	else {									push @OPTIONS, $_; }
}

@ARGV or die "Usage: ", basename($0), " [-Ipath][-Dvar[=value]] FILE...\n";
assemble_file($_) for @ARGV;
exit 0;
