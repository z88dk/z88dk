#!/usr/bin/env perl

#-------------------------------------------------------------------------------
# Create a parser from the given descritption and template
#-------------------------------------------------------------------------------

use Modern::Perl;
use Array::Compare;
use Path::Tiny;
use File::Copy;
use Data::Dump 'dump';

#-------------------------------------------------------------------------------
# data
#-------------------------------------------------------------------------------

my %tokens = (
	END => "",
	IDENT => "",
	INT => "",
	FLOAT => "",
	EXPR => "",
	CONST_EXPR => "",
	STR => "",
	RAW_STR => "",
    OPERATOR => "",
	NEWLINE => "\n",
	
	ASMPC => '$',
	BACKSLASH => "\\",
	COLON => ":",
	COMMA => ",",
	DHASH => "##",
	DOT => ".",
	HASH => "#",
	LBRACE => "{",
	LPAREN => "(",
	LSQUARE => "[",
	QUEST => "?",
	RBRACE => "}",
	RPAREN => ")",
	RSQUARE => "]",
);

# Precedence levels based on standard C precedence
my %operators = (
    NONE        => { text => "",    precedence => 0,    associativity => 'Left',    arity => 'Unary' },

    # Power
    POWER       => { text => "**",  precedence => 14,   associativity => 'Right',   arity => 'Binary' },

    # Unary (prefix): + - ! ~
    UPLUS       => { text => "+",   precedence => 13,   associativity => 'Right',   arity => 'Unary' },
    UMINUS      => { text => "-",   precedence => 13,   associativity => 'Right',   arity => 'Unary' },
	LOG_NOT     => { text => "!",   precedence => 13,   associativity => 'Right',   arity => 'Unary' },
	BIN_NOT     => { text => "~",   precedence => 13,   associativity => 'Right',   arity => 'Unary' },

    # Multiplicative
    MULT        => { text => "*",   precedence => 12,   associativity => 'Left',    arity => 'Binary' },
    DIV         => { text => "/",   precedence => 12,   associativity => 'Left',    arity => 'Binary' },
    MOD         => { text => "%",   precedence => 12,   associativity => 'Left',    arity => 'Binary' },

    # Additive
    PLUS        => { text => "+",   precedence => 11,   associativity => 'Left',    arity => 'Binary' },
    MINUS       => { text => "-",   precedence => 11,   associativity => 'Left',    arity => 'Binary' },

    # Shift
	LSHIFT      => { text => "<<",  precedence => 10,   associativity => 'Left',    arity => 'Binary' },
	RSHIFT      => { text => ">>",  precedence => 10,   associativity => 'Left',    arity => 'Binary' },

    # Relational
    LT          => { text => "<",   precedence => 9,    associativity => 'Left',    arity => 'Binary' },
    LE          => { text => "<=",  precedence => 9,    associativity => 'Left',    arity => 'Binary' },
    GT          => { text => ">",   precedence => 9,    associativity => 'Left',    arity => 'Binary' },
    GE          => { text => ">=",  precedence => 9,    associativity => 'Left',    arity => 'Binary' },

    # Equality
    EQ          => { text => "=",   precedence => 8,    associativity => 'Left',    arity => 'Binary' },
    NE          => { text => "<>",  precedence => 8,    associativity => 'Left',    arity => 'Binary' },

    # Bitwise AND, XOR, OR
	BIN_AND     => { text => "&",   precedence => 7,    associativity => 'Left',    arity => 'Binary' },
	BIN_XOR     => { text => "^",   precedence => 6,    associativity => 'Left',    arity => 'Binary' },
	BIN_OR      => { text => "|",   precedence => 5,    associativity => 'Left',    arity => 'Binary' },

    # Logical AND, XOR, OR
	LOG_AND     => { text => "&&",  precedence => 4,    associativity => 'Left',    arity => 'Binary' },
	LOG_XOR     => { text => "^^",  precedence => 3,    associativity => 'Left',    arity => 'Binary' },
	LOG_OR      => { text => "||",  precedence => 2,    associativity => 'Left',    arity => 'Binary' },

    # Ternary
    TERNARY     => { text => "?:",  precedence => 1,    associativity => 'Right',   arity => 'Ternary' },
);

