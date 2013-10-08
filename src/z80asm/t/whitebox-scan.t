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
# Test scan.rl

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

my $objs = "scan.o errors.o file.o init_obj.o init_obj_file.o class.o safestr.o strutil.o options.o hist.o";

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
char *CreateLibfile( char *filename ) {}
char *GetLibfile( char *filename ) {}
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

void get_tokens( ScanState *scan, int n )
{
	enum token token;
	int count_end = 0;
	int pos;

	while ( n-- != 0 && count_end < 2 )
	{
		pos = get_scan_pos( scan );
		token = get_token( scan );
		warn("%5d: %5d %-12s, value %5d, \"%s\"\n", 
			 pos, 
			 token, decode_token(token), 
			 last_token_num, last_token_str->str );
		if ( ! token ) count_end++;
	}
}

END

t_compile_module($init, <<'END', $objs);
	GString *input;
	ScanState scan;
	int i, c;
	FILE *fp;
	
	init_scan(); atexit(fini_scan);
	
	input = g_string_new("");
	
	/* scan each argv */
	for ( i = 1; i < argc; i++ )
	{
		fp = fopen( argv[i], "rb" );
		if ( fp ) 
		{
			warn("Scan file \"%s\"\n", argv[i] );
			g_string_truncate( input, 0 );
			while ( (c = fgetc(fp)) != EOF )
				g_string_append_c( input, c );
			
			/* scan it */
			start_scan( &scan, input );
			get_tokens( &scan, -1 );
			warn("\n");
		
			fclose( fp );
		}
	}
	
	warn("Test insert_to_scan\n");
	g_string_assign( input, "start:ld a,25\n");
	warn("Text: %s", input->str );
	start_scan( &scan, input );
	get_tokens( &scan, 4 );
	insert_to_scan( &scan, "2*" );
	warn("New text: %s", input->str );
	get_tokens( &scan, -1 );
	
	warn("Set scan pos to before start\n");
	set_scan_pos( &scan, -1 );
	get_tokens( &scan, -1 );
	
	warn("Set scan pos to start\n");
	set_scan_pos( &scan, 0 );
	get_tokens( &scan, -1 );
	
	warn("Set scan pos to end\n");
	set_scan_pos( &scan, input->len );
	get_tokens( &scan, -1 );
	
	
	
	g_string_free( input, TRUE );

END

