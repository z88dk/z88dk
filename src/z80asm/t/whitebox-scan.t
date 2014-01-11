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
# Test scan.rl

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

my $objs = "scan.o errors.o file.o lib/class.o lib/strutil.o lib/strhash.o lib/list.o lib/fileutil.o options.o hist.o";

# build list of case TOKEN: return "TOKEN" from scan.h
my @token_case;
for (read_file("scan.h")) {
	if (/enum token/ .. /\};/) {
		if (/^\s*(t_\w+)\s*=\s*/) {
			my $case = $1;
			push @token_case, "\t\tcase $case: return \"$case\";\n";
		}
	}
}

my $init = <<'END'; $init =~ s/<TOKEN_CASE>/@token_case/;
#include "symbol.h"

struct module *CURRENTMODULE;
FILE *errfile;
size_t get_PC( void ) { return 0; }
void list_start_line( size_t address, char *source_file, int source_line_nr, char *line ) 
{	
	warn("%04X %-16s %5d %s", address, source_file, source_line_nr, line);
}
char *CreateLibfile( char *filename ) {return NULL;}
char *GetLibfile( char *filename ) {return NULL;}
Symbol *define_static_def_sym( char *name, long value ) {return NULL;}
char ident[MAXLINE];
char separators[MAXLINE];


char *decode_token (enum token token)
{
	static char token_str[MAXLINE];
	
	switch (token) {
<TOKEN_CASE>
		default:
			if (token >= 32 && token < 127)
				sprintf(token_str, "'%c'", token);
			else
				sprintf(token_str, "token(%d)", token);
			return token_str;
	}
}

void dump_string( char *p )
{
	fprintf( stderr, "\"" );
	for ( ; *p; p++ )
		if (*p >= 32 && *p < 127)
			fprintf( stderr, "%c", *p );
		else
			fprintf( stderr, "<%02X>", *p & 0xFF );
	fprintf( stderr, "\"" );
}

void get_tokens( Scan *scan, int n, BOOL by_lines )
{
	enum token token;
	int count_end = 0;
	char *line;

	while ( n-- != 0 && count_end < 2 )
	{
		if (by_lines)
		{
			if ( scan )
				line = get_line_Scan( scan );
			else
				line = get_line();
				
			if ( line )
			{
				ASSERT( line == last_token_str->str );
				ASSERT( last_token == t_string );
			}
			else 
			{
				ASSERT( last_token == t_end );
			}
		}
		else			
		{
			if ( scan )
				token = get_token_Scan( scan );
			else
				token = get_token();

			ASSERT( token == last_token );
		}

		warn("%5d %-12s, value %5d, ",
			 last_token, decode_token(last_token), 
			 last_token_num );
		dump_string( last_token_str->str );
		warn("\n");
		
		if ( ! last_token ) count_end++;
	}
}

END

t_compile_module($init, <<'END', $objs);
	Str *input = OBJ_NEW(Str);
	Scan *scan = OBJ_NEW(Scan);
	int i, j;
	
	/* scan each argv */
	for ( i = 1; i < argc; i++ )
	{
		for ( j = 0; j < 2; j++ )
		{
			Scan *my_scan = j == 0 ? scan : NULL;
			
			warn("Scan file \"%s\" by lines (%d)\n", argv[i], j );
	
			if ( my_scan )
				scan_file_Scan( my_scan, argv[i] );
			else
				scan_file( argv[i] );
				
			get_tokens( my_scan, -1, TRUE );
			warn("\n");
				
			warn("Scan file \"%s\" by tokens (%d)\n", argv[i], j );
	
			if ( my_scan )
				scan_file_Scan( my_scan, argv[i] );
			else
				scan_file( argv[i] );
				
			get_tokens( my_scan, -1, FALSE );
			warn("\n");
		}
	}
	
	warn("Test scan stack\n");
	Str_set( input, "start:ld a,25\n");
	warn("Text: %s", input->str );
	scan_string( input->str );
	get_tokens( NULL, 4, FALSE );
	scan_string( "2*" );
	warn("Insert text: 2*\n" );
	get_tokens( NULL, -1, FALSE );
	
	OBJ_DELETE(input);
	OBJ_DELETE(scan);
END