my %keywords = (
	NONE => "",
	AIX => "aix",
	AIY => "aiy",
	ASMPC => "asmpc",
	ASSUME => "assume",
	BINARY => "binary",
	C_LINE => "c_line",
	DEFB => "defb",
	DEFC => "defc",
	DEFINE => "define",
	DEFP => "defp",
	DEFQ => "defq",
	DEFW => "defw",
	EQU => "equ",
	EXTERN => "extern",
	INCBIN => "incbin",
	INCLUDE => "include",
	IX => "ix",
	IXH => "ixh",
	IXL => "ixl",
	IY => "iy",
	IYH => "iyh",
	IYL => "iyl",
	LINE => "line",
	XIX => "xix",
	YIY => "yiy",
);

# code is stored in obj-file, str is output by z80nm
my %range = (
    UNDEFINED				=> { id => 0,  size => -1,code => "?", str => "?" },
    JR_OFFSET  				=> { id => 1,  size => 1, code => "J", str => "J" },	# 8-bit relative offset for JR
    BYTE_UNSIGNED   		=> { id => 2,  size => 1, code => "U", str => "U" },	# unsigned byte
    BYTE_SIGNED				=> { id => 3,  size => 1, code => "S", str => "S" },	# signed byte
    WORD      				=> { id => 4,  size => 2, code => "C", str => "W" },	# 16-bit value little-endian
    WORD_BE   				=> { id => 5,  size => 2, code => "B", str => "B" },	# 16-bit value big-endian
    DWORD    				=> { id => 6,  size => 4, code => "L", str => "L" },	# 32-bit signed
    BYTE_TO_WORD_UNSIGNED	=> { id => 7,  size => 2, code => "u", str => "u" },	# unsigned byte extended to 16 bits
    BYTE_TO_WORD_SIGNED		=> { id => 8,  size => 2, code => "s", str => "s" },	# signed byte sign-extended to 16 bits
    PTR24     				=> { id => 9,  size => 3, code => "P", str => "P" },	# 24-bit pointer
    HIGH_OFFSET				=> { id => 10, size => 1, code => "H", str => "H" },	# byte offset to 0xFF00
    ASSIGNMENT 				=> { id => 11, size => 0, code => "=", str => "=" },	# DEFC expression assigning a symbol
    JRE_OFFSET 				=> { id => 12, size => 2, code => "j", str => "j" },	# 16-bit relative offset for JRE
    BYTE_TO_PTR_UNSIGNED	=> { id => 13, size => 3, code => "v", str => "v" },	# unsigned byte extended to 24 bits
    BYTE_TO_PTR_SIGNED		=> { id => 14, size => 3, code => "t", str => "t" },	# signed byte sign-extended to 24 bits
);