write_file(asm1_file(), "" );
write_file(asm2_file(), {binmode => ':raw'},
	"\n",
	join(" ", grep {! /[\"\';]/ } map {chr} 1..255)."\n",
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
.abc  .def ghi: .jkl:
 abc: .def ghi: .jkl:
.abc: .def ghi: .jkl:

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

t_run_module( [ asm1_file(), asm2_file(), asm3_file(), asm4_file() ], <<'OUT', <<'ERR', 0); 
GLib Memory statistics (successful operations):
 blocks of | allocated  | freed      | allocated  | freed      | n_bytes   
  n_bytes  | n_times by | n_times by | n_times by | n_times by | remaining 
           | malloc()   | free()     | realloc()  | realloc()  |           
===========|============|============|============|============|===========
         4 |          0 |          0 |          2 |          2 |         +0
         8 |          0 |          0 |          1 |          1 |         +0
        12 |          3 |          0 |          0 |          3 |         +0
        16 |          0 |          0 |          2 |          2 |         +0
        20 |          1 |          1 |          0 |          0 |         +0
        22 |          2 |          0 |          0 |          2 |         +0
        23 |          0 |          2 |          2 |          0 |         +0
        24 |          3 |          3 |          3 |          3 |         +0
        31 |          4 |          0 |          0 |          4 |         +0
        32 |          0 |          5 |          6 |          1 |         +0
        35 |          0 |          3 |          3 |          0 |         +0
        44 |          9 |          6 |          2 |          5 |         +0
        48 |          0 |          0 |          3 |          3 |         +0
        62 |          0 |          0 |          4 |          4 |         +0
        64 |          0 |          0 |          1 |          1 |         +0
        88 |          0 |          3 |          3 |          0 |         +0
       128 |          0 |          0 |          1 |          1 |         +0
       252 |          3 |          0 |          0 |          0 |       +756
       256 |          0 |          0 |          1 |          1 |         +0
       512 |          0 |          0 |          1 |          1 |         +0
      1016 |          1 |          0 |          0 |          0 |      +1016
      1024 |          0 |          0 |          1 |          1 |         +0
      2048 |          0 |          0 |          1 |          1 |         +0
   >  4096 |          0 |          1 |          5 |          4 |        ***
GLib Memory statistics (failing operations):
 --- none ---
Total bytes: allocated=134679, zero-initialized=1772 (1.32%), freed=132907 (98.68%), remaining=1772
OUT
Scan file "test1.asm"
    0:     0 t_end       , value     0, ""
    0:     0 t_end       , value     0, ""

Scan file "test2.asm"
    0:    10 t_newline   , value     0, ""
    1:    10 t_newline   , value     0, ""
   20:    33 t_exclam    , value     0, ""
   66:    35 t_hash      , value     0, ""
   68:    36 t_dollar    , value     0, ""
   70:    37 t_percent   , value     0, ""
   72:    38 t_and       , value     0, ""
   74:    40 t_lparen    , value     0, ""
   76:    41 t_rparen    , value     0, ""
   78:    42 t_star      , value     0, ""
   80:    43 t_plus      , value     0, ""
   82:    44 t_comma     , value     0, ""
   84:    45 t_minus     , value     0, ""
   86:    46 t_dot       , value     0, ""
   88:    47 t_slash     , value     0, ""
   90:     3 t_number    , value     0, ""
   92:     3 t_number    , value     1, ""
   94:     3 t_number    , value     2, ""
   96:     3 t_number    , value     3, ""
   98:     3 t_number    , value     4, ""
  100:     3 t_number    , value     5, ""
  102:     3 t_number    , value     6, ""
  104:     3 t_number    , value     7, ""
  106:     3 t_number    , value     8, ""
  108:     3 t_number    , value     9, ""
  110:    58 t_colon     , value     0, ""
  112:    60 t_lt        , value     0, ""
  114:    61 t_eq        , value     0, ""
  116:    62 t_gt        , value     0, ""
  118:    63 t_question  , value     0, ""
  120:    64 t_at        , value     0, ""
  122:     1 t_name      , value     0, "A"
  124:     1 t_name      , value     0, "B"
  126:     1 t_name      , value     0, "C"
  128:     1 t_name      , value     0, "D"
  130:     1 t_name      , value     0, "E"
  132:     1 t_name      , value     0, "F"
  134:     1 t_name      , value     0, "G"
  136:     1 t_name      , value     0, "H"
  138:     1 t_name      , value     0, "I"
  140:     1 t_name      , value     0, "J"
  142:     1 t_name      , value     0, "K"
  144:     1 t_name      , value     0, "L"
  146:     1 t_name      , value     0, "M"
  148:     1 t_name      , value     0, "N"
  150:     1 t_name      , value     0, "O"
  152:     1 t_name      , value     0, "P"
  154:     1 t_name      , value     0, "Q"
  156:     1 t_name      , value     0, "R"
  158:     1 t_name      , value     0, "S"
  160:     1 t_name      , value     0, "T"
  162:     1 t_name      , value     0, "U"
  164:     1 t_name      , value     0, "V"
  166:     1 t_name      , value     0, "W"
  168:     1 t_name      , value     0, "X"
  170:     1 t_name      , value     0, "Y"
  172:     1 t_name      , value     0, "Z"
  174:    91 t_lsquare   , value     0, ""
  176:    92 t_bslash    , value     0, ""
  178:    93 t_rsquare   , value     0, ""
  180:    94 t_caret     , value     0, ""
  182:     1 t_name      , value     0, "_"
  184:    96 t_bquote    , value     0, ""
  186:     1 t_name      , value     0, "A"
  188:     1 t_name      , value     0, "B"
  190:     1 t_name      , value     0, "C"
  192:     1 t_name      , value     0, "D"
  194:     1 t_name      , value     0, "E"
  196:     1 t_name      , value     0, "F"
  198:     1 t_name      , value     0, "G"
  200:     1 t_name      , value     0, "H"
  202:     1 t_name      , value     0, "I"
  204:     1 t_name      , value     0, "J"
  206:     1 t_name      , value     0, "K"
  208:     1 t_name      , value     0, "L"
  210:     1 t_name      , value     0, "M"
  212:     1 t_name      , value     0, "N"
  214:     1 t_name      , value     0, "O"
  216:     1 t_name      , value     0, "P"
  218:     1 t_name      , value     0, "Q"
  220:     1 t_name      , value     0, "R"
  222:     1 t_name      , value     0, "S"
  224:     1 t_name      , value     0, "T"
  226:     1 t_name      , value     0, "U"
  228:     1 t_name      , value     0, "V"
  230:     1 t_name      , value     0, "W"
  232:     1 t_name      , value     0, "X"
  234:     1 t_name      , value     0, "Y"
  236:     1 t_name      , value     0, "Z"
  238:   123 t_lcurly    , value     0, ""
  240:   124 t_vbar      , value     0, ""
  242:   125 t_rcurly    , value     0, ""
  244:   126 t_tilde     , value     0, ""
  246:    10 t_newline   , value     0, ""
  505:     0 t_end       , value     0, ""
  505:     0 t_end       , value     0, ""

Scan file "test3.asm"
    0:    10 t_newline   , value     0, ""
   26:    33 t_exclam    , value     0, ""
   27:    35 t_hash      , value     0, ""
   29:    36 t_dollar    , value     0, ""
   31:    37 t_percent   , value     0, ""
   33:    38 t_and       , value     0, ""
   35:    40 t_lparen    , value     0, ""
   37:    41 t_rparen    , value     0, ""
   39:    42 t_star      , value     0, ""
   41:    43 t_plus      , value     0, ""
   43:    44 t_comma     , value     0, ""
   45:    45 t_minus     , value     0, ""
   47:    46 t_dot       , value     0, ""
   49:    47 t_slash     , value     0, ""
   51:    58 t_colon     , value     0, ""
   53:    60 t_lt        , value     0, ""
   55:    61 t_eq        , value     0, ""
   57:    62 t_gt        , value     0, ""
   59:    63 t_question  , value     0, ""
   61:    64 t_at        , value     0, ""
   63:    91 t_lsquare   , value     0, ""
   65:    92 t_bslash    , value     0, ""
   67:    93 t_rsquare   , value     0, ""
   69:    94 t_caret     , value     0, ""
   71:    96 t_bquote    , value     0, ""
   73:   123 t_lcurly    , value     0, ""
   75:   124 t_vbar      , value     0, ""
   77:   125 t_rcurly    , value     0, ""
   79:   126 t_tilde     , value     0, ""
   81:    10 t_newline   , value     0, ""
   84:    10 t_newline   , value     0, ""
   86:    10 t_newline   , value     0, ""
  115: 15677 t_eq_eq     , value     0, ""
  117: 15422 t_lt_gt     , value     0, ""
  120:  8509 t_exclam_eq , value     0, ""
  123: 15421 t_lt_eq     , value     0, ""
  126: 15933 t_gt_eq     , value     0, ""
  129: 31868 t_vbar_vbar , value     0, ""
  132:  9766 t_and_and   , value     0, ""
  135: 15420 t_lt_lt     , value     0, ""
  138: 15934 t_gt_gt     , value     0, ""
  141: 10794 t_star_star , value     0, ""
  144:    10 t_newline   , value     0, ""
  147:    10 t_newline   , value     0, ""
  149:    10 t_newline   , value     0, ""
  158:     1 t_name      , value     0, "_ABC_123"
  166:     1 t_name      , value     0, "ABC_123"
  174:     3 t_number    , value   123, ""
  178:     1 t_name      , value     0, "_ABC_"
  183:    10 t_newline   , value     0, ""
  185:     1 t_name      , value     0, "ABC_123"
  192:     1 t_name      , value     0, "AF'"
  196:     1 t_name      , value     0, "B"
  198:     3 t_number    , value    99, ""
  201:     1 t_name      , value     0, "D"
  202:     3 t_number    , value   101, ""
  205:     1 t_name      , value     0, "AF'"
  208:    10 t_newline   , value     0, ""
  210:    10 t_newline   , value     0, ""
  212:    10 t_newline   , value     0, ""
  222:     2 t_label     , value     0, "ABC"
  226:    46 t_dot       , value     0, ""
  229:     1 t_name      , value     0, "DEF"
  232:     1 t_name      , value     0, "GHI"
  236:    58 t_colon     , value     0, ""
  237:    46 t_dot       , value     0, ""
  239:     1 t_name      , value     0, "JKL"
  242:    58 t_colon     , value     0, ""
  243:    10 t_newline   , value     0, ""
  245:     2 t_label     , value     0, "ABC"
  250:    46 t_dot       , value     0, ""
  252:     1 t_name      , value     0, "DEF"
  255:     1 t_name      , value     0, "GHI"
  259:    58 t_colon     , value     0, ""
  260:    46 t_dot       , value     0, ""
  262:     1 t_name      , value     0, "JKL"
  265:    58 t_colon     , value     0, ""
  266:    10 t_newline   , value     0, ""
  268:     2 t_label     , value     0, "ABC"
  273:    46 t_dot       , value     0, ""
  275:     1 t_name      , value     0, "DEF"
  278:     1 t_name      , value     0, "GHI"
  282:    58 t_colon     , value     0, ""
  283:    46 t_dot       , value     0, ""
  285:     1 t_name      , value     0, "JKL"
  288:    58 t_colon     , value     0, ""
  289:    10 t_newline   , value     0, ""
  291:    10 t_newline   , value     0, ""
  293:    10 t_newline   , value     0, ""
  314:     3 t_number    , value     0, ""
  315:     3 t_number    , value 2147483647, ""
Warning: integer '-2147483648' out of range
  326:     3 t_number    , value -2147483648, ""
  337:    10 t_newline   , value     0, ""
  339:    10 t_newline   , value     0, ""
  341:    10 t_newline   , value     0, ""
  361:     3 t_number    , value     0, ""
  368:     3 t_number    , value     3, ""
  376:     3 t_number    , value 2147483647, ""
  412:    10 t_newline   , value     0, ""
  414:     3 t_number    , value     0, ""
  420:     3 t_number    , value     3, ""
  428:     3 t_number    , value 2147483647, ""
  464:    10 t_newline   , value     0, ""
  466:     3 t_number    , value     0, ""
  472:     3 t_number    , value     3, ""
  480:     3 t_number    , value 2147483647, ""
  516:    10 t_newline   , value     0, ""
  518:     3 t_number    , value     0, ""
  524:     3 t_number    , value     3, ""
  532:     3 t_number    , value 2147483647, ""
  568:    10 t_newline   , value     0, ""
  570:     3 t_number    , value     0, ""
  577:     3 t_number    , value     3, ""
  585:     3 t_number    , value 2147483647, ""
  621:    10 t_newline   , value     0, ""
  623:     3 t_number    , value     0, ""
  630:     3 t_number    , value     3, ""
  638:     3 t_number    , value 2147483647, ""
  674:    10 t_newline   , value     0, ""
  676:     3 t_number    , value     1, ""
  680:     3 t_number    , value     8, ""
  688:     3 t_number    , value   128, ""
  700:     3 t_number    , value  2048, ""
  717:     3 t_number    , value 32768, ""
  737:     3 t_number    , value 524288, ""
  761:    10 t_newline   , value     0, ""
  763:     3 t_number    , value 8388608, ""
  790:     3 t_number    , value 134217728, ""
  822:    10 t_newline   , value     0, ""
Warning: integer '-2147483648' out of range
  825:     3 t_number    , value -2147483648, ""
Warning: integer '-2147483648' out of range
  860:     3 t_number    , value     0, ""
  897:    10 t_newline   , value     0, ""
  899:    10 t_newline   , value     0, ""
  901:    10 t_newline   , value     0, ""
  926:     3 t_number    , value     0, ""
  930:     3 t_number    , value    10, ""
  934:     3 t_number    , value    15, ""
  938:     3 t_number    , value 2147483647, ""
  950:    10 t_newline   , value     0, ""
  952:     3 t_number    , value     0, ""
  955:     3 t_number    , value    10, ""
  960:     3 t_number    , value    15, ""
  964:     3 t_number    , value 2147483647, ""
  975:    10 t_newline   , value     0, ""
  978:     3 t_number    , value     0, ""
  981:     3 t_number    , value    10, ""
  986:     3 t_number    , value    15, ""
  990:     3 t_number    , value 2147483647, ""
 1001:    10 t_newline   , value     0, ""
 1003:     3 t_number    , value     0, ""
 1006:     3 t_number    , value    10, ""
 1011:     3 t_number    , value    15, ""
 1015:     3 t_number    , value 2147483647, ""
 1026:    10 t_newline   , value     0, ""
 1028:    10 t_newline   , value     0, ""
 1030:     4 t_string    , value     0, "strings - single-quote"
 1054:    10 t_newline   , value     0, ""
Error: invalid single quoted character
 1056:    10 t_newline   , value     0, ""
Error: invalid single quoted character
 1059:    10 t_newline   , value     0, ""
Error: invalid single quoted character
 1063:    10 t_newline   , value     0, ""
 1067:     3 t_number    , value    97, ""
 1070:    10 t_newline   , value     0, ""
Error: invalid single quoted character
 1072:    10 t_newline   , value     0, ""
 1078:    10 t_newline   , value     0, ""
 1080:     4 t_string    , value     0, "strings - double-quotes"
 1105:    10 t_newline   , value     0, ""
Error: unclosed quoted string
 1107:    10 t_newline   , value     0, ""
Error: unclosed quoted string
 1110:    10 t_newline   , value     0, ""
 1114:     4 t_string    , value     0, ""
 1116:    10 t_newline   , value     0, ""
 1118:     4 t_string    , value     0, "a"
 1121:    10 t_newline   , value     0, ""
 1123:     4 t_string    , value     0, "aa"
 1127:    10 t_newline   , value     0, ""
 1129:    10 t_newline   , value     0, ""
 1131:     0 t_end       , value     0, ""
 1131:     0 t_end       , value     0, ""

Scan file "test4.asm"
    0:     4 t_string    , value     0, "Very long number token"
   24:     3 t_number    , value 12345, ""
32798:    10 t_newline   , value     0, ""
32800:     0 t_end       , value     0, ""
32800:     0 t_end       , value     0, ""

Test insert_to_scan
Text: start:ld a,25
    0:     2 t_label     , value     0, "START"
    6:     1 t_name      , value     0, "LD"
    8:     1 t_name      , value     0, "A"
   10:    44 t_comma     , value     0, ""
New text: start:ld a, 2* 25
   11:     3 t_number    , value     2, ""
   13:    42 t_star      , value     0, ""
   14:     3 t_number    , value    25, ""
   17:    10 t_newline   , value     0, ""
   18:     0 t_end       , value     0, ""
   18:     0 t_end       , value     0, ""
Set scan pos to before start
    0:     2 t_label     , value     0, "START"
    6:     1 t_name      , value     0, "LD"
    8:     1 t_name      , value     0, "A"
   10:    44 t_comma     , value     0, ""
   11:     3 t_number    , value     2, ""
   13:    42 t_star      , value     0, ""
   14:     3 t_number    , value    25, ""
   17:    10 t_newline   , value     0, ""
   18:     0 t_end       , value     0, ""
   18:     0 t_end       , value     0, ""
Set scan pos to start
    0:     2 t_label     , value     0, "START"
    6:     1 t_name      , value     0, "LD"
    8:     1 t_name      , value     0, "A"
   10:    44 t_comma     , value     0, ""
   11:     3 t_number    , value     2, ""
   13:    42 t_star      , value     0, ""
   14:     3 t_number    , value    25, ""
   17:    10 t_newline   , value     0, ""
   18:     0 t_end       , value     0, ""
   18:     0 t_end       , value     0, ""
Set scan pos to end
   18:     0 t_end       , value     0, ""
   18:     0 t_end       , value     0, ""
ERR

unlink_testfiles();
done_testing;


__END__
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-scan.t,v 1.19 2013-10-08 21:53:07 pauloscustodio Exp $
# $Log: whitebox-scan.t,v $
# Revision 1.19  2013-10-08 21:53:07  pauloscustodio
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
# Replaced chomp by g_strchomp; tolower by g_ascii_tolower;
# toupper by g_ascii_toupper; stricompare by g_ascii_strcasecmp.
# Removed normalize_eol.
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
# -DMEMALLOC_DEBUG memalloc.c die.o except.o strpool.o
#
# Revision 1.12  2013/09/08 08:29:21  pauloscustodio
# Replaced xmalloc et al with g_malloc0 et al.
#
# Revision 1.11  2013/09/08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.10  2013/09/01 17:28:48  pauloscustodio
# Change in test output due to memalloc change.
#
# Revision 1.9  2013/09/01 11:52:55  pauloscustodio
# Setup memalloc on init.c.
# Setup GLib memory allocation functions to use memalloc functions.
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