write_file(asm1_file(), "" );
write_file(asm2_file(), {binmode => ':raw'},
	"\n",
	join(" ", grep {! /[\"\';]/ } map {chr} 1..255),	# no end newline
);

write_file(asm3_file(), <<'END' );
; sigle-character tokens
! # $ % & ( ) * + , - . / : < = > ? @ [ \ ] ^ ` { | } ~ 

; multiple-character tokens
== <> != <= >= || && << >> ** 

; names
_Abc_123 Abc_123 123_Abc_
Abc_123	af' b'c'd'e'af'

; labels
. 	abc	   .def ghi: .jkl:
	abc	 : .def ghi: .jkl:
. 	abc	 : .def ghi: .jkl:

; numbers - decimal
0 2147483647 2147483648

; numbers - binary
  0000b   0011b    1111111111111111111111111111111b
 @0000   @0011    @1111111111111111111111111111111
 %0000   %0011    %1111111111111111111111111111111
0b0000  0b0011   0b1111111111111111111111111111111
@"----" @"--##"  @"###############################"
%"----" %"--##"  %"###############################"
%"#" %"#---" %"#-------"  %"#-----------" %"#---------------" %"#-------------------"
%"#-----------------------" %"#---------------------------" 
%"#-------------------------------" %"#--------------------------------"

; numbers - hexadecimal
  0h 0ah 0FH   7FFFFFFFh
 $0   $a  $F  $7FFFFFFF 
 #0   #a  #F  #7FFFFFFF
0x0  0xa 0xF 0x7FFFFFFF

"strings - single-quote"
'
'a
''
'a'
'aa'

"strings - double-quotes"
"
"a
""
"a"
"aa"

END

write_file(asm4_file(), "\"Very long number token\" " . ("0" x (32*1024)) . "12345\n" );

t_run_module( [ asm1_file(), asm2_file(), asm3_file(), asm4_file() ], '', <<'ERR', 0); 
Scan file "test1.asm" by lines (0)
    0 t_end       , value     0, ""
    0 t_end       , value     0, ""

Scan file "test1.asm" by tokens (0)
    0 t_end       , value     0, ""
    0 t_end       , value     0, ""

Scan file "test1.asm" by lines (1)
    0 t_end       , value     0, ""
    0 t_end       , value     0, ""

Scan file "test1.asm" by tokens (1)
    0 t_end       , value     0, ""
    0 t_end       , value     0, ""

Scan file "test2.asm" by lines (0)
    4 t_string    , value     0, "<0A>"
    4 t_string    , value     0, "<01> <02> <03> <04> <05> <06> <07> <08> <09> <0A>"
    4 t_string    , value     0, " <0B> <0C> <0A>"
    4 t_string    , value     0, " <0E> <0F> <10> <11> <12> <13> <14> <15> <16> <17> <18> <19> <1A> <1B> <1C> <1D> <1E> <1F>   ! # $ % & ( ) * + , - . / 0 1 2 3 4 5 6 7 8 9 : < = > ? @ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z [ \ ] ^ _ ` a b c d e f g h i j k l m n o p q r s t u v w x y z { | } ~ <7F> <80> <81> <82> <83> <84> <85> <86> <87> <88> <89> <8A> <8B> <8C> <8D> <8E> <8F> <90> <91> <92> <93> <94> <95> <96> <97> <98> <99> <9A> <9B> <9C> <9D> <9E> <9F> <A0> <A1> <A2> <A3> <A4> <A5> <A6> <A7> <A8> <A9> <AA> <AB> <AC> <AD> <AE> <AF> <B0> <B1> <B2> <B3> <B4> <B5> <B6> <B7> <B8> <B9> <BA> <BB> <BC> <BD> <BE> <BF> <C0> <C1> <C2> <C3> <C4> <C5> <C6> <C7> <C8> <C9> <CA> <CB> <CC> <CD> <CE> <CF> <D0> <D1> <D2> <D3> <D4> <D5> <D6> <D7> <D8> <D9> <DA> <DB> <DC> <DD> <DE> <DF> <E0> <E1> <E2> <E3> <E4> <E5> <E6> <E7> <E8> <E9> <EA> <EB> <EC> <ED> <EE> <EF> <F0> <F1> <F2> <F3> <F4> <F5> <F6> <F7> <F8> <F9> <FA> <FB> <FC> <FD> <FE> <FF><0A>"
    0 t_end       , value     0, ""
    0 t_end       , value     0, ""

Scan file "test2.asm" by tokens (0)
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
   33 t_exclam    , value     0, ""
   35 t_hash      , value     0, ""
   36 t_dollar    , value     0, ""
   37 t_percent   , value     0, ""
   38 t_and       , value     0, ""
   40 t_lparen    , value     0, ""
   41 t_rparen    , value     0, ""
   42 t_star      , value     0, ""
   43 t_plus      , value     0, ""
   44 t_comma     , value     0, ""
   45 t_minus     , value     0, ""
   46 t_dot       , value     0, ""
   47 t_slash     , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value     1, ""
    3 t_number    , value     2, ""
    3 t_number    , value     3, ""
    3 t_number    , value     4, ""
    3 t_number    , value     5, ""
    3 t_number    , value     6, ""
    3 t_number    , value     7, ""
    3 t_number    , value     8, ""
    3 t_number    , value     9, ""
   58 t_colon     , value     0, ""
   60 t_lt        , value     0, ""
   61 t_eq        , value     0, ""
   62 t_gt        , value     0, ""
   63 t_question  , value     0, ""
   64 t_at        , value     0, ""
    1 t_name      , value     0, "A"
    1 t_name      , value     0, "B"
    1 t_name      , value     0, "C"
    1 t_name      , value     0, "D"
    1 t_name      , value     0, "E"
    1 t_name      , value     0, "F"
    1 t_name      , value     0, "G"
    1 t_name      , value     0, "H"
    1 t_name      , value     0, "I"
    1 t_name      , value     0, "J"
    1 t_name      , value     0, "K"
    1 t_name      , value     0, "L"
    1 t_name      , value     0, "M"
    1 t_name      , value     0, "N"
    1 t_name      , value     0, "O"
    1 t_name      , value     0, "P"
    1 t_name      , value     0, "Q"
    1 t_name      , value     0, "R"
    1 t_name      , value     0, "S"
    1 t_name      , value     0, "T"
    1 t_name      , value     0, "U"
    1 t_name      , value     0, "V"
    1 t_name      , value     0, "W"
    1 t_name      , value     0, "X"
    1 t_name      , value     0, "Y"
    1 t_name      , value     0, "Z"
   91 t_lsquare   , value     0, ""
   92 t_bslash    , value     0, ""
   93 t_rsquare   , value     0, ""
   94 t_caret     , value     0, ""
    1 t_name      , value     0, "_"
   96 t_bquote    , value     0, ""
    1 t_name      , value     0, "A"
    1 t_name      , value     0, "B"
    1 t_name      , value     0, "C"
    1 t_name      , value     0, "D"
    1 t_name      , value     0, "E"
    1 t_name      , value     0, "F"
    1 t_name      , value     0, "G"
    1 t_name      , value     0, "H"
    1 t_name      , value     0, "I"
    1 t_name      , value     0, "J"
    1 t_name      , value     0, "K"
    1 t_name      , value     0, "L"
    1 t_name      , value     0, "M"
    1 t_name      , value     0, "N"
    1 t_name      , value     0, "O"
    1 t_name      , value     0, "P"
    1 t_name      , value     0, "Q"
    1 t_name      , value     0, "R"
    1 t_name      , value     0, "S"
    1 t_name      , value     0, "T"
    1 t_name      , value     0, "U"
    1 t_name      , value     0, "V"
    1 t_name      , value     0, "W"
    1 t_name      , value     0, "X"
    1 t_name      , value     0, "Y"
    1 t_name      , value     0, "Z"
  123 t_lcurly    , value     0, ""
  124 t_vbar      , value     0, ""
  125 t_rcurly    , value     0, ""
  126 t_tilde     , value     0, ""
   10 t_newline   , value     0, ""
    0 t_end       , value     0, ""
    0 t_end       , value     0, ""

Scan file "test2.asm" by lines (1)
    4 t_string    , value     0, "<0A>"
    4 t_string    , value     0, "<01> <02> <03> <04> <05> <06> <07> <08> <09> <0A>"
    4 t_string    , value     0, " <0B> <0C> <0A>"
    4 t_string    , value     0, " <0E> <0F> <10> <11> <12> <13> <14> <15> <16> <17> <18> <19> <1A> <1B> <1C> <1D> <1E> <1F>   ! # $ % & ( ) * + , - . / 0 1 2 3 4 5 6 7 8 9 : < = > ? @ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z [ \ ] ^ _ ` a b c d e f g h i j k l m n o p q r s t u v w x y z { | } ~ <7F> <80> <81> <82> <83> <84> <85> <86> <87> <88> <89> <8A> <8B> <8C> <8D> <8E> <8F> <90> <91> <92> <93> <94> <95> <96> <97> <98> <99> <9A> <9B> <9C> <9D> <9E> <9F> <A0> <A1> <A2> <A3> <A4> <A5> <A6> <A7> <A8> <A9> <AA> <AB> <AC> <AD> <AE> <AF> <B0> <B1> <B2> <B3> <B4> <B5> <B6> <B7> <B8> <B9> <BA> <BB> <BC> <BD> <BE> <BF> <C0> <C1> <C2> <C3> <C4> <C5> <C6> <C7> <C8> <C9> <CA> <CB> <CC> <CD> <CE> <CF> <D0> <D1> <D2> <D3> <D4> <D5> <D6> <D7> <D8> <D9> <DA> <DB> <DC> <DD> <DE> <DF> <E0> <E1> <E2> <E3> <E4> <E5> <E6> <E7> <E8> <E9> <EA> <EB> <EC> <ED> <EE> <EF> <F0> <F1> <F2> <F3> <F4> <F5> <F6> <F7> <F8> <F9> <FA> <FB> <FC> <FD> <FE> <FF><0A>"
    0 t_end       , value     0, ""
    0 t_end       , value     0, ""

Scan file "test2.asm" by tokens (1)
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
   33 t_exclam    , value     0, ""
   35 t_hash      , value     0, ""
   36 t_dollar    , value     0, ""
   37 t_percent   , value     0, ""
   38 t_and       , value     0, ""
   40 t_lparen    , value     0, ""
   41 t_rparen    , value     0, ""
   42 t_star      , value     0, ""
   43 t_plus      , value     0, ""
   44 t_comma     , value     0, ""
   45 t_minus     , value     0, ""
   46 t_dot       , value     0, ""
   47 t_slash     , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value     1, ""
    3 t_number    , value     2, ""
    3 t_number    , value     3, ""
    3 t_number    , value     4, ""
    3 t_number    , value     5, ""
    3 t_number    , value     6, ""
    3 t_number    , value     7, ""
    3 t_number    , value     8, ""
    3 t_number    , value     9, ""
   58 t_colon     , value     0, ""
   60 t_lt        , value     0, ""
   61 t_eq        , value     0, ""
   62 t_gt        , value     0, ""
   63 t_question  , value     0, ""
   64 t_at        , value     0, ""
    1 t_name      , value     0, "A"
    1 t_name      , value     0, "B"
    1 t_name      , value     0, "C"
    1 t_name      , value     0, "D"
    1 t_name      , value     0, "E"
    1 t_name      , value     0, "F"
    1 t_name      , value     0, "G"
    1 t_name      , value     0, "H"
    1 t_name      , value     0, "I"
    1 t_name      , value     0, "J"
    1 t_name      , value     0, "K"
    1 t_name      , value     0, "L"
    1 t_name      , value     0, "M"
    1 t_name      , value     0, "N"
    1 t_name      , value     0, "O"
    1 t_name      , value     0, "P"
    1 t_name      , value     0, "Q"
    1 t_name      , value     0, "R"
    1 t_name      , value     0, "S"
    1 t_name      , value     0, "T"
    1 t_name      , value     0, "U"
    1 t_name      , value     0, "V"
    1 t_name      , value     0, "W"
    1 t_name      , value     0, "X"
    1 t_name      , value     0, "Y"
    1 t_name      , value     0, "Z"
   91 t_lsquare   , value     0, ""
   92 t_bslash    , value     0, ""
   93 t_rsquare   , value     0, ""
   94 t_caret     , value     0, ""
    1 t_name      , value     0, "_"
   96 t_bquote    , value     0, ""
    1 t_name      , value     0, "A"
    1 t_name      , value     0, "B"
    1 t_name      , value     0, "C"
    1 t_name      , value     0, "D"
    1 t_name      , value     0, "E"
    1 t_name      , value     0, "F"
    1 t_name      , value     0, "G"
    1 t_name      , value     0, "H"
    1 t_name      , value     0, "I"
    1 t_name      , value     0, "J"
    1 t_name      , value     0, "K"
    1 t_name      , value     0, "L"
    1 t_name      , value     0, "M"
    1 t_name      , value     0, "N"
    1 t_name      , value     0, "O"
    1 t_name      , value     0, "P"
    1 t_name      , value     0, "Q"
    1 t_name      , value     0, "R"
    1 t_name      , value     0, "S"
    1 t_name      , value     0, "T"
    1 t_name      , value     0, "U"
    1 t_name      , value     0, "V"
    1 t_name      , value     0, "W"
    1 t_name      , value     0, "X"
    1 t_name      , value     0, "Y"
    1 t_name      , value     0, "Z"
  123 t_lcurly    , value     0, ""
  124 t_vbar      , value     0, ""
  125 t_rcurly    , value     0, ""
  126 t_tilde     , value     0, ""
   10 t_newline   , value     0, ""
    0 t_end       , value     0, ""
    0 t_end       , value     0, ""

Scan file "test3.asm" by lines (0)
    4 t_string    , value     0, "; sigle-character tokens<0A>"
    4 t_string    , value     0, "! # $ % & ( ) * + , - . / : < = > ? @ [ \ ] ^ ` { | } ~ <0A>"
    4 t_string    , value     0, "<0A>"
    4 t_string    , value     0, "; multiple-character tokens<0A>"
    4 t_string    , value     0, "== <> != <= >= || && << >> ** <0A>"
    4 t_string    , value     0, "<0A>"
    4 t_string    , value     0, "; names<0A>"
    4 t_string    , value     0, "_Abc_123 Abc_123 123_Abc_<0A>"
    4 t_string    , value     0, "Abc_123<09>af' b'c'd'e'af'<0A>"
    4 t_string    , value     0, "<0A>"
    4 t_string    , value     0, "; labels<0A>"
    4 t_string    , value     0, ". <09>abc<09>   .def ghi: .jkl:<0A>"
    4 t_string    , value     0, "<09>abc<09> : .def ghi: .jkl:<0A>"
    4 t_string    , value     0, ". <09>abc<09> : .def ghi: .jkl:<0A>"
    4 t_string    , value     0, "<0A>"
    4 t_string    , value     0, "; numbers - decimal<0A>"
    4 t_string    , value     0, "0 2147483647 2147483648<0A>"
    4 t_string    , value     0, "<0A>"
    4 t_string    , value     0, "; numbers - binary<0A>"
    4 t_string    , value     0, "  0000b   0011b    1111111111111111111111111111111b<0A>"
    4 t_string    , value     0, " @0000   @0011    @1111111111111111111111111111111<0A>"
    4 t_string    , value     0, " %0000   %0011    %1111111111111111111111111111111<0A>"
    4 t_string    , value     0, "0b0000  0b0011   0b1111111111111111111111111111111<0A>"
    4 t_string    , value     0, "@"----" @"--##"  @"###############################"<0A>"
    4 t_string    , value     0, "%"----" %"--##"  %"###############################"<0A>"
    4 t_string    , value     0, "%"#" %"#---" %"#-------"  %"#-----------" %"#---------------" %"#-------------------"<0A>"
    4 t_string    , value     0, "%"#-----------------------" %"#---------------------------" <0A>"
    4 t_string    , value     0, "%"#-------------------------------" %"#--------------------------------"<0A>"
    4 t_string    , value     0, "<0A>"
    4 t_string    , value     0, "; numbers - hexadecimal<0A>"
    4 t_string    , value     0, "  0h 0ah 0FH   7FFFFFFFh<0A>"
    4 t_string    , value     0, " $0   $a  $F  $7FFFFFFF <0A>"
    4 t_string    , value     0, " #0   #a  #F  #7FFFFFFF<0A>"
    4 t_string    , value     0, "0x0  0xa 0xF 0x7FFFFFFF<0A>"
    4 t_string    , value     0, "<0A>"
    4 t_string    , value     0, ""strings - single-quote"<0A>"
    4 t_string    , value     0, "'<0A>"
    4 t_string    , value     0, "'a<0A>"
    4 t_string    , value     0, "''<0A>"
    4 t_string    , value     0, "'a'<0A>"
    4 t_string    , value     0, "'aa'<0A>"
    4 t_string    , value     0, "<0A>"
    4 t_string    , value     0, ""strings - double-quotes"<0A>"
    4 t_string    , value     0, ""<0A>"
    4 t_string    , value     0, ""a<0A>"
    4 t_string    , value     0, """<0A>"
    4 t_string    , value     0, ""a"<0A>"
    4 t_string    , value     0, ""aa"<0A>"
    4 t_string    , value     0, "<0A>"
    0 t_end       , value     0, ""
    0 t_end       , value     0, ""

Scan file "test3.asm" by tokens (0)
   10 t_newline   , value     0, ""
   33 t_exclam    , value     0, ""
   35 t_hash      , value     0, ""
   36 t_dollar    , value     0, ""
   37 t_percent   , value     0, ""
   38 t_and       , value     0, ""
   40 t_lparen    , value     0, ""
   41 t_rparen    , value     0, ""
   42 t_star      , value     0, ""
   43 t_plus      , value     0, ""
   44 t_comma     , value     0, ""
   45 t_minus     , value     0, ""
   46 t_dot       , value     0, ""
   47 t_slash     , value     0, ""
   58 t_colon     , value     0, ""
   60 t_lt        , value     0, ""
   61 t_eq        , value     0, ""
   62 t_gt        , value     0, ""
   63 t_question  , value     0, ""
   64 t_at        , value     0, ""
   91 t_lsquare   , value     0, ""
   92 t_bslash    , value     0, ""
   93 t_rsquare   , value     0, ""
   94 t_caret     , value     0, ""
   96 t_bquote    , value     0, ""
  123 t_lcurly    , value     0, ""
  124 t_vbar      , value     0, ""
  125 t_rcurly    , value     0, ""
  126 t_tilde     , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
15677 t_eq_eq     , value     0, ""
15422 t_lt_gt     , value     0, ""
 8509 t_exclam_eq , value     0, ""
15421 t_lt_eq     , value     0, ""
15933 t_gt_eq     , value     0, ""
31868 t_vbar_vbar , value     0, ""
 9766 t_and_and   , value     0, ""
15420 t_lt_lt     , value     0, ""
15934 t_gt_gt     , value     0, ""
10794 t_star_star , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
    1 t_name      , value     0, "_ABC_123"
    1 t_name      , value     0, "ABC_123"
    3 t_number    , value   123, ""
    1 t_name      , value     0, "_ABC_"
   10 t_newline   , value     0, ""
    1 t_name      , value     0, "ABC_123"
    1 t_name      , value     0, "AF'"
    1 t_name      , value     0, "B"
    3 t_number    , value    99, ""
    1 t_name      , value     0, "D"
    3 t_number    , value   101, ""
    1 t_name      , value     0, "AF'"
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
    2 t_label     , value     0, "ABC"
   46 t_dot       , value     0, ""
    1 t_name      , value     0, "DEF"
    1 t_name      , value     0, "GHI"
   58 t_colon     , value     0, ""
   46 t_dot       , value     0, ""
    1 t_name      , value     0, "JKL"
   58 t_colon     , value     0, ""
   10 t_newline   , value     0, ""
    2 t_label     , value     0, "ABC"
   46 t_dot       , value     0, ""
    1 t_name      , value     0, "DEF"
    1 t_name      , value     0, "GHI"
   58 t_colon     , value     0, ""
   46 t_dot       , value     0, ""
    1 t_name      , value     0, "JKL"
   58 t_colon     , value     0, ""
   10 t_newline   , value     0, ""
    2 t_label     , value     0, "ABC"
   46 t_dot       , value     0, ""
    1 t_name      , value     0, "DEF"
    1 t_name      , value     0, "GHI"
   58 t_colon     , value     0, ""
   46 t_dot       , value     0, ""
    1 t_name      , value     0, "JKL"
   58 t_colon     , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value 2147483647, ""
Warning at file 'test3.asm' line 17: integer '-2147483648' out of range
    3 t_number    , value -2147483648, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value     3, ""
    3 t_number    , value 2147483647, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value     3, ""
    3 t_number    , value 2147483647, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value     3, ""
    3 t_number    , value 2147483647, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value     3, ""
    3 t_number    , value 2147483647, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value     3, ""
    3 t_number    , value 2147483647, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value     3, ""
    3 t_number    , value 2147483647, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     1, ""
    3 t_number    , value     8, ""
    3 t_number    , value   128, ""
    3 t_number    , value  2048, ""
    3 t_number    , value 32768, ""
    3 t_number    , value 524288, ""
   10 t_newline   , value     0, ""
    3 t_number    , value 8388608, ""
    3 t_number    , value 134217728, ""
   10 t_newline   , value     0, ""
Warning at file 'test3.asm' line 28: integer '-2147483648' out of range
    3 t_number    , value -2147483648, ""
Warning at file 'test3.asm' line 28: integer '-2147483648' out of range
    3 t_number    , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value    10, ""
    3 t_number    , value    15, ""
    3 t_number    , value 2147483647, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value    10, ""
    3 t_number    , value    15, ""
    3 t_number    , value 2147483647, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value    10, ""
    3 t_number    , value    15, ""
    3 t_number    , value 2147483647, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value    10, ""
    3 t_number    , value    15, ""
    3 t_number    , value 2147483647, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
    4 t_string    , value     0, "strings - single-quote"
   10 t_newline   , value     0, ""
Error at file 'test3.asm' line 37: invalid single quoted character
   10 t_newline   , value     0, ""
Error at file 'test3.asm' line 38: invalid single quoted character
   10 t_newline   , value     0, ""
Error at file 'test3.asm' line 39: invalid single quoted character
   10 t_newline   , value     0, ""
    3 t_number    , value    97, ""
   10 t_newline   , value     0, ""
Error at file 'test3.asm' line 41: invalid single quoted character
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
    4 t_string    , value     0, "strings - double-quotes"
   10 t_newline   , value     0, ""
Error at file 'test3.asm' line 44: unclosed quoted string
   10 t_newline   , value     0, ""
Error at file 'test3.asm' line 45: unclosed quoted string
   10 t_newline   , value     0, ""
    4 t_string    , value     0, ""
   10 t_newline   , value     0, ""
    4 t_string    , value     0, "a"
   10 t_newline   , value     0, ""
    4 t_string    , value     0, "aa"
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
    0 t_end       , value     0, ""
    0 t_end       , value     0, ""

Scan file "test3.asm" by lines (1)
    4 t_string    , value     0, "; sigle-character tokens<0A>"
    4 t_string    , value     0, "! # $ % & ( ) * + , - . / : < = > ? @ [ \ ] ^ ` { | } ~ <0A>"
    4 t_string    , value     0, "<0A>"
    4 t_string    , value     0, "; multiple-character tokens<0A>"
    4 t_string    , value     0, "== <> != <= >= || && << >> ** <0A>"
    4 t_string    , value     0, "<0A>"
    4 t_string    , value     0, "; names<0A>"
    4 t_string    , value     0, "_Abc_123 Abc_123 123_Abc_<0A>"
    4 t_string    , value     0, "Abc_123<09>af' b'c'd'e'af'<0A>"
    4 t_string    , value     0, "<0A>"
    4 t_string    , value     0, "; labels<0A>"
    4 t_string    , value     0, ". <09>abc<09>   .def ghi: .jkl:<0A>"
    4 t_string    , value     0, "<09>abc<09> : .def ghi: .jkl:<0A>"
    4 t_string    , value     0, ". <09>abc<09> : .def ghi: .jkl:<0A>"
    4 t_string    , value     0, "<0A>"
    4 t_string    , value     0, "; numbers - decimal<0A>"
    4 t_string    , value     0, "0 2147483647 2147483648<0A>"
    4 t_string    , value     0, "<0A>"
    4 t_string    , value     0, "; numbers - binary<0A>"
    4 t_string    , value     0, "  0000b   0011b    1111111111111111111111111111111b<0A>"
    4 t_string    , value     0, " @0000   @0011    @1111111111111111111111111111111<0A>"
    4 t_string    , value     0, " %0000   %0011    %1111111111111111111111111111111<0A>"
    4 t_string    , value     0, "0b0000  0b0011   0b1111111111111111111111111111111<0A>"
    4 t_string    , value     0, "@"----" @"--##"  @"###############################"<0A>"
    4 t_string    , value     0, "%"----" %"--##"  %"###############################"<0A>"
    4 t_string    , value     0, "%"#" %"#---" %"#-------"  %"#-----------" %"#---------------" %"#-------------------"<0A>"
    4 t_string    , value     0, "%"#-----------------------" %"#---------------------------" <0A>"
    4 t_string    , value     0, "%"#-------------------------------" %"#--------------------------------"<0A>"
    4 t_string    , value     0, "<0A>"
    4 t_string    , value     0, "; numbers - hexadecimal<0A>"
    4 t_string    , value     0, "  0h 0ah 0FH   7FFFFFFFh<0A>"
    4 t_string    , value     0, " $0   $a  $F  $7FFFFFFF <0A>"
    4 t_string    , value     0, " #0   #a  #F  #7FFFFFFF<0A>"
    4 t_string    , value     0, "0x0  0xa 0xF 0x7FFFFFFF<0A>"
    4 t_string    , value     0, "<0A>"
    4 t_string    , value     0, ""strings - single-quote"<0A>"
    4 t_string    , value     0, "'<0A>"
    4 t_string    , value     0, "'a<0A>"
    4 t_string    , value     0, "''<0A>"
    4 t_string    , value     0, "'a'<0A>"
    4 t_string    , value     0, "'aa'<0A>"
    4 t_string    , value     0, "<0A>"
    4 t_string    , value     0, ""strings - double-quotes"<0A>"
    4 t_string    , value     0, ""<0A>"
    4 t_string    , value     0, ""a<0A>"
    4 t_string    , value     0, """<0A>"
    4 t_string    , value     0, ""a"<0A>"
    4 t_string    , value     0, ""aa"<0A>"
    4 t_string    , value     0, "<0A>"
    0 t_end       , value     0, ""
    0 t_end       , value     0, ""

Scan file "test3.asm" by tokens (1)
   10 t_newline   , value     0, ""
   33 t_exclam    , value     0, ""
   35 t_hash      , value     0, ""
   36 t_dollar    , value     0, ""
   37 t_percent   , value     0, ""
   38 t_and       , value     0, ""
   40 t_lparen    , value     0, ""
   41 t_rparen    , value     0, ""
   42 t_star      , value     0, ""
   43 t_plus      , value     0, ""
   44 t_comma     , value     0, ""
   45 t_minus     , value     0, ""
   46 t_dot       , value     0, ""
   47 t_slash     , value     0, ""
   58 t_colon     , value     0, ""
   60 t_lt        , value     0, ""
   61 t_eq        , value     0, ""
   62 t_gt        , value     0, ""
   63 t_question  , value     0, ""
   64 t_at        , value     0, ""
   91 t_lsquare   , value     0, ""
   92 t_bslash    , value     0, ""
   93 t_rsquare   , value     0, ""
   94 t_caret     , value     0, ""
   96 t_bquote    , value     0, ""
  123 t_lcurly    , value     0, ""
  124 t_vbar      , value     0, ""
  125 t_rcurly    , value     0, ""
  126 t_tilde     , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
15677 t_eq_eq     , value     0, ""
15422 t_lt_gt     , value     0, ""
 8509 t_exclam_eq , value     0, ""
15421 t_lt_eq     , value     0, ""
15933 t_gt_eq     , value     0, ""
31868 t_vbar_vbar , value     0, ""
 9766 t_and_and   , value     0, ""
15420 t_lt_lt     , value     0, ""
15934 t_gt_gt     , value     0, ""
10794 t_star_star , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
    1 t_name      , value     0, "_ABC_123"
    1 t_name      , value     0, "ABC_123"
    3 t_number    , value   123, ""
    1 t_name      , value     0, "_ABC_"
   10 t_newline   , value     0, ""
    1 t_name      , value     0, "ABC_123"
    1 t_name      , value     0, "AF'"
    1 t_name      , value     0, "B"
    3 t_number    , value    99, ""
    1 t_name      , value     0, "D"
    3 t_number    , value   101, ""
    1 t_name      , value     0, "AF'"
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
    2 t_label     , value     0, "ABC"
   46 t_dot       , value     0, ""
    1 t_name      , value     0, "DEF"
    1 t_name      , value     0, "GHI"
   58 t_colon     , value     0, ""
   46 t_dot       , value     0, ""
    1 t_name      , value     0, "JKL"
   58 t_colon     , value     0, ""
   10 t_newline   , value     0, ""
    2 t_label     , value     0, "ABC"
   46 t_dot       , value     0, ""
    1 t_name      , value     0, "DEF"
    1 t_name      , value     0, "GHI"
   58 t_colon     , value     0, ""
   46 t_dot       , value     0, ""
    1 t_name      , value     0, "JKL"
   58 t_colon     , value     0, ""
   10 t_newline   , value     0, ""
    2 t_label     , value     0, "ABC"
   46 t_dot       , value     0, ""
    1 t_name      , value     0, "DEF"
    1 t_name      , value     0, "GHI"
   58 t_colon     , value     0, ""
   46 t_dot       , value     0, ""
    1 t_name      , value     0, "JKL"
   58 t_colon     , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value 2147483647, ""
Warning at file 'test3.asm' line 17: integer '-2147483648' out of range
    3 t_number    , value -2147483648, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value     3, ""
    3 t_number    , value 2147483647, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value     3, ""
    3 t_number    , value 2147483647, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value     3, ""
    3 t_number    , value 2147483647, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value     3, ""
    3 t_number    , value 2147483647, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value     3, ""
    3 t_number    , value 2147483647, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value     3, ""
    3 t_number    , value 2147483647, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     1, ""
    3 t_number    , value     8, ""
    3 t_number    , value   128, ""
    3 t_number    , value  2048, ""
    3 t_number    , value 32768, ""
    3 t_number    , value 524288, ""
   10 t_newline   , value     0, ""
    3 t_number    , value 8388608, ""
    3 t_number    , value 134217728, ""
   10 t_newline   , value     0, ""
Warning at file 'test3.asm' line 28: integer '-2147483648' out of range
    3 t_number    , value -2147483648, ""
Warning at file 'test3.asm' line 28: integer '-2147483648' out of range
    3 t_number    , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value    10, ""
    3 t_number    , value    15, ""
    3 t_number    , value 2147483647, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value    10, ""
    3 t_number    , value    15, ""
    3 t_number    , value 2147483647, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value    10, ""
    3 t_number    , value    15, ""
    3 t_number    , value 2147483647, ""
   10 t_newline   , value     0, ""
    3 t_number    , value     0, ""
    3 t_number    , value    10, ""
    3 t_number    , value    15, ""
    3 t_number    , value 2147483647, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
    4 t_string    , value     0, "strings - single-quote"
   10 t_newline   , value     0, ""
Error at file 'test3.asm' line 37: invalid single quoted character
   10 t_newline   , value     0, ""
Error at file 'test3.asm' line 38: invalid single quoted character
   10 t_newline   , value     0, ""
Error at file 'test3.asm' line 39: invalid single quoted character
   10 t_newline   , value     0, ""
    3 t_number    , value    97, ""
   10 t_newline   , value     0, ""
Error at file 'test3.asm' line 41: invalid single quoted character
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
    4 t_string    , value     0, "strings - double-quotes"
   10 t_newline   , value     0, ""
Error at file 'test3.asm' line 44: unclosed quoted string
   10 t_newline   , value     0, ""
Error at file 'test3.asm' line 45: unclosed quoted string
   10 t_newline   , value     0, ""
    4 t_string    , value     0, ""
   10 t_newline   , value     0, ""
    4 t_string    , value     0, "a"
   10 t_newline   , value     0, ""
    4 t_string    , value     0, "aa"
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
    0 t_end       , value     0, ""
    0 t_end       , value     0, ""

Scan file "test4.asm" by lines (0)
    4 t_string    , value     0, ""Very long number token" 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012345<0A>"
    0 t_end       , value     0, ""
    0 t_end       , value     0, ""

Scan file "test4.asm" by tokens (0)
    4 t_string    , value     0, "Very long number token"
    3 t_number    , value 12345, ""
   10 t_newline   , value     0, ""
    0 t_end       , value     0, ""
    0 t_end       , value     0, ""

Scan file "test4.asm" by lines (1)
    4 t_string    , value     0, ""Very long number token" 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012345<0A>"
    0 t_end       , value     0, ""
    0 t_end       , value     0, ""

Scan file "test4.asm" by tokens (1)
    4 t_string    , value     0, "Very long number token"
    3 t_number    , value 12345, ""
   10 t_newline   , value     0, ""
    0 t_end       , value     0, ""
    0 t_end       , value     0, ""

Test scan stack
Text: start:ld a,25
    2 t_label     , value     0, "START"
    1 t_name      , value     0, "LD"
    1 t_name      , value     0, "A"
   44 t_comma     , value     0, ""
Insert text: 2*
    3 t_number    , value     2, ""
   42 t_star      , value     0, ""
    3 t_number    , value    25, ""
   10 t_newline   , value     0, ""
    0 t_end       , value     0, ""
    0 t_end       , value     0, ""
ERR


# recursive includes
t_compile_module($init, <<'END', $objs);
	int i, j;
	
	for ( j = 0; j < 2; j++ )
	{
		for ( i = 1; i < argc; i++ )
		{
			warn("Scan file \"%s\"\n", argv[i] );
			scan_file( argv[i] );
			get_tokens( NULL, 4, FALSE );
			warn("\n");
		}
	}
END

t_run_module( [ asm1_file(), asm2_file(), asm3_file(), asm4_file() ], '', <<'ERR', 1); 
Scan file "test1.asm"
    0 t_end       , value     0, ""
    0 t_end       , value     0, ""

Scan file "test2.asm"
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
   10 t_newline   , value     0, ""
   33 t_exclam    , value     0, ""

Scan file "test3.asm"
   10 t_newline   , value     0, ""
   33 t_exclam    , value     0, ""
   35 t_hash      , value     0, ""
   36 t_dollar    , value     0, ""

Scan file "test4.asm"
    4 t_string    , value     0, "Very long number token"
    3 t_number    , value 12345, ""
   10 t_newline   , value     0, ""
   37 t_percent   , value     0, ""

Scan file "test1.asm"
   38 t_and       , value     0, ""
   40 t_lparen    , value     0, ""
   41 t_rparen    , value     0, ""
   42 t_star      , value     0, ""

Scan file "test2.asm"
Error at file 'test3.asm' line 2: cannot include file 'test2.asm' recursively
Uncaught runtime exception at errors.c(1)
ERR



# test file stack and line numbers
write_file(asm1_file(), {binmode => ':raw'}, "A\nB\rC\r\nD\n\rE");
write_file(asm2_file(), {binmode => ':raw'}, "A\nB\rC\r\nD\n\rE\n");
write_file(asm3_file(), {binmode => ':raw'}, "A\nB\rC\r\nD\n\rE\r");
write_file(asm4_file(), {binmode => ':raw'}, "A\nB\rC\r\nD\n\rE\r\n");
write_file(asm5_file(), {binmode => ':raw'}, "A\nB\rC\r\nD\n\rE\n\r");
write_file(asm6_file(), {binmode => ':raw'}, "ABCDEFGHIJ\nabcdefghij\n");
write_file(asm7_file(), {binmode => ':raw'}, "");

t_compile_module($init, <<'END', $objs);
	char *files[] = {"test1.asm", "test2.asm", "test3.asm", "test4.asm", 
					 "test5.asm", "test6.asm", "test7.asm", NULL};
	int i;
	char *text;
	
	if (argc == 2 && strcmp(argv[1], "-C") == 0) opts.line_mode = TRUE;
	if (argc == 2 && strcmp(argv[1], "-l") == 0) opts.list = opts.cur_list = TRUE;
	
	i = 0;
	warn("Scan %s\n", files[i] );
	scan_file( files[i++] );
	
	while ( text = get_line() )
	{
		warn_option_deprecated("");
		dump_string(text);
		warn("\n");
		
		if (files[i]) 
		{
			warn("Scan %s\n", files[i] );
			scan_file( files[i++] );
		}
	}
	
END

t_run_module([], '', <<'ERR', 0);
Scan test1.asm
Warning at file 'test1.asm' line 1: option '' is deprecated
"A<0A>"
Scan test2.asm
Warning at file 'test2.asm' line 1: option '' is deprecated
"A<0A>"
Scan test3.asm
Warning at file 'test3.asm' line 1: option '' is deprecated
"A<0A>"
Scan test4.asm
Warning at file 'test4.asm' line 1: option '' is deprecated
"A<0A>"
Scan test5.asm
Warning at file 'test5.asm' line 1: option '' is deprecated
"A<0A>"
Scan test6.asm
Warning at file 'test6.asm' line 1: option '' is deprecated
"ABCDEFGHIJ<0A>"
Scan test7.asm
Warning at file 'test6.asm' line 2: option '' is deprecated
"abcdefghij<0A>"
Warning at file 'test5.asm' line 2: option '' is deprecated
"B<0A>"
Warning at file 'test5.asm' line 3: option '' is deprecated
"C<0A>"
Warning at file 'test5.asm' line 4: option '' is deprecated
"D<0A>"
Warning at file 'test5.asm' line 5: option '' is deprecated
"E<0A>"
Warning at file 'test4.asm' line 2: option '' is deprecated
"B<0A>"
Warning at file 'test4.asm' line 3: option '' is deprecated
"C<0A>"
Warning at file 'test4.asm' line 4: option '' is deprecated
"D<0A>"
Warning at file 'test4.asm' line 5: option '' is deprecated
"E<0A>"
Warning at file 'test3.asm' line 2: option '' is deprecated
"B<0A>"
Warning at file 'test3.asm' line 3: option '' is deprecated
"C<0A>"
Warning at file 'test3.asm' line 4: option '' is deprecated
"D<0A>"
Warning at file 'test3.asm' line 5: option '' is deprecated
"E<0A>"
Warning at file 'test2.asm' line 2: option '' is deprecated
"B<0A>"
Warning at file 'test2.asm' line 3: option '' is deprecated
"C<0A>"
Warning at file 'test2.asm' line 4: option '' is deprecated
"D<0A>"
Warning at file 'test2.asm' line 5: option '' is deprecated
"E<0A>"
Warning at file 'test1.asm' line 2: option '' is deprecated
"B<0A>"
Warning at file 'test1.asm' line 3: option '' is deprecated
"C<0A>"
Warning at file 'test1.asm' line 4: option '' is deprecated
"D<0A>"
Warning at file 'test1.asm' line 5: option '' is deprecated
"E<0A>"
ERR

t_run_module(['-l'], '', <<'ERR', 0);
Scan test1.asm
0000 test1.asm            1 A
Warning at file 'test1.asm' line 1: option '' is deprecated
"A<0A>"
Scan test2.asm
0000 test2.asm            1 A
Warning at file 'test2.asm' line 1: option '' is deprecated
"A<0A>"
Scan test3.asm
0000 test3.asm            1 A
Warning at file 'test3.asm' line 1: option '' is deprecated
"A<0A>"
Scan test4.asm
0000 test4.asm            1 A
Warning at file 'test4.asm' line 1: option '' is deprecated
"A<0A>"
Scan test5.asm
0000 test5.asm            1 A
Warning at file 'test5.asm' line 1: option '' is deprecated
"A<0A>"
Scan test6.asm
0000 test6.asm            1 ABCDEFGHIJ
Warning at file 'test6.asm' line 1: option '' is deprecated
"ABCDEFGHIJ<0A>"
Scan test7.asm
0000 test6.asm            2 abcdefghij
Warning at file 'test6.asm' line 2: option '' is deprecated
"abcdefghij<0A>"
0000 test5.asm            2 B
Warning at file 'test5.asm' line 2: option '' is deprecated
"B<0A>"
0000 test5.asm            3 C
Warning at file 'test5.asm' line 3: option '' is deprecated
"C<0A>"
0000 test5.asm            4 D
Warning at file 'test5.asm' line 4: option '' is deprecated
"D<0A>"
0000 test5.asm            5 E
Warning at file 'test5.asm' line 5: option '' is deprecated
"E<0A>"
0000 test4.asm            2 B
Warning at file 'test4.asm' line 2: option '' is deprecated
"B<0A>"
0000 test4.asm            3 C
Warning at file 'test4.asm' line 3: option '' is deprecated
"C<0A>"
0000 test4.asm            4 D
Warning at file 'test4.asm' line 4: option '' is deprecated
"D<0A>"
0000 test4.asm            5 E
Warning at file 'test4.asm' line 5: option '' is deprecated
"E<0A>"
0000 test3.asm            2 B
Warning at file 'test3.asm' line 2: option '' is deprecated
"B<0A>"
0000 test3.asm            3 C
Warning at file 'test3.asm' line 3: option '' is deprecated
"C<0A>"
0000 test3.asm            4 D
Warning at file 'test3.asm' line 4: option '' is deprecated
"D<0A>"
0000 test3.asm            5 E
Warning at file 'test3.asm' line 5: option '' is deprecated
"E<0A>"
0000 test2.asm            2 B
Warning at file 'test2.asm' line 2: option '' is deprecated
"B<0A>"
0000 test2.asm            3 C
Warning at file 'test2.asm' line 3: option '' is deprecated
"C<0A>"
0000 test2.asm            4 D
Warning at file 'test2.asm' line 4: option '' is deprecated
"D<0A>"
0000 test2.asm            5 E
Warning at file 'test2.asm' line 5: option '' is deprecated
"E<0A>"
0000 test1.asm            2 B
Warning at file 'test1.asm' line 2: option '' is deprecated
"B<0A>"
0000 test1.asm            3 C
Warning at file 'test1.asm' line 3: option '' is deprecated
"C<0A>"
0000 test1.asm            4 D
Warning at file 'test1.asm' line 4: option '' is deprecated
"D<0A>"
0000 test1.asm            5 E
Warning at file 'test1.asm' line 5: option '' is deprecated
"E<0A>"
ERR

t_run_module(['-C'], '', <<'ERR', 0);
Scan test1.asm
Warning at file 'test1.asm': option '' is deprecated
"A<0A>"
Scan test2.asm
Warning at file 'test2.asm': option '' is deprecated
"A<0A>"
Scan test3.asm
Warning at file 'test3.asm': option '' is deprecated
"A<0A>"
Scan test4.asm
Warning at file 'test4.asm': option '' is deprecated
"A<0A>"
Scan test5.asm
Warning at file 'test5.asm': option '' is deprecated
"A<0A>"
Scan test6.asm
Warning at file 'test6.asm': option '' is deprecated
"ABCDEFGHIJ<0A>"
Scan test7.asm
Warning at file 'test6.asm': option '' is deprecated
"abcdefghij<0A>"
Warning at file 'test5.asm': option '' is deprecated
"B<0A>"
Warning at file 'test5.asm': option '' is deprecated
"C<0A>"
Warning at file 'test5.asm': option '' is deprecated
"D<0A>"
Warning at file 'test5.asm': option '' is deprecated
"E<0A>"
Warning at file 'test4.asm': option '' is deprecated
"B<0A>"
Warning at file 'test4.asm': option '' is deprecated
"C<0A>"
Warning at file 'test4.asm': option '' is deprecated
"D<0A>"
Warning at file 'test4.asm': option '' is deprecated
"E<0A>"
Warning at file 'test3.asm': option '' is deprecated
"B<0A>"
Warning at file 'test3.asm': option '' is deprecated
"C<0A>"
Warning at file 'test3.asm': option '' is deprecated
"D<0A>"
Warning at file 'test3.asm': option '' is deprecated
"E<0A>"
Warning at file 'test2.asm': option '' is deprecated
"B<0A>"
Warning at file 'test2.asm': option '' is deprecated
"C<0A>"
Warning at file 'test2.asm': option '' is deprecated
"D<0A>"
Warning at file 'test2.asm': option '' is deprecated
"E<0A>"
Warning at file 'test1.asm': option '' is deprecated
"B<0A>"
Warning at file 'test1.asm': option '' is deprecated
"C<0A>"
Warning at file 'test1.asm': option '' is deprecated
"D<0A>"
Warning at file 'test1.asm': option '' is deprecated
"E<0A>"
ERR



unlink_testfiles();
done_testing;


# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-scan.t,v 1.33 2014-01-11 01:29:46 pauloscustodio Exp $
# $Log: whitebox-scan.t,v $
# Revision 1.33  2014-01-11 01:29:46  pauloscustodio
# Extend copyright to 2014.
# Move CVS log to bottom of file.
#
# Revision 1.32  2014/01/11 00:10:40  pauloscustodio
# Astyle - format C code
# Add -Wall option to CFLAGS, remove all warnings
#
# Revision 1.31  2014/01/10 00:15:27  pauloscustodio
# Use Str instead of glib, List instead of GSList.
# Use init.h mechanism, no need for main() calling init_scan.
# glib dependency removed from code and Makefile
#
# Revision 1.30  2014/01/06 00:33:36  pauloscustodio
# Use init.h mechanism, no need for main() calling init_errors
# and atexit(fini_errors); use Str and StrHash instead of glib.
#
# Revision 1.29  2014/01/02 17:18:17  pauloscustodio
# StrList removed, replaced by List
#
# Revision 1.28  2014/01/01 21:23:48  pauloscustodio
# Move generic file utility functions to lib/fileutil.c
#
# Revision 1.27  2013/12/30 02:05:34  pauloscustodio
# Merge dynstr.c and safestr.c into lib/strutil.c; the new Str type
# handles both dynamically allocated strings and fixed-size strings.
# Replaced g_strchomp by chomp by; g_ascii_tolower by tolower;
# g_ascii_toupper by toupper; g_ascii_strcasecmp by stricompare.
#
# Revision 1.26  2013/12/26 23:42:28  pauloscustodio
# Replace StringList from strutil by StrList in new strlis.c, to keep lists of strings (e.g. directory search paths)
#
# Revision 1.25  2013/12/25 14:39:50  pauloscustodio
# Move strutil.c to the z80asm/lib directory
#
# Revision 1.24  2013/12/18 23:05:52  pauloscustodio
# Move class.c to the z80asm/lib directory
#
# Revision 1.23  2013/12/15 13:18:35  pauloscustodio
# Move memory allocation routines to lib/xmalloc, instead of glib,
# introduce memory leak report on exit and memory fence check.
#
# Revision 1.22  2013/11/11 23:47:04  pauloscustodio
# Move source code generation tools to dev/Makefile, only called on request,
# and keep the generated files in z80asm directory, so that build does
# not require tools used for the code generation (ragel, perl).
# Remove code generation for structs - use CLASS macro instead.
#
# Revision 1.21  2013/10/16 21:42:07  pauloscustodio
# Allocate minimum-sized string, grow as needed.
# Allocate a GString text inside of File, to be used by file reading methods.
#
# Revision 1.20  2013/10/15 23:24:33  pauloscustodio
# Move reading by lines or tokens and file reading interface to scan.rl
# to decouple file.c from scan.c.
# Add singleton interface to scan to be used by parser.
#
# Revision 1.19  2013/10/08 21:53:07  pauloscustodio
# Replace Flex-based lexer by a Ragel-based one.
# Add interface to file.c to read files by tokens, calling the lexer.
#
# Revision 1.18  2013/10/05 08:14:43  pauloscustodio
# Parse command line options via look-up tables:
# -C, --line-mode
#
# Revision 1.17  2013/10/01 23:23:53  pauloscustodio
# Parse command line options via look-up tables:
# -l, --list
# -nl, --no-list
#
# Revision 1.16  2013/09/24 00:05:36  pauloscustodio
#
# Revision 1.15  2013/09/23 23:14:10  pauloscustodio
# Renamed SzList to StringList, simplified interface by assuming that
# list lives in memory util program ends; it is used for directory searches
# only. Moved interface to strutil.c, removed strlist.c.
#
# Revision 1.14  2013/09/22 21:04:22  pauloscustodio
# New File and FileStack objects
#
# Revision 1.13  2013/09/09 00:20:45  pauloscustodio
# Add default set of modules to t_compile_module:
# -DMEMALLOC_DEBUG xmalloc.c die.o except.o strpool.o
#
# Revision 1.12  2013/09/08 08:29:21  pauloscustodio
# Replaced xmalloc et al with glib functions
#
# Revision 1.11  2013/09/08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.10  2013/09/01 17:28:48  pauloscustodio
# Change in test output due to xmalloc change.
#
# Revision 1.9  2013/09/01 11:52:55  pauloscustodio
# Setup xmalloc on init.c.
# Setup GLib memory allocation functions to use xmalloc functions.
#
# Revision 1.8  2013/09/01 00:18:30  pauloscustodio
# - Replaced e4c exception mechanism by a much simpler one based on a few
#   macros. The former did not allow an exit(1) to be called within a
#   try-catch block.
#
# Revision 1.7  2013/05/12 19:20:34  pauloscustodio
# warnings
#
# Revision 1.6  2013/05/01 19:03:46  pauloscustodio
# Simplified scanner and adapted to be used with a BISON generated parser.
# Removed balanced struct checking and token ring.
# Removed start condition to list assembly lines, as it was difficult to keep in sync across included
# files; inserted an RS char in the input before each line to trigger listing.
# Allow ".NAME" and "NAME:" to return a NAME token, so that ".LD" is recognized as a label and not the LD assembly statement.
# Added Integer out of range warning to number scanning routine.
# Allow input lines to be any size, as long as memory can be allocated.
# Created a skeleton BISON parser.
#
# Revision 1.5  2013/04/14 20:47:27  pauloscustodio
# TOK_LABEL for a label definition, i.e. ".NAME" or "NAME:", with no spaces between symbols
# colon to separate assembly statements in a line needs spaces.
#
# Revision 1.4  2013/04/14 18:17:00  pauloscustodio
# Split scanner in several modules, allow token look-ahead to simplify
# parser.
#
# Revision 1.3  2013/04/09 20:56:51  pauloscustodio
# TOK_LABEL removed - identifying a label as XXX: has to be a parsing action in order to
# distinguish a label from a continuation statement, e.g.
# LABEL: ld a,VALUE : inc a ; LABEL is label, VALUE is name
#
# Revision 1.2  2013/03/31 18:28:30  pauloscustodio
# New TOK_LABEL for a label definition, i.e. ". NAME" or "NAME :"
#
# Revision 1.1  2013/03/29 23:53:08  pauloscustodio
# Added GNU Flex-based scanner. Not yet integrated into assembler.