my %cpus = (
    UNDEF       	=> { id => -1, name => "", 					parent => "",		defines => "" },
    Z80         	=> { id => 1,  name => "z80", 				parent => "8080",	defines => "__CPU_Z80__ 			__CPU_ZILOG__" 	},
    Z80_STRICT  	=> { id => 2,  name => "z80_strict", 		parent => "8080",	defines => "__CPU_Z80_STRICT__ 		__CPU_ZILOG__" 	},
    Z180        	=> { id => 3,  name => "z180", 				parent => "8080",	defines => "__CPU_Z180__			__CPU_ZILOG__"	},
    EZ80_Z80    	=> { id => 4,  name => "ez80_z80", 			parent => "UNDEF",	defines => "__CPU_EZ80_Z80__		__CPU_ZILOG__" 	},
    EZ80        	=> { id => 5,  name => "ez80", 				parent => "UNDEF",	defines => "__CPU_EZ80__			__CPU_ZILOG__" 	},
    Z80N        	=> { id => 6,  name => "z80n", 				parent => "Z80",	defines => "__CPU_Z80N__			__CPU_ZILOG__" 	},
    R2KA        	=> { id => 7,  name => "r2ka", 				parent => "UNDEF",	defines => "__CPU_R2KA__			__CPU_RABBIT__" },
    R3K         	=> { id => 8,  name => "r3k", 				parent => "R2KA",	defines => "__CPU_R3K__				__CPU_RABBIT__" },
    GBZ80       	=> { id => 9,  name => "gbz80", 			parent => "UNDEF",	defines => "__CPU_GBZ80__" 							},
    '8080'        	=> { id => 10, name => "8080", 				parent => "UNDEF",	defines => "__CPU_8080__			__CPU_INTEL__" 	},
    '8085'        	=> { id => 11, name => "8085", 				parent => "8080",	defines => "__CPU_8085__			__CPU_INTEL__" 	},
    R800        	=> { id => 12, name => "r800", 				parent => "8080",	defines => "__CPU_R800__" 							},
    R4K         	=> { id => 13, name => "r4k", 				parent => "UNDEF",	defines => "__CPU_R4K__				__CPU_RABBIT__" },
    R5K         	=> { id => 14, name => "r5k", 				parent => "R4K",	defines => "__CPU_R5K__				__CPU_RABBIT__" },
    KC160       	=> { id => 15, name => "kc160", 			parent => "UNDEF",	defines => "__CPU_KC160__" 							},
    KC160_Z80   	=> { id => 16, name => "kc160_z80", 		parent => "8080",	defines => "__CPU_KC160_Z80__" 						},
    '8080_STRICT'	=> { id => 17, name => "8080_strict", 		parent => "UNDEF",	defines => "__CPU_8080_STRICT__		__CPU_INTEL__" 	},
    '8085_STRICT'	=> { id => 18, name => "8085_strict", 		parent => "8080",	defines => "__CPU_8085_STRICT__		__CPU_INTEL__" 	},
    GBZ80_STRICT	=> { id => 19, name => "gbz80_strict", 		parent => "UNDEF",	defines => "__CPU_GBZ80_STRICT__" 					},
	Z180_STRICT		=> { id => 20, name => "z180_strict", 		parent => "8080",	defines => "__CPU_Z180_STRICT__		__CPU_ZILOG__" 	},
    Z80N_STRICT		=> { id => 21, name => "z80n_strict", 		parent => "Z80",	defines => "__CPU_Z80N_STRICT__		__CPU_ZILOG__" 	},
    EZ80_Z80_STRICT => { id => 22, name => "ez80_z80_strict", 	parent => "UNDEF",	defines => "__CPU_EZ80_Z80_STRICT__	__CPU_ZILOG__" 	},
    EZ80_STRICT     => { id => 23, name => "ez80_strict", 		parent => "UNDEF",	defines => "__CPU_EZ80_STRICT__		__CPU_ZILOG__" 	},
    R800_STRICT    	=> { id => 24, name => "r800_strict", 		parent => "8080",	defines => "__CPU_R800_STRICT__" 					},
    KC160_STRICT    => { id => 25, name => "kc160_strict", 		parent => "UNDEF",	defines => "__CPU_KC160_STRICT__" 					},
    KC160_Z80_STRICT=> { id => 26, name => "kc160_z80_strict", 	parent => "8080",	defines => "__CPU_KC160_Z80_STRICT__" 				},
    R2KA_STRICT     => { id => 27, name => "r2ka_strict", 		parent => "UNDEF",	defines => "__CPU_R2KA_STRICT__		__CPU_RABBIT__" },
    R3K_STRICT      => { id => 28, name => "r3k_strict", 		parent => "R2KA",	defines => "__CPU_R3K_STRICT__		__CPU_RABBIT__" },
    R4K_STRICT      => { id => 29, name => "r4k_strict", 		parent => "UNDEF",	defines => "__CPU_R4K_STRICT__		__CPU_RABBIT__" },
    R5K_STRICT		=> { id => 30, name => "r5k_strict", 		parent => "R4K",	defines => "__CPU_R5K_STRICT__		__CPU_RABBIT__" },
	R6K				=> { id => 31, name => "r6k", 				parent => "R5K",	defines => "__CPU_R6K__				__CPU_RABBIT__" },
	R6K_STRICT		=> { id => 32, name => "r6k_strict", 		parent => "R5K",	defines => "__CPU_R6K_STRICT__		__CPU_RABBIT__" },
);

my %scope = (
	NONE 	=> { id => 0, },
	LOCAL 	=> { id => 1, },	# "L"
	PUBLIC 	=> { id => 2, },	# "G" - defined and exported
	EXTERN 	=> { id => 3, },	#	   - not defined and imported
	GLOBAL 	=> { id => 4, },	# "G" - PUBLIC if defined, EXTERN if not
);

my %type = (
    UNDEFINED  => { id => 0, },	#     - symbol not defined
    CONSTANT   => { id => 1, },	# "C" - can be computed
    ADDRESS    => { id => 2, },	# "A" - depends on ASMPC, can be computed after address allocation
    COMPUTED   => { id => 3, },	# "=" - depends on the result of an expression
);

my %config = (
	OBJ_FILE_VERSION	=> 18,
	OBJ_FILE_SIGNATURE	=> c_string("Z80RMF"),
	LIB_FILE_SIGNATURE	=> c_string("Z80LMF"),
	SIGNATURE_SIZE		=> 8,
);

my %swap_ixiy = (
    NO_SWAP		=> { id => 0, text => "" 			},	# no swap
    SWAP		=> { id => 1, text => "-IXIY" 		},	# swap IX and IY
    SOFT_SWAP	=> { id => 2, text => "-IXIY-soft" 	},	# swap IX and IY, but save object file with no swap
);

#-------------------------------------------------------------------------------
# main
#-------------------------------------------------------------------------------
@ARGV>2 or die "Usage: ",path($0)->basename," grammar.y files.cpp...\n";
my($grammar_file, @source_files) = @ARGV;

my $grammar;

parse_grammar($grammar_file);
make_state_machine();
for my $file (@source_files) {
	patch_file($file);
}

#dump $grammar;

#-------------------------------------------------------------------------------
# parse the grammar file
#-------------------------------------------------------------------------------
sub parse_grammar {
	my($filename) = @_;
	open(my $fh, "<", $filename) or die "open file $filename: $!\n";
	
	my @rules;
	my @actions;
	my $rule_nr = -1;
	while (<$fh>) {
		if (/^\s*\/\//) {
			next;
		}
		elsif (/^\S/) {
			$rule_nr++;
			my @tokens = parse_grammar_rule($_);
			$rules[$rule_nr] = \@tokens;
			$actions[$rule_nr] = "";
		}
		else {
			if ($rule_nr < 0) {
				die "action code before rules: $_" if /\S/;
			}
			else {
				$actions[$rule_nr] .= $_;
			}
		}
	}
	
	$grammar = { tokens => \%tokens,
                 keywords => \%keywords,
                 operators => \%operators,
                 range => \%range, 
				 rules => \@rules,
                 actions => \@actions,
				 cpus => \%cpus,
				 scope => \%scope,
				 type => \%type,
				 config => \%config, 
				 swap_ixiy => \%swap_ixiy,
			};
}

sub parse_grammar_rule {
	my($text) = @_;
	my %reverse_tokens;
	while (my($key, $value) = each %tokens) {
		if ($value ne "") {
			$reverse_tokens{$value} = $key;
		}
	}
	
	my @tokens;
	for (split(' ', $text)) {
		if (exists $tokens{$_}) {
			push @tokens, $_;
		}
		elsif (/"(.+)"/ && exists $reverse_tokens{$1}) {
			push @tokens, $reverse_tokens{$1};
		}
		elsif (/"(.+)"/) {
			push @tokens, uc($1);
			$keywords{uc($1)} = lc($1);
		}
		else {
			die "Undefined token: $_\n";
		}
	}
	
	return @tokens;
}

#-------------------------------------------------------------------------------
# patch the file with grammar
#-------------------------------------------------------------------------------
sub patch_file {
	my($file) = @_;
	my @in = path($file)->lines;
	my @in0 = @in;
	my @out;
	
	while (@in) {
		$_ = shift(@in);
		s/(\/\*\@\@CONFIG:\s*(\w+)\s*\*\/).*(\/\*\@\@END\s*\*\/)/$1 $grammar->{config}{$2} $3/;
		if (/^(\s*)\/\/\@\@BEGIN:\s*ttype\b/) {
			my $prefix = $1;
			push @out, $_;
			push @out, "${prefix}END,\n";		# END must be id 0
			for (sort keys %{$grammar->{tokens}}) {
				next if $_ eq 'END';
				push @out, "$prefix$_,\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*ttype_text\b/) {
			my $prefix = $1;
			push @out, $_;
			for my $kw (sort keys %{$grammar->{tokens}}) {
				my $string = $grammar->{tokens}{$kw};
				push @out, "${prefix}{ TType::$kw, ".c_string($string)." },\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*operator\b/) {
			my $prefix = $1;
			push @out, $_;
			push @out, "${prefix}NONE,\n";	# OP_NONE must be id 0
			for (sort keys %{$grammar->{operators}}) {
				next if $_ eq 'NONE';
				push @out, "$prefix$_,\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*operator_text\b/) {
			my $prefix = $1;
			push @out, $_;
			for my $kw (sort keys %{$grammar->{operators}}) {
				my $info = $grammar->{operators}{$kw};
				push @out, "${prefix}{ Operator::$kw, ".c_string($info->{text})." },\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*operator_info\b/) {
			my $prefix = $1;
			push @out, $_;
			for my $kw (sort keys %{$grammar->{operators}}) {
				my $info = $grammar->{operators}{$kw};
				push @out, "${prefix}{ Operator::$kw, { ".$info->{precedence}.", ".
                            "Associativity::".$info->{associativity}.", ".
                            "Arity::".$info->{arity}." } },\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*keyword\b/) {
			my $prefix = $1;
			push @out, $_;
			push @out, "${prefix}NONE,\n";		# NONE must be id 0
			for (sort keys %{$grammar->{keywords}}) {
				next if $_ eq 'NONE';
				push @out, "$prefix$_,\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*keyword_text\b/) {
			my $prefix = $1;
			push @out, $_;
			for my $kw (sort keys %{$grammar->{keywords}}) {
				my $string = $grammar->{keywords}{$kw};
				push @out, "${prefix}{ Keyword::$kw, ".c_string($string)." },\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*keyword_lookup\b/) {
			my $prefix = $1;
			push @out, $_;
			for my $kw (sort keys %{$grammar->{keywords}}) {
				my $string = $grammar->{keywords}{$kw};
				push @out, "${prefix}{ ".c_string($string).", Keyword::$kw },\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*range_t\b/) {
			my $prefix = $1;
			push @out, $_;
			for (sort {$grammar->{range}{$a}{id} <=> $grammar->{range}{$b}{id}} keys %{$grammar->{range}}) {
				push @out, $prefix."RANGE_$_ = ".$grammar->{range}{$_}{id}.",\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
        }
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*patch_type\b/) {
			my $prefix = $1;
			push @out, $_;
			for (sort {$grammar->{range}{$a}{id} <=> $grammar->{range}{$b}{id}} keys %{$grammar->{range}}) {
				push @out, "$prefix$_ = ".$grammar->{range}{$_}{id}.",\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
        }
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*patch_sizes\b/) {
			my $prefix = $1;
			push @out, $_;
			for (sort {$grammar->{range}{$a}{id} <=> $grammar->{range}{$b}{id}} keys %{$grammar->{range}}) {
				push @out, $prefix."{ PatchType::".$_.", ".$grammar->{range}{$_}{size}." },\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
        }
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*range_lookup_t\b/) {
			my $prefix = $1;
			push @out, $_;
			for (sort {$grammar->{range}{$a}{id} <=> $grammar->{range}{$b}{id}} keys %{$grammar->{range}}) {
				push @out, $prefix."{ '".$grammar->{range}{$_}{code}."', ".
				           "\"".$grammar->{range}{$_}{str}."\", ".
						   $grammar->{range}{$_}{size}." },".
						   " // RANGE_$_ = ".$grammar->{range}{$_}{id}."\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
        }
        elsif (/^(\s*)\/\/\@\@BEGIN:\s*actions_decl\b/) {
			my $prefix = $1;
			push @out, $_;
			for my $action_id (0 .. @{$grammar->{rules}} - 1) {
				push @out, $prefix."void ".action_funcname($action_id)."();\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*actions_impl\b/) {
			my $prefix = $1;
			push @out, $_;
			for my $action_id (0 .. @{$grammar->{rules}} - 1) {
				push @out, $prefix."void LineParser::".action_funcname($action_id)."() {\n";
				my $action = action_function($grammar->{actions}[$action_id]);
				push @out, "$prefix$action\n";
				push @out, "}\n\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*states\b/) {
			my $prefix = $1;
			push @out, $_;
			for my $state (@{$grammar->{states}}) {
				my $line = $prefix."{ /* ".$state->{state}.": ".
						   join(" ", @{$state->{path}})." */\n"; 
				
				# unordered_map<Keyword, int>	keyword_next;
				$line .= "$prefix  { "; 
				for my $token (sort keys %{$state->{tokens}}) {
					next unless exists $keywords{$token};
					$line .= "{Keyword::$token, ".$state->{tokens}{$token}."}, ";
				}
				$line .= "},\n";
				
				# unordered_map<TType::Token, int>	token_next;
				$line .= "$prefix  { "; 
				for my $token (sort keys %{$state->{tokens}}) {
					next if exists $keywords{$token};
					$line .= "{TType::$token, ".$state->{tokens}{$token}."}, ";
				}
				$line .= "},\n";
				
				# int action{-1};
				$line .= "$prefix  ";
				if (exists $state->{action}) {
					$line .= "&LineParser::".action_funcname($state->{action});
				}
				else {
					$line .= "nullptr";
				}
				$line .= ",\n";
				
				$line .= "$prefix},\n";
				
				push @out, $line;
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*cpu_t\b/) {
			my $prefix = $1;
			push @out, $_;
			for (sort {$grammar->{cpus}{$a}{id} <=> $grammar->{cpus}{$b}{id}} keys %{$grammar->{cpus}}) {
				push @out, "${prefix}CPU_$_ = ".$grammar->{cpus}{$_}{id}.",\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*cpu_id\b/) {
			my $prefix = $1;
			push @out, $_;
			for (sort {$grammar->{cpus}{$a}{id} <=> $grammar->{cpus}{$b}{id}} keys %{$grammar->{cpus}}) {
				my $cpu = $_ =~ s/^(\d)/I$1/r;
				push @out, "$prefix$cpu = ".$grammar->{cpus}{$_}{id}.",\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*cpu_lut\b/) {
			my $prefix = $1;
			push @out, $_;
			for (sort {$grammar->{cpus}{$a}{id} <=> $grammar->{cpus}{$b}{id}} keys %{$grammar->{cpus}}) {
				next if $_ eq 'UNDEF';
				my $id = $grammar->{cpus}{$_}{id};
				my $cpu = "CPU_$_";
				my $name = $grammar->{cpus}{$_}{name};
				my $parent = "CPU_".$grammar->{cpus}{$_}{parent};
				my $non_strict = $cpu =~ s/_STRICT//r;
				my $is_strict = $cpu =~ /_STRICT$/ ? 'true' : 'false';
				push @out, $prefix."{ ".c_string($name).", $cpu, $parent, $non_strict, $is_strict }, // $id\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*cpu_table\b/) {
			my $prefix = $1;
			push @out, $_;
			for (sort {$grammar->{cpus}{$a}{id} <=> $grammar->{cpus}{$b}{id}} keys %{$grammar->{cpus}}) {
				next if $_ eq 'UNDEF';
				my $id = $grammar->{cpus}{$_}{id};
				my $cpu = $_ =~ s/^(\d)/I$1/r;
				my $name = $grammar->{cpus}{$_}{name};
				my $parent = $grammar->{cpus}{$_}{parent} =~ s/^(\d)/I$1/r;
				my $non_strict = $cpu =~ s/_STRICT//r;
				my $is_strict = $cpu =~ /_STRICT$/ ? 'true' : 'false';
				my $defines = "{".join(",", map {c_string($_)} split(' ', $grammar->{cpus}{$_}{defines}))."}";
				push @out, $prefix."{ ".c_string($name).", Cpu::$cpu, Cpu::$parent, Cpu::$non_strict, $is_strict, -1, $defines }, // $id\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*sym_scope_t\b/) {
			my $prefix = $1;
			push @out, $_;
			for (sort {$grammar->{scope}{$a}{id} <=> $grammar->{scope}{$b}{id}} keys %{$grammar->{scope}}) {
				push @out, $prefix."SCOPE_$_ = ".$grammar->{scope}{$_}{id}.",\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*SymScope\b/) {
			my $prefix = $1;
			push @out, $_;
			for (sort {$grammar->{scope}{$a}{id} <=> $grammar->{scope}{$b}{id}} keys %{$grammar->{scope}}) {
				push @out, $prefix."$_ = ".$grammar->{scope}{$_}{id}.",\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*sym_type_t\b/) {
			my $prefix = $1;
			push @out, $_;
			for (sort {$grammar->{type}{$a}{id} <=> $grammar->{type}{$b}{id}} keys %{$grammar->{type}}) {
				push @out, $prefix."TYPE_$_ = ".$grammar->{type}{$_}{id}.",\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*SymType\b/) {
			my $prefix = $1;
			push @out, $_;
			for (sort {$grammar->{type}{$a}{id} <=> $grammar->{type}{$b}{id}} keys %{$grammar->{type}}) {
				push @out, $prefix."$_ = ".$grammar->{type}{$_}{id}.",\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*swap_ixiy_t\b/) {
			my $prefix = $1;
			push @out, $_;
			for (sort {$grammar->{swap_ixiy}{$a}{id} <=> $grammar->{swap_ixiy}{$b}{id}} keys %{$grammar->{swap_ixiy}}) {
				push @out, $prefix."IXIY_$_ = ".$grammar->{swap_ixiy}{$_}{id}.",\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*swap_ixiy_lu\b/) {
			my $prefix = $1;
			push @out, $_;
			for (sort {$grammar->{swap_ixiy}{$a}{id} <=> $grammar->{swap_ixiy}{$b}{id}} keys %{$grammar->{swap_ixiy}}) {
				push @out, $prefix.c_string($grammar->{swap_ixiy}{$_}{text}),", // IXIY_$_ = ".$grammar->{swap_ixiy}{$_}{id}."\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		elsif (/^(\s*)\/\/\@\@BEGIN:\s*SwapIXIY\b/) {
			my $prefix = $1;
			push @out, $_;
			for (sort {$grammar->{swap_ixiy}{$a}{id} <=> $grammar->{swap_ixiy}{$b}{id}} keys %{$grammar->{swap_ixiy}}) {
				push @out, $prefix."$_ = ".$grammar->{swap_ixiy}{$_}{id}.",\n";
			}
			while (@in && $in[0] !~ /^\s*\/\/\@\@END/) {
				shift @in;
			}
		}
		else {
			push @out, $_;
		}
	}
	
	# change template if needed
	my $ac = Array::Compare->new;
	if (!$ac->compare(\@in0, \@out)) {
		copy($file, "$file.bak") or die "copy to $file.bak failed\n";
		path($file)->spew(@out);
		system("dos2unix", $file)==0 or die "dos2unix failed: $!";
	}
}

sub c_string {
	my($text) = @_;
	$text =~ s/([\\"])/\\$1/g;
	$text =~ s/\n/\\n/g;
	return '"'.$text.'"';
}

sub action_funcname {
	my($action_id) = @_;
	my @tokens = @{$grammar->{rules}[$action_id]};
	my $funcname = "action_".lc(join("_", @tokens));
	return $funcname;
}

sub action_function {
    my($text) = @_;
    for ($text) {
        s/\$(\d+)/m_elems.elems[$1-1]/g;
    }
    return $text;
}

#-------------------------------------------------------------------------------
# make state machine to parse the grammar
#-------------------------------------------------------------------------------
sub make_state_machine {
	my @rules = @{$grammar->{rules}};
	my @actions = @{$grammar->{actions}};
	
	# build a trie for the rules
	my $trie = {};
	for my $rule_nr (0 .. $#rules) {
		my @tokens = @{$rules[$rule_nr]};
		push @tokens, 'END'; # add END token to the end of the rule
		my $action = $actions[$rule_nr];
		
		my $node = $trie;
		for my $token (@tokens) {
			if (!exists $node->{$token}) {
				$node->{$token} = {};
			}
			$node = $node->{$token};
		}
		$node->{action} = $rule_nr; # store the action at the end of the path
	}

	# create states
	my @states;

	my $traverse;
	$traverse = sub {	# so that we can use it recursively
		my($node, $state, @path) = @_;

		if (!defined $states[$state]) {
			# create a new state
			$states[$state] = {state => $state, tokens => {}, path => [@path]};
		}

		if (exists $node->{action}) {
			# this is a valid state
			$states[$state]{action} = $node->{action};
		}
		else {
			for my $token (sort keys %$node) {
				next if $token eq 'action'; # skip the action key
				if (exists $states[$state]{tokens}{$token}) {
					$state = $states[$state]{tokens}{$token}; # reuse existing state
				}
				else {
					my $new_state = $#states + 1; # create a new state
					$states[$state]{tokens}{$token} = $new_state;
					$traverse->($node->{$token}, $new_state, @path, $token);
				}
			}
		}
	};
	$traverse->($trie, 0);

	$grammar->{trie} = $trie;
	$grammar->{states} = \@states;
}
