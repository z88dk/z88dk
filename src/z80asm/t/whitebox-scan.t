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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-scan.t,v 1.6 2013-05-01 19:03:46 pauloscustodio Exp $
# $Log: whitebox-scan.t,v $
# Revision 1.6  2013-05-01 19:03:46  pauloscustodio
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
#
#
# Test scan.l

use Modern::Perl;
use Test::More;
use File::Path qw(make_path remove_tree);
require 't/test_utils.pl';

# test scan
my $objs = "scan.o scan_token.o scan_struct.o scan_context.o class.o die.o strutil.o safestr.o except.o errors.o dynstr.o strpool.o srcfile.o strhash.o strlist.o file.o";
ok ! system "make $objs parse.h";
my $compile = "-DMEMALLOC_DEBUG memalloc.c $objs";

# build list of case TOKEN: return "TOKEN" from parse.h
my @token_case;
for (read_file("parse.h")) {
	if (/enum yytokentype/ .. /\};/) {
		if (/^\s*([A-Z0-9_]+)\s*=\s*\d+/) {
			my $case = $1;
			next if $case =~ /^(?:NUMBER|STRING|NAME)$/;
			push @token_case, "\t\tcase $case: return \"$case\";\n";
		}
	}
}

my $init = <<'END_INIT'; $init =~ s/<TOKEN_CASE>/@token_case/;
#include "parse.h"

#define MAX_LINE	21000		/* we need 20000 for a very big token */

#define ERROR return __LINE__
#define ASSERT(expr) \
			if ( ! (expr) ) { \
				warn("TEST FAILED (%s) at file %s, line %d\n", \
					 #expr, __FILE__, __LINE__); \
				ERROR; \
			} \
			else

char *decode_token (int token, YYSTYPE *yylval)
{
	static char token_str[MAX_LINE];
	
	switch (token) {
		case 0:			return "NULL";
		case '\n':		return "'\\n'";
		case NUMBER: 	sprintf(token_str, "NUMBER %ld", yylval->lval); 
						return token_str;
		case STRING: 	sprintf(token_str, "STRING '%s'", yylval->sval); 
						xfree(yylval->sval);
						return token_str;
		case NAME:	 	sprintf(token_str, "NAME %s", yylval->sval); 
						xfree(yylval->sval);
						return token_str;
<TOKEN_CASE>
		default:
			if (token >= 32 && token < 127)
				sprintf(token_str, "'%c'", token);
			else
				sprintf(token_str, "token(%d)", token);
			return token_str;
	}
}

int next_token (void)
{
	int token;
	char *token_str;
	YYSTYPE yylval;
	
	token     = yylex(&yylval);
	token_str = decode_token(token, &yylval);
	
	warn( "Token: %s(%d) %s\n", 
		  scan_filename() ? scan_filename() : "", 
		  scan_line_nr(), 
		  token_str );
	
	return token;
}

void n_tokens (int n)
{
	int token;
	
	while ( n != 0 ) 
	{
		n--;
		token = next_token();
		if ( token == 0)
		{
			next_token();	/* get second null */
			break;
		}
	}
}

int clinemode = 0;
int listing = 1;

size_t
get_PC( void ) { return 0; }

void
list_start_line( size_t address, char *source_file, int source_line_nr, char *line ) 
{
	static char buffer[MAX_LINE];
	strcpy(buffer, line);
	chomp(buffer);
	fprintf( stderr, "List:%s:%d:%s\n", source_file, source_line_nr, buffer );
}

END_INIT

# create directories and files
make_path(qw( x1 x2 x3 ));
write_file('f0',    {binmode => ':raw'}, "F0 1\r\rF0 3\n\nF0 5\r\n\nF0 7\r\n\rF0 9\n\r\rF0 11\n\r\nF0 13");
write_file('x1/f0', {binmode => ':raw'}, "DUMMY NOT READ");
write_file('x1/f1', {binmode => ':raw'}, "F1 1\r\nF1 2\r\nF1 3\r");
write_file('x2/f1', {binmode => ':raw'}, "DUMMY NOT READ");

write_file('x2/f2', {binmode => ':raw'}, <<'END');
; sigle-character tokens
! # $ % & ( ) * + , - . / : < = > ? @ [ \ ] ^ ` { | } ~ 

; multiple-character tokens
== <> != <= >= || && << >> ** 

; names
_Abc_123 Abc_123 123_Abc_
Abc_123	af' bc'de'af'

; labels
.abc  . def : ghi
 abc: . def : ghi
.abc: . def : ghi

; numbers - decimal
0 2147483647 2147483648

; numbers - binary
  0000b   0011b    1111111111111111111111111111111b
 @0000   @0011    @1111111111111111111111111111111
 %0000   %0011    %1111111111111111111111111111111
0b0000  0b0011   0b1111111111111111111111111111111
@'----' @'--##'  @'###############################'
%'----' %'--##'  %'###############################'
@"----" @"--##"  @"###############################"
%"----" %"--##"  %"###############################"

; numbers - hexadecimal
  0h 0ah 0FH   7FFFFFFFh
 $0   $a  $F  $7FFFFFFF 
 #0   #a  #F  #7FFFFFFF
0x0  0xa 0xF 0x7FFFFFFF

; strings - single-quote
'''a''"'';';comment
'unclosed

; strings - double-quotes
"""a""'"";";comment
"unclosed

END

write_file('x3/f2', {binmode => ':raw'}, "DUMMY NOT READ");

# very long tokens, bigger than lex input buffer (16K)
write_file('x2/f3', {binmode => ':raw'}, 
			"ld a," . '0' x 20000 . "1\n" .
			"ld b," . '0' x 20000 . "1\n");

# test yy_input
t_compile_module($init, <<'END', $compile);
	int yy_input( char *buffer, size_t size );
	FILE *fp;
	int read, i, j;
	char buffer[16];
	
	for ( i = 1 ; 1 ; i++ )
	{
		sprintf( buffer, "test%d.asm", i );
		fp = fopen( buffer, "rb" );
		if ( fp == NULL )
			return 0;
		fclose( fp );
			
		warn("Read file %s:\n", buffer );
		scan_file( buffer );
		
		while ( (read = yy_input( buffer, sizeof(buffer))) > 0 )
		{
			for ( j = 0; j < read ; j++ )
			{
				if ( buffer[j] > ' ' )
					warn("%c", buffer[j] );
				else
					warn("<%02X>", buffer[j] );
			}
			warn("\n");
		}
		n_tokens( -1 );
		
	}
	return 0;

END

write_file(asm1_file(), {binmode => ':raw'}, "");
write_file(asm2_file(), {binmode => ':raw'}, "A\nB\rC\r\nD\n\rE");
write_file(asm3_file(), {binmode => ':raw'}, "A\nB\rC\r\nD\n\rE\n");
write_file(asm4_file(), {binmode => ':raw'}, "A\nB\rC\r\nD\n\rE\r");
write_file(asm5_file(), {binmode => ':raw'}, "A\nB\rC\r\nD\n\rE\r\n");
write_file(asm6_file(), {binmode => ':raw'}, "A\nB\rC\r\nD\n\rE\n\r");
write_file(asm7_file(), {binmode => ':raw'}, "0123456789abcd");
write_file(asm8_file(), {binmode => ':raw'}, "0123456789\n0123456789abcd");
write_file(asm9_file(), {binmode => ':raw'}, "0123456789abcde");
write_file(asm10_file(), {binmode => ':raw'}, "0123456789abcdef");
write_file(asm11_file(), {binmode => ':raw'}, "ld a," . '0' x 20 ."1 \n".
                                              "ld b," . '0' x 20 ."1 \n");

t_run_module([asm1_file()], '', <<'END', 0); 
Read file test1.asm:
memalloc: init
memalloc scan.c(3): alloc 28 bytes at ADDR_1
memalloc scan.c(2): alloc 40 bytes at ADDR_2
memalloc strpool.c(1): alloc 32 bytes at ADDR_3
memalloc strpool.c(2): alloc 36 bytes at ADDR_4
memalloc strpool.c(3): alloc 10 bytes at ADDR_5
memalloc strpool.c(4): alloc 44 bytes at ADDR_6
memalloc strpool.c(4): alloc 384 bytes at ADDR_7
memalloc scan.c(1): alloc 48 bytes at ADDR_8
memalloc dynstr.c(1): alloc 40 bytes at ADDR_9
memalloc dynstr.c(3): alloc 256 bytes at ADDR_10
memalloc scan.c(2): alloc 12 bytes at ADDR_11
memalloc scan.c(4): alloc 48 bytes at ADDR_12
memalloc scan.c(4): alloc 16386 bytes at ADDR_13
memalloc scan.c(4): alloc 4 bytes at ADDR_14
memalloc scan.c(6): free 16386 bytes at ADDR_13 allocated at scan.c(4)
memalloc scan.c(6): free 48 bytes at ADDR_12 allocated at scan.c(4)
memalloc scan.c(2): free 12 bytes at ADDR_11 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_10 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_9 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_8 allocated at scan.c(1)
Token: (0) NULL
Token: (0) NULL
Read file test2.asm:
memalloc strpool.c(2): alloc 36 bytes at ADDR_15
memalloc strpool.c(3): alloc 10 bytes at ADDR_16
memalloc scan.c(1): alloc 48 bytes at ADDR_17
memalloc dynstr.c(1): alloc 40 bytes at ADDR_18
memalloc dynstr.c(3): alloc 256 bytes at ADDR_19
memalloc scan.c(2): alloc 12 bytes at ADDR_20
memalloc scan.c(4): alloc 48 bytes at ADDR_21
memalloc scan.c(4): alloc 16386 bytes at ADDR_22
memalloc scan.c(5): free 4 bytes at ADDR_14 allocated at scan.c(4)
memalloc scan.c(5): alloc 36 bytes at ADDR_23
<1E>A<0A><1E>B<0A><1E>C<0A><1E>D<0A><1E>E<0A>
memalloc scan.c(6): free 16386 bytes at ADDR_22 allocated at scan.c(4)
memalloc scan.c(6): free 48 bytes at ADDR_21 allocated at scan.c(4)
memalloc scan.c(2): free 12 bytes at ADDR_20 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_19 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_18 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_17 allocated at scan.c(1)
Token: (0) NULL
Token: (0) NULL
Read file test3.asm:
memalloc strpool.c(2): alloc 36 bytes at ADDR_24
memalloc strpool.c(3): alloc 10 bytes at ADDR_25
memalloc scan.c(1): alloc 48 bytes at ADDR_26
memalloc dynstr.c(1): alloc 40 bytes at ADDR_27
memalloc dynstr.c(3): alloc 256 bytes at ADDR_28
memalloc scan.c(2): alloc 12 bytes at ADDR_29
memalloc scan.c(4): alloc 48 bytes at ADDR_30
memalloc scan.c(4): alloc 16386 bytes at ADDR_31
<1E>A<0A><1E>B<0A><1E>C<0A><1E>D<0A><1E>E<0A>
memalloc scan.c(6): free 16386 bytes at ADDR_31 allocated at scan.c(4)
memalloc scan.c(6): free 48 bytes at ADDR_30 allocated at scan.c(4)
memalloc scan.c(2): free 12 bytes at ADDR_29 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_28 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_27 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_26 allocated at scan.c(1)
Token: (0) NULL
Token: (0) NULL
Read file test4.asm:
memalloc strpool.c(2): alloc 36 bytes at ADDR_32
memalloc strpool.c(3): alloc 10 bytes at ADDR_33
memalloc scan.c(1): alloc 48 bytes at ADDR_34
memalloc dynstr.c(1): alloc 40 bytes at ADDR_35
memalloc dynstr.c(3): alloc 256 bytes at ADDR_36
memalloc scan.c(2): alloc 12 bytes at ADDR_37
memalloc scan.c(4): alloc 48 bytes at ADDR_38
memalloc scan.c(4): alloc 16386 bytes at ADDR_39
<1E>A<0A><1E>B<0A><1E>C<0A><1E>D<0A><1E>E<0A>
memalloc scan.c(6): free 16386 bytes at ADDR_39 allocated at scan.c(4)
memalloc scan.c(6): free 48 bytes at ADDR_38 allocated at scan.c(4)
memalloc scan.c(2): free 12 bytes at ADDR_37 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_36 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_35 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_34 allocated at scan.c(1)
Token: (0) NULL
Token: (0) NULL
Read file test5.asm:
memalloc strpool.c(2): alloc 36 bytes at ADDR_40
memalloc strpool.c(3): alloc 10 bytes at ADDR_41
memalloc scan.c(1): alloc 48 bytes at ADDR_42
memalloc dynstr.c(1): alloc 40 bytes at ADDR_43
memalloc dynstr.c(3): alloc 256 bytes at ADDR_44
memalloc scan.c(2): alloc 12 bytes at ADDR_45
memalloc scan.c(4): alloc 48 bytes at ADDR_46
memalloc scan.c(4): alloc 16386 bytes at ADDR_47
<1E>A<0A><1E>B<0A><1E>C<0A><1E>D<0A><1E>E<0A>
memalloc scan.c(6): free 16386 bytes at ADDR_47 allocated at scan.c(4)
memalloc scan.c(6): free 48 bytes at ADDR_46 allocated at scan.c(4)
memalloc scan.c(2): free 12 bytes at ADDR_45 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_44 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_43 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_42 allocated at scan.c(1)
Token: (0) NULL
Token: (0) NULL
Read file test6.asm:
memalloc strpool.c(2): alloc 36 bytes at ADDR_48
memalloc strpool.c(3): alloc 10 bytes at ADDR_49
memalloc scan.c(1): alloc 48 bytes at ADDR_50
memalloc dynstr.c(1): alloc 40 bytes at ADDR_51
memalloc dynstr.c(3): alloc 256 bytes at ADDR_52
memalloc scan.c(2): alloc 12 bytes at ADDR_53
memalloc scan.c(4): alloc 48 bytes at ADDR_54
memalloc scan.c(4): alloc 16386 bytes at ADDR_55
<1E>A<0A><1E>B<0A><1E>C<0A><1E>D<0A><1E>E<0A>
memalloc scan.c(6): free 16386 bytes at ADDR_55 allocated at scan.c(4)
memalloc scan.c(6): free 48 bytes at ADDR_54 allocated at scan.c(4)
memalloc scan.c(2): free 12 bytes at ADDR_53 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_52 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_51 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_50 allocated at scan.c(1)
Token: (0) NULL
Token: (0) NULL
Read file test7.asm:
memalloc strpool.c(2): alloc 36 bytes at ADDR_56
memalloc strpool.c(3): alloc 10 bytes at ADDR_57
memalloc scan.c(1): alloc 48 bytes at ADDR_58
memalloc dynstr.c(1): alloc 40 bytes at ADDR_59
memalloc dynstr.c(3): alloc 256 bytes at ADDR_60
memalloc scan.c(2): alloc 12 bytes at ADDR_61
memalloc scan.c(4): alloc 48 bytes at ADDR_62
memalloc scan.c(4): alloc 16386 bytes at ADDR_63
<1E>0123456789abcd<0A>
memalloc scan.c(6): free 16386 bytes at ADDR_63 allocated at scan.c(4)
memalloc scan.c(6): free 48 bytes at ADDR_62 allocated at scan.c(4)
memalloc scan.c(2): free 12 bytes at ADDR_61 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_60 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_59 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_58 allocated at scan.c(1)
Token: (0) NULL
Token: (0) NULL
Read file test8.asm:
memalloc strpool.c(2): alloc 36 bytes at ADDR_64
memalloc strpool.c(3): alloc 10 bytes at ADDR_65
memalloc scan.c(1): alloc 48 bytes at ADDR_66
memalloc dynstr.c(1): alloc 40 bytes at ADDR_67
memalloc dynstr.c(3): alloc 256 bytes at ADDR_68
memalloc scan.c(2): alloc 12 bytes at ADDR_69
memalloc scan.c(4): alloc 48 bytes at ADDR_70
memalloc scan.c(4): alloc 16386 bytes at ADDR_71
<1E>0123456789<0A><1E>012
3456789abcd<0A>
memalloc scan.c(6): free 16386 bytes at ADDR_71 allocated at scan.c(4)
memalloc scan.c(6): free 48 bytes at ADDR_70 allocated at scan.c(4)
memalloc scan.c(2): free 12 bytes at ADDR_69 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_68 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_67 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_66 allocated at scan.c(1)
Token: (0) NULL
Token: (0) NULL
Read file test9.asm:
memalloc strpool.c(2): alloc 36 bytes at ADDR_72
memalloc strpool.c(3): alloc 10 bytes at ADDR_73
memalloc scan.c(1): alloc 48 bytes at ADDR_74
memalloc dynstr.c(1): alloc 40 bytes at ADDR_75
memalloc dynstr.c(3): alloc 256 bytes at ADDR_76
memalloc scan.c(2): alloc 12 bytes at ADDR_77
memalloc scan.c(4): alloc 48 bytes at ADDR_78
memalloc scan.c(4): alloc 16386 bytes at ADDR_79
<1E>0123456789abcde
<0A>
memalloc scan.c(6): free 16386 bytes at ADDR_79 allocated at scan.c(4)
memalloc scan.c(6): free 48 bytes at ADDR_78 allocated at scan.c(4)
memalloc scan.c(2): free 12 bytes at ADDR_77 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_76 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_75 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_74 allocated at scan.c(1)
Token: (0) NULL
Token: (0) NULL
Read file test10.asm:
memalloc strpool.c(2): alloc 36 bytes at ADDR_80
memalloc strpool.c(3): alloc 11 bytes at ADDR_81
memalloc scan.c(1): alloc 48 bytes at ADDR_82
memalloc dynstr.c(1): alloc 40 bytes at ADDR_83
memalloc dynstr.c(3): alloc 256 bytes at ADDR_84
memalloc scan.c(2): alloc 12 bytes at ADDR_85
memalloc scan.c(4): alloc 48 bytes at ADDR_86
memalloc scan.c(4): alloc 16386 bytes at ADDR_87
<1E>0123456789abcde
f<0A>
memalloc scan.c(6): free 16386 bytes at ADDR_87 allocated at scan.c(4)
memalloc scan.c(6): free 48 bytes at ADDR_86 allocated at scan.c(4)
memalloc scan.c(2): free 12 bytes at ADDR_85 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_84 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_83 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_82 allocated at scan.c(1)
Token: (0) NULL
Token: (0) NULL
Read file test11.asm:
memalloc strpool.c(2): alloc 36 bytes at ADDR_88
memalloc strpool.c(3): alloc 11 bytes at ADDR_89
memalloc scan.c(1): alloc 48 bytes at ADDR_90
memalloc dynstr.c(1): alloc 40 bytes at ADDR_91
memalloc dynstr.c(3): alloc 256 bytes at ADDR_92
memalloc scan.c(2): alloc 12 bytes at ADDR_93
memalloc scan.c(4): alloc 48 bytes at ADDR_94
memalloc scan.c(4): alloc 16386 bytes at ADDR_95
<1E>ld<20>a,0000000000
00000000001<20><0A><1E>ld
<20>b,0000000000000
00000001<20><0A>
memalloc scan.c(6): free 16386 bytes at ADDR_95 allocated at scan.c(4)
memalloc scan.c(6): free 48 bytes at ADDR_94 allocated at scan.c(4)
memalloc scan.c(2): free 12 bytes at ADDR_93 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_92 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_91 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_90 allocated at scan.c(1)
Token: (0) NULL
Token: (0) NULL
memalloc strpool.c(6): free 10 bytes at ADDR_5 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_4 allocated at strpool.c(2)
memalloc strpool.c(6): free 10 bytes at ADDR_16 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_15 allocated at strpool.c(2)
memalloc strpool.c(6): free 10 bytes at ADDR_25 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_24 allocated at strpool.c(2)
memalloc strpool.c(6): free 10 bytes at ADDR_33 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_32 allocated at strpool.c(2)
memalloc strpool.c(6): free 10 bytes at ADDR_41 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_40 allocated at strpool.c(2)
memalloc strpool.c(6): free 10 bytes at ADDR_49 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_48 allocated at strpool.c(2)
memalloc strpool.c(6): free 10 bytes at ADDR_57 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_56 allocated at strpool.c(2)
memalloc strpool.c(6): free 10 bytes at ADDR_65 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_64 allocated at strpool.c(2)
memalloc strpool.c(6): free 10 bytes at ADDR_73 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_72 allocated at strpool.c(2)
memalloc strpool.c(6): free 11 bytes at ADDR_81 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_80 allocated at strpool.c(2)
memalloc strpool.c(5): free 384 bytes at ADDR_7 allocated at strpool.c(4)
memalloc strpool.c(5): free 44 bytes at ADDR_6 allocated at strpool.c(4)
memalloc strpool.c(6): free 11 bytes at ADDR_89 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_88 allocated at strpool.c(2)
memalloc strpool.c(1): free 32 bytes at ADDR_3 allocated at strpool.c(1)
memalloc scan.c(6): free 36 bytes at ADDR_23 allocated at scan.c(5)
memalloc scan.c(3): free 28 bytes at ADDR_1 allocated at scan.c(3)
memalloc scan.c(2): free 40 bytes at ADDR_2 allocated at scan.c(2)
memalloc: cleanup
END


# tests without error catching
t_compile_module($init, <<'END', $compile);
	
	add_source_file_path("x1");
	add_source_file_path("x2");
	add_source_file_path("x3");
	
	warn("Test: Read before start\n");
	n_tokens( -1 );

	warn("Test: read f0\n");
	scan_file("f0");
	n_tokens( -1 );
	
	warn("Test: read f0 as text\n");
	scan_text("F0 1\r\rF0 3\n\nF0 5\r\n\nF0 7\r\n\rF0 9\n\r\rF0 11\n\r\nF0 13");
	n_tokens( -1 );
	
	warn("Test: read f1\n");
	scan_file("f1");
	n_tokens( -1 );
	
	warn("Test: push text once\n");
	scan_text(" \f \n \t \r 1 2 3 a b c \n ");
	n_tokens( -1 );
	
	warn("Test: push text twice\n");
	scan_text(" \f \n \t \r 1 2 3 a b c \n ");
	scan_text("defc c=2;hello\ndefc d=3;hello world\r\n");
	n_tokens( -1 );

	warn("Test: push text in middle of reading\n");
	scan_text(" \f \n \t \r 1 2 3 a b c \n ");
	n_tokens( 4 );

	scan_text("defc c=2;hello\ndefc d=3;hello world\r\n");
	n_tokens( -1 );

	warn("Test: open text file\n");
	scan_file("f0");
	n_tokens( 7 );
	
	scan_text("defc c=2;hello\ndefc d=3;hello world\r\n");
	n_tokens( 13 );
	
	scan_file("f1");
	n_tokens(1);
	n_tokens( -1 );

	scan_file("f2");
	n_tokens( -1 );

	scan_file("f3");
	n_tokens( -1 );

	return 0;
END

t_run_module([], '', <<'END', 0);
memalloc: init
memalloc strlist.c(1): alloc 36 bytes at ADDR_1
memalloc strpool.c(1): alloc 32 bytes at ADDR_2
memalloc strlist.c(3): alloc 12 bytes at ADDR_3
memalloc strpool.c(2): alloc 36 bytes at ADDR_4
memalloc strpool.c(3): alloc 3 bytes at ADDR_5
memalloc strpool.c(4): alloc 44 bytes at ADDR_6
memalloc strpool.c(4): alloc 384 bytes at ADDR_7
memalloc strlist.c(3): alloc 12 bytes at ADDR_8
memalloc strpool.c(2): alloc 36 bytes at ADDR_9
memalloc strpool.c(3): alloc 3 bytes at ADDR_10
memalloc strlist.c(3): alloc 12 bytes at ADDR_11
memalloc strpool.c(2): alloc 36 bytes at ADDR_12
memalloc strpool.c(3): alloc 3 bytes at ADDR_13
Test: Read before start
memalloc scan.c(2): alloc 40 bytes at ADDR_14
Token: (0) NULL
Token: (0) NULL
Test: read f0
memalloc scan.c(3): alloc 28 bytes at ADDR_15
memalloc strpool.c(2): alloc 36 bytes at ADDR_16
memalloc strpool.c(3): alloc 3 bytes at ADDR_17
memalloc scan.c(1): alloc 48 bytes at ADDR_18
memalloc dynstr.c(1): alloc 40 bytes at ADDR_19
memalloc dynstr.c(3): alloc 256 bytes at ADDR_20
memalloc scan.c(2): alloc 12 bytes at ADDR_21
memalloc scan.c(8): alloc 48 bytes at ADDR_22
memalloc scan.c(8): alloc 16386 bytes at ADDR_23
memalloc scan.c(8): alloc 4 bytes at ADDR_24
List:f0:1:F0 1
memalloc scan.c(4): alloc 3 bytes at ADDR_25
memalloc test.c(2): free 3 bytes at ADDR_25 allocated at scan.c(4)
Token: f0(1) NAME F0
Token: f0(1) NUMBER 1
Token: f0(1) '\n'
List:f0:2:
Token: f0(2) '\n'
List:f0:3:F0 3
memalloc scan.c(4): alloc 3 bytes at ADDR_26
memalloc test.c(2): free 3 bytes at ADDR_26 allocated at scan.c(4)
Token: f0(3) NAME F0
Token: f0(3) NUMBER 3
Token: f0(3) '\n'
List:f0:4:
Token: f0(4) '\n'
List:f0:5:F0 5
memalloc scan.c(4): alloc 3 bytes at ADDR_27
memalloc test.c(2): free 3 bytes at ADDR_27 allocated at scan.c(4)
Token: f0(5) NAME F0
Token: f0(5) NUMBER 5
Token: f0(5) '\n'
List:f0:6:
Token: f0(6) '\n'
List:f0:7:F0 7
memalloc scan.c(4): alloc 3 bytes at ADDR_28
memalloc test.c(2): free 3 bytes at ADDR_28 allocated at scan.c(4)
Token: f0(7) NAME F0
Token: f0(7) NUMBER 7
Token: f0(7) '\n'
List:f0:8:
Token: f0(8) '\n'
List:f0:9:F0 9
memalloc scan.c(4): alloc 3 bytes at ADDR_29
memalloc test.c(2): free 3 bytes at ADDR_29 allocated at scan.c(4)
Token: f0(9) NAME F0
Token: f0(9) NUMBER 9
Token: f0(9) '\n'
List:f0:10:
Token: f0(10) '\n'
List:f0:11:F0 11
memalloc scan.c(4): alloc 3 bytes at ADDR_30
memalloc test.c(2): free 3 bytes at ADDR_30 allocated at scan.c(4)
Token: f0(11) NAME F0
Token: f0(11) NUMBER 11
Token: f0(11) '\n'
List:f0:12:
Token: f0(12) '\n'
List:f0:13:F0 13
memalloc scan.c(4): alloc 3 bytes at ADDR_31
memalloc test.c(2): free 3 bytes at ADDR_31 allocated at scan.c(4)
Token: f0(13) NAME F0
Token: f0(13) NUMBER 13
Token: f0(13) '\n'
memalloc scan.c(10): free 16386 bytes at ADDR_23 allocated at scan.c(8)
memalloc scan.c(10): free 48 bytes at ADDR_22 allocated at scan.c(8)
memalloc scan.c(2): free 12 bytes at ADDR_21 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_20 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_19 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_18 allocated at scan.c(1)
Token: (0) NULL
Token: (0) NULL
Test: read f0 as text
memalloc scan.c(1): alloc 48 bytes at ADDR_32
memalloc dynstr.c(1): alloc 40 bytes at ADDR_33
memalloc dynstr.c(3): alloc 256 bytes at ADDR_34
memalloc scan.c(2): alloc 12 bytes at ADDR_35
memalloc scan.c(8): alloc 48 bytes at ADDR_36
memalloc scan.c(8): alloc 4 bytes at ADDR_37
memalloc scan.c(9): free 4 bytes at ADDR_24 allocated at scan.c(8)
memalloc scan.c(9): alloc 36 bytes at ADDR_38
memalloc scan.c(8): alloc 48 bytes at ADDR_39
memalloc scan.c(10): free 4 bytes at ADDR_37 allocated at scan.c(8)
memalloc scan.c(10): free 48 bytes at ADDR_36 allocated at scan.c(8)
memalloc scan.c(4): alloc 3 bytes at ADDR_40
memalloc test.c(2): free 3 bytes at ADDR_40 allocated at scan.c(4)
Token: (0) NAME F0
Token: (0) NUMBER 1
Token: (0) '\n'
Token: (0) '\n'
memalloc scan.c(4): alloc 3 bytes at ADDR_41
memalloc test.c(2): free 3 bytes at ADDR_41 allocated at scan.c(4)
Token: (0) NAME F0
Token: (0) NUMBER 3
Token: (0) '\n'
Token: (0) '\n'
memalloc scan.c(4): alloc 3 bytes at ADDR_42
memalloc test.c(2): free 3 bytes at ADDR_42 allocated at scan.c(4)
Token: (0) NAME F0
Token: (0) NUMBER 5
Token: (0) '\n'
Token: (0) '\n'
memalloc scan.c(4): alloc 3 bytes at ADDR_43
memalloc test.c(2): free 3 bytes at ADDR_43 allocated at scan.c(4)
Token: (0) NAME F0
Token: (0) NUMBER 7
Token: (0) '\n'
Token: (0) '\n'
memalloc scan.c(4): alloc 3 bytes at ADDR_44
memalloc test.c(2): free 3 bytes at ADDR_44 allocated at scan.c(4)
Token: (0) NAME F0
Token: (0) NUMBER 9
Token: (0) '\n'
Token: (0) '\n'
memalloc scan.c(4): alloc 3 bytes at ADDR_45
memalloc test.c(2): free 3 bytes at ADDR_45 allocated at scan.c(4)
Token: (0) NAME F0
Token: (0) NUMBER 11
Token: (0) '\n'
Token: (0) '\n'
memalloc scan.c(4): alloc 3 bytes at ADDR_46
memalloc test.c(2): free 3 bytes at ADDR_46 allocated at scan.c(4)
Token: (0) NAME F0
Token: (0) NUMBER 13
memalloc scan.c(10): free 48 bytes at ADDR_39 allocated at scan.c(8)
memalloc scan.c(2): free 12 bytes at ADDR_35 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_34 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_33 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_32 allocated at scan.c(1)
Token: (0) NULL
Token: (0) NULL
Test: read f1
memalloc strpool.c(2): alloc 36 bytes at ADDR_47
memalloc strpool.c(3): alloc 6 bytes at ADDR_48
memalloc scan.c(1): alloc 48 bytes at ADDR_49
memalloc dynstr.c(1): alloc 40 bytes at ADDR_50
memalloc dynstr.c(3): alloc 256 bytes at ADDR_51
memalloc scan.c(2): alloc 12 bytes at ADDR_52
memalloc scan.c(8): alloc 48 bytes at ADDR_53
memalloc scan.c(8): alloc 16386 bytes at ADDR_54
List:x1/f1:1:F1 1
memalloc scan.c(4): alloc 3 bytes at ADDR_55
memalloc test.c(2): free 3 bytes at ADDR_55 allocated at scan.c(4)
Token: x1/f1(1) NAME F1
Token: x1/f1(1) NUMBER 1
Token: x1/f1(1) '\n'
List:x1/f1:2:F1 2
memalloc scan.c(4): alloc 3 bytes at ADDR_56
memalloc test.c(2): free 3 bytes at ADDR_56 allocated at scan.c(4)
Token: x1/f1(2) NAME F1
Token: x1/f1(2) NUMBER 2
Token: x1/f1(2) '\n'
List:x1/f1:3:F1 3
memalloc scan.c(4): alloc 3 bytes at ADDR_57
memalloc test.c(2): free 3 bytes at ADDR_57 allocated at scan.c(4)
Token: x1/f1(3) NAME F1
Token: x1/f1(3) NUMBER 3
Token: x1/f1(3) '\n'
memalloc scan.c(10): free 16386 bytes at ADDR_54 allocated at scan.c(8)
memalloc scan.c(10): free 48 bytes at ADDR_53 allocated at scan.c(8)
memalloc scan.c(2): free 12 bytes at ADDR_52 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_51 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_50 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_49 allocated at scan.c(1)
Token: (0) NULL
Token: (0) NULL
Test: push text once
memalloc scan.c(1): alloc 48 bytes at ADDR_58
memalloc dynstr.c(1): alloc 40 bytes at ADDR_59
memalloc dynstr.c(3): alloc 256 bytes at ADDR_60
memalloc scan.c(2): alloc 12 bytes at ADDR_61
memalloc scan.c(8): alloc 48 bytes at ADDR_62
memalloc scan.c(8): alloc 4 bytes at ADDR_63
memalloc scan.c(8): alloc 48 bytes at ADDR_64
memalloc scan.c(10): free 4 bytes at ADDR_63 allocated at scan.c(8)
memalloc scan.c(10): free 48 bytes at ADDR_62 allocated at scan.c(8)
Token: (0) '\n'
Token: (0) '\n'
Token: (0) NUMBER 1
Token: (0) NUMBER 2
Token: (0) NUMBER 3
memalloc scan.c(4): alloc 2 bytes at ADDR_65
memalloc test.c(2): free 2 bytes at ADDR_65 allocated at scan.c(4)
Token: (0) NAME A
memalloc scan.c(4): alloc 2 bytes at ADDR_66
memalloc test.c(2): free 2 bytes at ADDR_66 allocated at scan.c(4)
Token: (0) NAME B
memalloc scan.c(4): alloc 2 bytes at ADDR_67
memalloc test.c(2): free 2 bytes at ADDR_67 allocated at scan.c(4)
Token: (0) NAME C
Token: (0) '\n'
memalloc scan.c(10): free 48 bytes at ADDR_64 allocated at scan.c(8)
memalloc scan.c(2): free 12 bytes at ADDR_61 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_60 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_59 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_58 allocated at scan.c(1)
Token: (0) NULL
Token: (0) NULL
Test: push text twice
memalloc scan.c(1): alloc 48 bytes at ADDR_68
memalloc dynstr.c(1): alloc 40 bytes at ADDR_69
memalloc dynstr.c(3): alloc 256 bytes at ADDR_70
memalloc scan.c(2): alloc 12 bytes at ADDR_71
memalloc scan.c(8): alloc 48 bytes at ADDR_72
memalloc scan.c(8): alloc 4 bytes at ADDR_73
memalloc scan.c(8): alloc 48 bytes at ADDR_74
memalloc scan.c(10): free 4 bytes at ADDR_73 allocated at scan.c(8)
memalloc scan.c(10): free 48 bytes at ADDR_72 allocated at scan.c(8)
memalloc scan.c(1): alloc 48 bytes at ADDR_75
memalloc dynstr.c(1): alloc 40 bytes at ADDR_76
memalloc dynstr.c(3): alloc 256 bytes at ADDR_77
memalloc scan.c(2): alloc 12 bytes at ADDR_78
memalloc scan.c(8): alloc 48 bytes at ADDR_79
memalloc scan.c(8): alloc 4 bytes at ADDR_80
memalloc scan.c(8): alloc 48 bytes at ADDR_81
memalloc scan.c(10): free 4 bytes at ADDR_80 allocated at scan.c(8)
memalloc scan.c(10): free 48 bytes at ADDR_79 allocated at scan.c(8)
memalloc scan.c(4): alloc 5 bytes at ADDR_82
memalloc test.c(2): free 5 bytes at ADDR_82 allocated at scan.c(4)
Token: (0) NAME DEFC
memalloc scan.c(4): alloc 2 bytes at ADDR_83
memalloc test.c(2): free 2 bytes at ADDR_83 allocated at scan.c(4)
Token: (0) NAME C
Token: (0) '='
Token: (0) NUMBER 2
Token: (0) '\n'
memalloc scan.c(4): alloc 5 bytes at ADDR_84
memalloc test.c(2): free 5 bytes at ADDR_84 allocated at scan.c(4)
Token: (0) NAME DEFC
memalloc scan.c(4): alloc 2 bytes at ADDR_85
memalloc test.c(2): free 2 bytes at ADDR_85 allocated at scan.c(4)
Token: (0) NAME D
Token: (0) '='
Token: (0) NUMBER 3
Token: (0) '\n'
memalloc scan.c(10): free 48 bytes at ADDR_81 allocated at scan.c(8)
memalloc scan.c(2): free 12 bytes at ADDR_78 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_77 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_76 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_75 allocated at scan.c(1)
Token: (0) '\n'
Token: (0) '\n'
Token: (0) NUMBER 1
Token: (0) NUMBER 2
Token: (0) NUMBER 3
memalloc scan.c(4): alloc 2 bytes at ADDR_86
memalloc test.c(2): free 2 bytes at ADDR_86 allocated at scan.c(4)
Token: (0) NAME A
memalloc scan.c(4): alloc 2 bytes at ADDR_87
memalloc test.c(2): free 2 bytes at ADDR_87 allocated at scan.c(4)
Token: (0) NAME B
memalloc scan.c(4): alloc 2 bytes at ADDR_88
memalloc test.c(2): free 2 bytes at ADDR_88 allocated at scan.c(4)
Token: (0) NAME C
Token: (0) '\n'
memalloc scan.c(10): free 48 bytes at ADDR_74 allocated at scan.c(8)
memalloc scan.c(2): free 12 bytes at ADDR_71 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_70 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_69 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_68 allocated at scan.c(1)
Token: (0) NULL
Token: (0) NULL
Test: push text in middle of reading
memalloc scan.c(1): alloc 48 bytes at ADDR_89
memalloc dynstr.c(1): alloc 40 bytes at ADDR_90
memalloc dynstr.c(3): alloc 256 bytes at ADDR_91
memalloc scan.c(2): alloc 12 bytes at ADDR_92
memalloc scan.c(8): alloc 48 bytes at ADDR_93
memalloc scan.c(8): alloc 4 bytes at ADDR_94
memalloc scan.c(8): alloc 48 bytes at ADDR_95
memalloc scan.c(10): free 4 bytes at ADDR_94 allocated at scan.c(8)
memalloc scan.c(10): free 48 bytes at ADDR_93 allocated at scan.c(8)
Token: (0) '\n'
Token: (0) '\n'
Token: (0) NUMBER 1
Token: (0) NUMBER 2
memalloc scan.c(1): alloc 48 bytes at ADDR_96
memalloc dynstr.c(1): alloc 40 bytes at ADDR_97
memalloc dynstr.c(3): alloc 256 bytes at ADDR_98
memalloc scan.c(2): alloc 12 bytes at ADDR_99
memalloc scan.c(8): alloc 48 bytes at ADDR_100
memalloc scan.c(8): alloc 4 bytes at ADDR_101
memalloc scan.c(8): alloc 48 bytes at ADDR_102
memalloc scan.c(10): free 4 bytes at ADDR_101 allocated at scan.c(8)
memalloc scan.c(10): free 48 bytes at ADDR_100 allocated at scan.c(8)
memalloc scan.c(4): alloc 5 bytes at ADDR_103
memalloc test.c(2): free 5 bytes at ADDR_103 allocated at scan.c(4)
Token: (0) NAME DEFC
memalloc scan.c(4): alloc 2 bytes at ADDR_104
memalloc test.c(2): free 2 bytes at ADDR_104 allocated at scan.c(4)
Token: (0) NAME C
Token: (0) '='
Token: (0) NUMBER 2
Token: (0) '\n'
memalloc scan.c(4): alloc 5 bytes at ADDR_105
memalloc test.c(2): free 5 bytes at ADDR_105 allocated at scan.c(4)
Token: (0) NAME DEFC
memalloc scan.c(4): alloc 2 bytes at ADDR_106
memalloc test.c(2): free 2 bytes at ADDR_106 allocated at scan.c(4)
Token: (0) NAME D
Token: (0) '='
Token: (0) NUMBER 3
Token: (0) '\n'
memalloc scan.c(10): free 48 bytes at ADDR_102 allocated at scan.c(8)
memalloc scan.c(2): free 12 bytes at ADDR_99 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_98 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_97 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_96 allocated at scan.c(1)
Token: (0) NUMBER 3
memalloc scan.c(4): alloc 2 bytes at ADDR_107
memalloc test.c(2): free 2 bytes at ADDR_107 allocated at scan.c(4)
Token: (0) NAME A
memalloc scan.c(4): alloc 2 bytes at ADDR_108
memalloc test.c(2): free 2 bytes at ADDR_108 allocated at scan.c(4)
Token: (0) NAME B
memalloc scan.c(4): alloc 2 bytes at ADDR_109
memalloc test.c(2): free 2 bytes at ADDR_109 allocated at scan.c(4)
Token: (0) NAME C
Token: (0) '\n'
memalloc scan.c(10): free 48 bytes at ADDR_95 allocated at scan.c(8)
memalloc scan.c(2): free 12 bytes at ADDR_92 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_91 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_90 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_89 allocated at scan.c(1)
Token: (0) NULL
Token: (0) NULL
Test: open text file
memalloc scan.c(1): alloc 48 bytes at ADDR_110
memalloc dynstr.c(1): alloc 40 bytes at ADDR_111
memalloc dynstr.c(3): alloc 256 bytes at ADDR_112
memalloc scan.c(2): alloc 12 bytes at ADDR_113
memalloc scan.c(8): alloc 48 bytes at ADDR_114
memalloc scan.c(8): alloc 16386 bytes at ADDR_115
List:f0:1:F0 1
memalloc scan.c(4): alloc 3 bytes at ADDR_116
memalloc test.c(2): free 3 bytes at ADDR_116 allocated at scan.c(4)
Token: f0(1) NAME F0
Token: f0(1) NUMBER 1
Token: f0(1) '\n'
List:f0:2:
Token: f0(2) '\n'
List:f0:3:F0 3
memalloc scan.c(4): alloc 3 bytes at ADDR_117
memalloc test.c(2): free 3 bytes at ADDR_117 allocated at scan.c(4)
Token: f0(3) NAME F0
Token: f0(3) NUMBER 3
Token: f0(3) '\n'
memalloc scan.c(1): alloc 48 bytes at ADDR_118
memalloc dynstr.c(1): alloc 40 bytes at ADDR_119
memalloc dynstr.c(3): alloc 256 bytes at ADDR_120
memalloc scan.c(2): alloc 12 bytes at ADDR_121
memalloc scan.c(8): alloc 48 bytes at ADDR_122
memalloc scan.c(8): alloc 4 bytes at ADDR_123
memalloc scan.c(8): alloc 48 bytes at ADDR_124
memalloc scan.c(10): free 4 bytes at ADDR_123 allocated at scan.c(8)
memalloc scan.c(10): free 48 bytes at ADDR_122 allocated at scan.c(8)
memalloc scan.c(4): alloc 5 bytes at ADDR_125
memalloc test.c(2): free 5 bytes at ADDR_125 allocated at scan.c(4)
Token: f0(3) NAME DEFC
memalloc scan.c(4): alloc 2 bytes at ADDR_126
memalloc test.c(2): free 2 bytes at ADDR_126 allocated at scan.c(4)
Token: f0(3) NAME C
Token: f0(3) '='
Token: f0(3) NUMBER 2
Token: f0(3) '\n'
memalloc scan.c(4): alloc 5 bytes at ADDR_127
memalloc test.c(2): free 5 bytes at ADDR_127 allocated at scan.c(4)
Token: f0(3) NAME DEFC
memalloc scan.c(4): alloc 2 bytes at ADDR_128
memalloc test.c(2): free 2 bytes at ADDR_128 allocated at scan.c(4)
Token: f0(3) NAME D
Token: f0(3) '='
Token: f0(3) NUMBER 3
Token: f0(3) '\n'
memalloc scan.c(10): free 48 bytes at ADDR_124 allocated at scan.c(8)
memalloc scan.c(2): free 12 bytes at ADDR_121 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_120 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_119 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_118 allocated at scan.c(1)
List:f0:4:
Token: f0(4) '\n'
List:f0:5:F0 5
memalloc scan.c(4): alloc 3 bytes at ADDR_129
memalloc test.c(2): free 3 bytes at ADDR_129 allocated at scan.c(4)
Token: f0(5) NAME F0
Token: f0(5) NUMBER 5
memalloc scan.c(1): alloc 48 bytes at ADDR_130
memalloc dynstr.c(1): alloc 40 bytes at ADDR_131
memalloc dynstr.c(3): alloc 256 bytes at ADDR_132
memalloc scan.c(2): alloc 12 bytes at ADDR_133
memalloc scan.c(8): alloc 48 bytes at ADDR_134
memalloc scan.c(8): alloc 16386 bytes at ADDR_135
List:x1/f1:1:F1 1
memalloc scan.c(4): alloc 3 bytes at ADDR_136
memalloc test.c(2): free 3 bytes at ADDR_136 allocated at scan.c(4)
Token: x1/f1(1) NAME F1
Token: x1/f1(1) NUMBER 1
Token: x1/f1(1) '\n'
List:x1/f1:2:F1 2
memalloc scan.c(4): alloc 3 bytes at ADDR_137
memalloc test.c(2): free 3 bytes at ADDR_137 allocated at scan.c(4)
Token: x1/f1(2) NAME F1
Token: x1/f1(2) NUMBER 2
Token: x1/f1(2) '\n'
List:x1/f1:3:F1 3
memalloc scan.c(4): alloc 3 bytes at ADDR_138
memalloc test.c(2): free 3 bytes at ADDR_138 allocated at scan.c(4)
Token: x1/f1(3) NAME F1
Token: x1/f1(3) NUMBER 3
Token: x1/f1(3) '\n'
memalloc scan.c(10): free 16386 bytes at ADDR_135 allocated at scan.c(8)
memalloc scan.c(10): free 48 bytes at ADDR_134 allocated at scan.c(8)
memalloc scan.c(2): free 12 bytes at ADDR_133 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_132 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_131 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_130 allocated at scan.c(1)
Token: f0(5) '\n'
List:f0:6:
Token: f0(6) '\n'
List:f0:7:F0 7
memalloc scan.c(4): alloc 3 bytes at ADDR_139
memalloc test.c(2): free 3 bytes at ADDR_139 allocated at scan.c(4)
Token: f0(7) NAME F0
Token: f0(7) NUMBER 7
Token: f0(7) '\n'
List:f0:8:
Token: f0(8) '\n'
List:f0:9:F0 9
memalloc scan.c(4): alloc 3 bytes at ADDR_140
memalloc test.c(2): free 3 bytes at ADDR_140 allocated at scan.c(4)
Token: f0(9) NAME F0
Token: f0(9) NUMBER 9
Token: f0(9) '\n'
List:f0:10:
Token: f0(10) '\n'
List:f0:11:F0 11
memalloc scan.c(4): alloc 3 bytes at ADDR_141
memalloc test.c(2): free 3 bytes at ADDR_141 allocated at scan.c(4)
Token: f0(11) NAME F0
Token: f0(11) NUMBER 11
Token: f0(11) '\n'
List:f0:12:
Token: f0(12) '\n'
List:f0:13:F0 13
memalloc scan.c(4): alloc 3 bytes at ADDR_142
memalloc test.c(2): free 3 bytes at ADDR_142 allocated at scan.c(4)
Token: f0(13) NAME F0
Token: f0(13) NUMBER 13
Token: f0(13) '\n'
memalloc scan.c(10): free 16386 bytes at ADDR_115 allocated at scan.c(8)
memalloc scan.c(10): free 48 bytes at ADDR_114 allocated at scan.c(8)
memalloc scan.c(2): free 12 bytes at ADDR_113 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_112 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_111 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_110 allocated at scan.c(1)
Token: (0) NULL
Token: (0) NULL
memalloc strpool.c(2): alloc 36 bytes at ADDR_143
memalloc strpool.c(3): alloc 6 bytes at ADDR_144
memalloc scan.c(1): alloc 48 bytes at ADDR_145
memalloc dynstr.c(1): alloc 40 bytes at ADDR_146
memalloc dynstr.c(3): alloc 256 bytes at ADDR_147
memalloc scan.c(2): alloc 12 bytes at ADDR_148
memalloc scan.c(8): alloc 48 bytes at ADDR_149
memalloc scan.c(8): alloc 16386 bytes at ADDR_150
List:x2/f2:1:; sigle-character tokens
Token: x2/f2(1) '\n'
List:x2/f2:2:! # $ % & ( ) * + , - . / : < = > ? @ [ \ ] ^ ` { | } ~
Token: x2/f2(2) '!'
Token: x2/f2(2) '#'
Token: x2/f2(2) '$'
Token: x2/f2(2) '%'
Token: x2/f2(2) '&'
Token: x2/f2(2) '('
Token: x2/f2(2) ')'
Token: x2/f2(2) '*'
Token: x2/f2(2) '+'
Token: x2/f2(2) ','
Token: x2/f2(2) '-'
Token: x2/f2(2) '.'
Token: x2/f2(2) '/'
Token: x2/f2(2) ':'
Token: x2/f2(2) '<'
Token: x2/f2(2) '='
Token: x2/f2(2) '>'
Token: x2/f2(2) '?'
Token: x2/f2(2) '@'
Token: x2/f2(2) '['
Token: x2/f2(2) '\'
Token: x2/f2(2) ']'
Token: x2/f2(2) '^'
Token: x2/f2(2) '`'
Token: x2/f2(2) '{'
Token: x2/f2(2) '|'
Token: x2/f2(2) '}'
Token: x2/f2(2) '~'
Token: x2/f2(2) '\n'
List:x2/f2:3:
Token: x2/f2(3) '\n'
List:x2/f2:4:; multiple-character tokens
Token: x2/f2(4) '\n'
List:x2/f2:5:== <> != <= >= || && << >> **
Token: x2/f2(5) EQUAL_EQUAL
Token: x2/f2(5) LESS_GREATER
Token: x2/f2(5) NOT_EQUAL
Token: x2/f2(5) LESS_EQUAL
Token: x2/f2(5) GREATER_EQUAL
Token: x2/f2(5) DBL_VBAR
Token: x2/f2(5) DBL_AMPERSAND
Token: x2/f2(5) DBL_LESS
Token: x2/f2(5) DBL_GREATER
Token: x2/f2(5) DBL_ASTERISK
Token: x2/f2(5) '\n'
List:x2/f2:6:
Token: x2/f2(6) '\n'
List:x2/f2:7:; names
Token: x2/f2(7) '\n'
List:x2/f2:8:_Abc_123 Abc_123 123_Abc_
memalloc scan.c(4): alloc 9 bytes at ADDR_151
memalloc test.c(2): free 9 bytes at ADDR_151 allocated at scan.c(4)
Token: x2/f2(8) NAME _ABC_123
memalloc scan.c(4): alloc 8 bytes at ADDR_152
memalloc test.c(2): free 8 bytes at ADDR_152 allocated at scan.c(4)
Token: x2/f2(8) NAME ABC_123
Token: x2/f2(8) NUMBER 123
memalloc scan.c(4): alloc 6 bytes at ADDR_153
memalloc test.c(2): free 6 bytes at ADDR_153 allocated at scan.c(4)
Token: x2/f2(8) NAME _ABC_
Token: x2/f2(8) '\n'
List:x2/f2:9:Abc_123	af' bc'de'af'
memalloc scan.c(4): alloc 8 bytes at ADDR_154
memalloc test.c(2): free 8 bytes at ADDR_154 allocated at scan.c(4)
Token: x2/f2(9) NAME ABC_123
memalloc scan.c(4): alloc 3 bytes at ADDR_155
memalloc test.c(2): free 3 bytes at ADDR_155 allocated at scan.c(4)
Token: x2/f2(9) NAME AF
memalloc scan.c(7): alloc 5 bytes at ADDR_156
memalloc test.c(1): free 5 bytes at ADDR_156 allocated at scan.c(7)
Token: x2/f2(9) STRING ' bc'
memalloc scan.c(4): alloc 3 bytes at ADDR_157
memalloc test.c(2): free 3 bytes at ADDR_157 allocated at scan.c(4)
Token: x2/f2(9) NAME DE
memalloc scan.c(7): alloc 4 bytes at ADDR_158
memalloc test.c(1): free 4 bytes at ADDR_158 allocated at scan.c(7)
Token: x2/f2(9) STRING 'af'
Token: x2/f2(9) '\n'
List:x2/f2:10:
Token: x2/f2(10) '\n'
List:x2/f2:11:; labels
Token: x2/f2(11) '\n'
List:x2/f2:12:.abc  . def : ghi
memalloc scan.c(5): alloc 4 bytes at ADDR_159
memalloc test.c(2): free 4 bytes at ADDR_159 allocated at scan.c(5)
Token: x2/f2(12) NAME ABC
Token: x2/f2(12) '.'
memalloc scan.c(4): alloc 4 bytes at ADDR_160
memalloc test.c(2): free 4 bytes at ADDR_160 allocated at scan.c(4)
Token: x2/f2(12) NAME DEF
Token: x2/f2(12) ':'
memalloc scan.c(4): alloc 4 bytes at ADDR_161
memalloc test.c(2): free 4 bytes at ADDR_161 allocated at scan.c(4)
Token: x2/f2(12) NAME GHI
Token: x2/f2(12) '\n'
List:x2/f2:13: abc: . def : ghi
memalloc scan.c(6): alloc 5 bytes at ADDR_162
memalloc test.c(2): free 5 bytes at ADDR_162 allocated at scan.c(6)
Token: x2/f2(13) NAME ABC
Token: x2/f2(13) '.'
memalloc scan.c(4): alloc 4 bytes at ADDR_163
memalloc test.c(2): free 4 bytes at ADDR_163 allocated at scan.c(4)
Token: x2/f2(13) NAME DEF
Token: x2/f2(13) ':'
memalloc scan.c(4): alloc 4 bytes at ADDR_164
memalloc test.c(2): free 4 bytes at ADDR_164 allocated at scan.c(4)
Token: x2/f2(13) NAME GHI
Token: x2/f2(13) '\n'
List:x2/f2:14:.abc: . def : ghi
memalloc scan.c(5): alloc 4 bytes at ADDR_165
memalloc test.c(2): free 4 bytes at ADDR_165 allocated at scan.c(5)
Token: x2/f2(14) NAME ABC
Token: x2/f2(14) ':'
Token: x2/f2(14) '.'
memalloc scan.c(4): alloc 4 bytes at ADDR_166
memalloc test.c(2): free 4 bytes at ADDR_166 allocated at scan.c(4)
Token: x2/f2(14) NAME DEF
Token: x2/f2(14) ':'
memalloc scan.c(4): alloc 4 bytes at ADDR_167
memalloc test.c(2): free 4 bytes at ADDR_167 allocated at scan.c(4)
Token: x2/f2(14) NAME GHI
Token: x2/f2(14) '\n'
List:x2/f2:15:
Token: x2/f2(15) '\n'
List:x2/f2:16:; numbers - decimal
Token: x2/f2(16) '\n'
List:x2/f2:17:0 2147483647 2147483648
Token: x2/f2(17) NUMBER 0
Token: x2/f2(17) NUMBER 2147483647
memalloc errors.c(1): alloc 40 bytes at ADDR_168
memalloc strhash.c(1): alloc 32 bytes at ADDR_169
Warning at file 'x2/f2' line 17: Integer '-2147483648' out of range
Token: x2/f2(17) NUMBER -2147483648
Token: x2/f2(17) '\n'
List:x2/f2:18:
Token: x2/f2(18) '\n'
List:x2/f2:19:; numbers - binary
Token: x2/f2(19) '\n'
List:x2/f2:20:  0000b   0011b    1111111111111111111111111111111b
Token: x2/f2(20) NUMBER 0
Token: x2/f2(20) NUMBER 3
Token: x2/f2(20) NUMBER 2147483647
Token: x2/f2(20) '\n'
List:x2/f2:21: @0000   @0011    @1111111111111111111111111111111
Token: x2/f2(21) NUMBER 0
Token: x2/f2(21) NUMBER 3
Token: x2/f2(21) NUMBER 2147483647
Token: x2/f2(21) '\n'
List:x2/f2:22: %0000   %0011    %1111111111111111111111111111111
Token: x2/f2(22) NUMBER 0
Token: x2/f2(22) NUMBER 3
Token: x2/f2(22) NUMBER 2147483647
Token: x2/f2(22) '\n'
List:x2/f2:23:0b0000  0b0011   0b1111111111111111111111111111111
Token: x2/f2(23) NUMBER 0
Token: x2/f2(23) NUMBER 3
Token: x2/f2(23) NUMBER 2147483647
Token: x2/f2(23) '\n'
List:x2/f2:24:@'----' @'--##'  @'###############################'
Token: x2/f2(24) NUMBER 0
Token: x2/f2(24) NUMBER 3
Token: x2/f2(24) NUMBER 2147483647
Token: x2/f2(24) '\n'
List:x2/f2:25:%'----' %'--##'  %'###############################'
Token: x2/f2(25) NUMBER 0
Token: x2/f2(25) NUMBER 3
Token: x2/f2(25) NUMBER 2147483647
Token: x2/f2(25) '\n'
List:x2/f2:26:@"----" @"--##"  @"###############################"
Token: x2/f2(26) NUMBER 0
Token: x2/f2(26) NUMBER 3
Token: x2/f2(26) NUMBER 2147483647
Token: x2/f2(26) '\n'
List:x2/f2:27:%"----" %"--##"  %"###############################"
Token: x2/f2(27) NUMBER 0
Token: x2/f2(27) NUMBER 3
Token: x2/f2(27) NUMBER 2147483647
Token: x2/f2(27) '\n'
List:x2/f2:28:
Token: x2/f2(28) '\n'
List:x2/f2:29:; numbers - hexadecimal
Token: x2/f2(29) '\n'
List:x2/f2:30:  0h 0ah 0FH   7FFFFFFFh
Token: x2/f2(30) NUMBER 0
Token: x2/f2(30) NUMBER 10
Token: x2/f2(30) NUMBER 15
Token: x2/f2(30) NUMBER 2147483647
Token: x2/f2(30) '\n'
List:x2/f2:31: $0   $a  $F  $7FFFFFFF
Token: x2/f2(31) NUMBER 0
Token: x2/f2(31) NUMBER 10
Token: x2/f2(31) NUMBER 15
Token: x2/f2(31) NUMBER 2147483647
Token: x2/f2(31) '\n'
List:x2/f2:32: #0   #a  #F  #7FFFFFFF
Token: x2/f2(32) NUMBER 0
Token: x2/f2(32) NUMBER 10
Token: x2/f2(32) NUMBER 15
Token: x2/f2(32) NUMBER 2147483647
Token: x2/f2(32) '\n'
List:x2/f2:33:0x0  0xa 0xF 0x7FFFFFFF
Token: x2/f2(33) NUMBER 0
Token: x2/f2(33) NUMBER 10
Token: x2/f2(33) NUMBER 15
Token: x2/f2(33) NUMBER 2147483647
Token: x2/f2(33) '\n'
List:x2/f2:34:
Token: x2/f2(34) '\n'
List:x2/f2:35:; strings - single-quote
Token: x2/f2(35) '\n'
List:x2/f2:36:'''a''"'';';comment
memalloc scan.c(7): alloc 2 bytes at ADDR_170
memalloc test.c(1): free 2 bytes at ADDR_170 allocated at scan.c(7)
Token: x2/f2(36) STRING ''
memalloc scan.c(7): alloc 3 bytes at ADDR_171
memalloc test.c(1): free 3 bytes at ADDR_171 allocated at scan.c(7)
Token: x2/f2(36) STRING 'a'
memalloc scan.c(7): alloc 3 bytes at ADDR_172
memalloc test.c(1): free 3 bytes at ADDR_172 allocated at scan.c(7)
Token: x2/f2(36) STRING '"'
memalloc scan.c(7): alloc 3 bytes at ADDR_173
memalloc test.c(1): free 3 bytes at ADDR_173 allocated at scan.c(7)
Token: x2/f2(36) STRING ';'
Token: x2/f2(36) '\n'
List:x2/f2:37:'unclosed
Error at file 'x2/f2' line 37: Unclosed string
Token: x2/f2(37) '\n'
List:x2/f2:38:
Token: x2/f2(38) '\n'
List:x2/f2:39:; strings - double-quotes
Token: x2/f2(39) '\n'
List:x2/f2:40:"""a""'"";";comment
memalloc scan.c(7): alloc 2 bytes at ADDR_174
memalloc test.c(1): free 2 bytes at ADDR_174 allocated at scan.c(7)
Token: x2/f2(40) STRING ''
memalloc scan.c(7): alloc 3 bytes at ADDR_175
memalloc test.c(1): free 3 bytes at ADDR_175 allocated at scan.c(7)
Token: x2/f2(40) STRING 'a'
memalloc scan.c(7): alloc 3 bytes at ADDR_176
memalloc test.c(1): free 3 bytes at ADDR_176 allocated at scan.c(7)
Token: x2/f2(40) STRING '''
memalloc scan.c(7): alloc 3 bytes at ADDR_177
memalloc test.c(1): free 3 bytes at ADDR_177 allocated at scan.c(7)
Token: x2/f2(40) STRING ';'
Token: x2/f2(40) '\n'
List:x2/f2:41:"unclosed
Error at file 'x2/f2' line 41: Unclosed string
Token: x2/f2(41) '\n'
List:x2/f2:42:
Token: x2/f2(42) '\n'
memalloc scan.c(10): free 16386 bytes at ADDR_150 allocated at scan.c(8)
memalloc scan.c(10): free 48 bytes at ADDR_149 allocated at scan.c(8)
memalloc scan.c(2): free 12 bytes at ADDR_148 allocated at scan.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_147 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_146 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_145 allocated at scan.c(1)
Token: (0) NULL
Token: (0) NULL
memalloc strpool.c(2): alloc 36 bytes at ADDR_178
memalloc strpool.c(3): alloc 6 bytes at ADDR_179
memalloc scan.c(1): alloc 48 bytes at ADDR_180
memalloc dynstr.c(1): alloc 40 bytes at ADDR_181
memalloc dynstr.c(3): alloc 256 bytes at ADDR_182
memalloc scan.c(2): alloc 12 bytes at ADDR_183
memalloc scan.c(8): alloc 48 bytes at ADDR_184
memalloc scan.c(8): alloc 16386 bytes at ADDR_185
memalloc dynstr.c(3): free 256 bytes at ADDR_182 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 512 bytes at ADDR_186
memalloc dynstr.c(3): free 512 bytes at ADDR_186 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 768 bytes at ADDR_187
memalloc dynstr.c(3): free 768 bytes at ADDR_187 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 1024 bytes at ADDR_188
memalloc dynstr.c(3): free 1024 bytes at ADDR_188 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 1280 bytes at ADDR_189
memalloc dynstr.c(3): free 1280 bytes at ADDR_189 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 1536 bytes at ADDR_190
memalloc dynstr.c(3): free 1536 bytes at ADDR_190 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 1792 bytes at ADDR_191
memalloc dynstr.c(3): free 1792 bytes at ADDR_191 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 2048 bytes at ADDR_192
memalloc dynstr.c(3): free 2048 bytes at ADDR_192 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 2304 bytes at ADDR_193
memalloc dynstr.c(3): free 2304 bytes at ADDR_193 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 2560 bytes at ADDR_194
memalloc dynstr.c(3): free 2560 bytes at ADDR_194 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 2816 bytes at ADDR_195
memalloc dynstr.c(3): free 2816 bytes at ADDR_195 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 3072 bytes at ADDR_196
memalloc dynstr.c(3): free 3072 bytes at ADDR_196 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 3328 bytes at ADDR_197
memalloc dynstr.c(3): free 3328 bytes at ADDR_197 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 3584 bytes at ADDR_198
memalloc dynstr.c(3): free 3584 bytes at ADDR_198 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 3840 bytes at ADDR_199
memalloc dynstr.c(3): free 3840 bytes at ADDR_199 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 4096 bytes at ADDR_200
memalloc dynstr.c(3): free 4096 bytes at ADDR_200 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 4352 bytes at ADDR_201
memalloc dynstr.c(3): free 4352 bytes at ADDR_201 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 4608 bytes at ADDR_202
memalloc dynstr.c(3): free 4608 bytes at ADDR_202 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 4864 bytes at ADDR_203
memalloc dynstr.c(3): free 4864 bytes at ADDR_203 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 5120 bytes at ADDR_204
memalloc dynstr.c(3): free 5120 bytes at ADDR_204 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 5376 bytes at ADDR_205
memalloc dynstr.c(3): free 5376 bytes at ADDR_205 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 5632 bytes at ADDR_206
memalloc dynstr.c(3): free 5632 bytes at ADDR_206 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 5888 bytes at ADDR_207
memalloc dynstr.c(3): free 5888 bytes at ADDR_207 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 6144 bytes at ADDR_208
memalloc dynstr.c(3): free 6144 bytes at ADDR_208 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 6400 bytes at ADDR_209
memalloc dynstr.c(3): free 6400 bytes at ADDR_209 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 6656 bytes at ADDR_210
memalloc dynstr.c(3): free 6656 bytes at ADDR_210 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 6912 bytes at ADDR_211
memalloc dynstr.c(3): free 6912 bytes at ADDR_211 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 7168 bytes at ADDR_212
memalloc dynstr.c(3): free 7168 bytes at ADDR_212 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 7424 bytes at ADDR_213
memalloc dynstr.c(3): free 7424 bytes at ADDR_213 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 7680 bytes at ADDR_214
memalloc dynstr.c(3): free 7680 bytes at ADDR_214 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 7936 bytes at ADDR_215
memalloc dynstr.c(3): free 7936 bytes at ADDR_215 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 8192 bytes at ADDR_216
memalloc dynstr.c(3): free 8192 bytes at ADDR_216 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 8448 bytes at ADDR_217
memalloc dynstr.c(3): free 8448 bytes at ADDR_217 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 8704 bytes at ADDR_218
memalloc dynstr.c(3): free 8704 bytes at ADDR_218 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 8960 bytes at ADDR_219
memalloc dynstr.c(3): free 8960 bytes at ADDR_219 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 9216 bytes at ADDR_220
memalloc dynstr.c(3): free 9216 bytes at ADDR_220 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 9472 bytes at ADDR_221
memalloc dynstr.c(3): free 9472 bytes at ADDR_221 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 9728 bytes at ADDR_222
memalloc dynstr.c(3): free 9728 bytes at ADDR_222 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 9984 bytes at ADDR_223
memalloc dynstr.c(3): free 9984 bytes at ADDR_223 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 10240 bytes at ADDR_224
memalloc dynstr.c(3): free 10240 bytes at ADDR_224 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 10496 bytes at ADDR_225
memalloc dynstr.c(3): free 10496 bytes at ADDR_225 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 10752 bytes at ADDR_226
memalloc dynstr.c(3): free 10752 bytes at ADDR_226 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 11008 bytes at ADDR_227
memalloc dynstr.c(3): free 11008 bytes at ADDR_227 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 11264 bytes at ADDR_228
memalloc dynstr.c(3): free 11264 bytes at ADDR_228 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 11520 bytes at ADDR_229
memalloc dynstr.c(3): free 11520 bytes at ADDR_229 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 11776 bytes at ADDR_230
memalloc dynstr.c(3): free 11776 bytes at ADDR_230 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 12032 bytes at ADDR_231
memalloc dynstr.c(3): free 12032 bytes at ADDR_231 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 12288 bytes at ADDR_232
memalloc dynstr.c(3): free 12288 bytes at ADDR_232 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 12544 bytes at ADDR_233
memalloc dynstr.c(3): free 12544 bytes at ADDR_233 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 12800 bytes at ADDR_234
memalloc dynstr.c(3): free 12800 bytes at ADDR_234 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 13056 bytes at ADDR_235
memalloc dynstr.c(3): free 13056 bytes at ADDR_235 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 13312 bytes at ADDR_236
memalloc dynstr.c(3): free 13312 bytes at ADDR_236 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 13568 bytes at ADDR_237
memalloc dynstr.c(3): free 13568 bytes at ADDR_237 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 13824 bytes at ADDR_238
memalloc dynstr.c(3): free 13824 bytes at ADDR_238 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 14080 bytes at ADDR_239
memalloc dynstr.c(3): free 14080 bytes at ADDR_239 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 14336 bytes at ADDR_240
memalloc dynstr.c(3): free 14336 bytes at ADDR_240 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 14592 bytes at ADDR_241
memalloc dynstr.c(3): free 14592 bytes at ADDR_241 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 14848 bytes at ADDR_242
memalloc dynstr.c(3): free 14848 bytes at ADDR_242 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 15104 bytes at ADDR_243
memalloc dynstr.c(3): free 15104 bytes at ADDR_243 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 15360 bytes at ADDR_244
memalloc dynstr.c(3): free 15360 bytes at ADDR_244 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 15616 bytes at ADDR_245
memalloc dynstr.c(3): free 15616 bytes at ADDR_245 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 15872 bytes at ADDR_246
memalloc dynstr.c(3): free 15872 bytes at ADDR_246 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 16128 bytes at ADDR_247
memalloc dynstr.c(3): free 16128 bytes at ADDR_247 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 16384 bytes at ADDR_248
memalloc dynstr.c(3): free 16384 bytes at ADDR_248 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 16640 bytes at ADDR_249
memalloc dynstr.c(3): free 16640 bytes at ADDR_249 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 16896 bytes at ADDR_250
memalloc dynstr.c(3): free 16896 bytes at ADDR_250 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 17152 bytes at ADDR_251
memalloc dynstr.c(3): free 17152 bytes at ADDR_251 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 17408 bytes at ADDR_252
memalloc dynstr.c(3): free 17408 bytes at ADDR_252 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 17664 bytes at ADDR_253
memalloc dynstr.c(3): free 17664 bytes at ADDR_253 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 17920 bytes at ADDR_254
memalloc dynstr.c(3): free 17920 bytes at ADDR_254 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 18176 bytes at ADDR_255
memalloc dynstr.c(3): free 18176 bytes at ADDR_255 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 18432 bytes at ADDR_256
memalloc dynstr.c(3): free 18432 bytes at ADDR_256 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 18688 bytes at ADDR_257
memalloc dynstr.c(3): free 18688 bytes at ADDR_257 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 18944 bytes at ADDR_258
memalloc dynstr.c(3): free 18944 bytes at ADDR_258 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 19200 bytes at ADDR_259
memalloc dynstr.c(3): free 19200 bytes at ADDR_259 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 19456 bytes at ADDR_260
memalloc dynstr.c(3): free 19456 bytes at ADDR_260 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 19712 bytes at ADDR_261
memalloc dynstr.c(3): free 19712 bytes at ADDR_261 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 19968 bytes at ADDR_262
memalloc dynstr.c(3): free 19968 bytes at ADDR_262 allocated at dynstr.c(3)
memalloc dynstr.c(3): alloc 20224 bytes at ADDR_263
memalloc scan.c(9): free 16386 bytes at ADDR_185 allocated at scan.c(8)
memalloc scan.c(9): alloc 32770 bytes at ADDR_264
List:x2/f3:1:ld a,000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001
memalloc scan.c(4): alloc 3 bytes at ADDR_265
memalloc test.c(2): free 3 bytes at ADDR_265 allocated at scan.c(4)
Token: x2/f3(1) NAME LD
memalloc scan.c(4): alloc 2 bytes at ADDR_266
memalloc test.c(2): free 2 bytes at ADDR_266 allocated at scan.c(4)
Token: x2/f3(1) NAME A
Token: x2/f3(1) ','
Token: x2/f3(1) NUMBER 1
Token: x2/f3(1) '\n'
List:x2/f3:2:ld b,000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001
memalloc scan.c(4): alloc 3 bytes at ADDR_267
memalloc test.c(2): free 3 bytes at ADDR_267 allocated at scan.c(4)
Token: x2/f3(2) NAME LD
memalloc scan.c(4): alloc 2 bytes at ADDR_268
memalloc test.c(2): free 2 bytes at ADDR_268 allocated at scan.c(4)
Token: x2/f3(2) NAME B
Token: x2/f3(2) ','
Token: x2/f3(2) NUMBER 1
Token: x2/f3(2) '\n'
memalloc scan.c(10): free 32770 bytes at ADDR_264 allocated at scan.c(9)
memalloc scan.c(10): free 48 bytes at ADDR_184 allocated at scan.c(8)
memalloc scan.c(2): free 12 bytes at ADDR_183 allocated at scan.c(2)
memalloc dynstr.c(2): free 20224 bytes at ADDR_263 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_181 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_180 allocated at scan.c(1)
Token: (0) NULL
Token: (0) NULL
memalloc strhash.c(1): free 32 bytes at ADDR_169 allocated at strhash.c(1)
memalloc errors.c(1): free 40 bytes at ADDR_168 allocated at errors.c(1)
memalloc scan.c(10): free 36 bytes at ADDR_38 allocated at scan.c(9)
memalloc scan.c(3): free 28 bytes at ADDR_15 allocated at scan.c(3)
memalloc scan.c(2): free 40 bytes at ADDR_14 allocated at scan.c(2)
memalloc strlist.c(2): free 12 bytes at ADDR_3 allocated at strlist.c(3)
memalloc strlist.c(2): free 12 bytes at ADDR_8 allocated at strlist.c(3)
memalloc strlist.c(2): free 12 bytes at ADDR_11 allocated at strlist.c(3)
memalloc strlist.c(1): free 36 bytes at ADDR_1 allocated at strlist.c(1)
memalloc strpool.c(6): free 3 bytes at ADDR_5 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_4 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_10 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_9 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_13 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_12 allocated at strpool.c(2)
memalloc strpool.c(6): free 3 bytes at ADDR_17 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_16 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_48 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_47 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_144 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_143 allocated at strpool.c(2)
memalloc strpool.c(5): free 384 bytes at ADDR_7 allocated at strpool.c(4)
memalloc strpool.c(5): free 44 bytes at ADDR_6 allocated at strpool.c(4)
memalloc strpool.c(6): free 6 bytes at ADDR_179 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_178 allocated at strpool.c(2)
memalloc strpool.c(1): free 32 bytes at ADDR_2 allocated at strpool.c(1)
memalloc: cleanup
END


# test circular includes
t_compile_module($init, <<'END', $compile);
	int ret = 1;

    init_except();                      /* init exception mechanism */

    try
    {
		warn("Test: open text file\n");
		scan_file("f0");
		n_tokens( 7 );
		
		warn("Test: open text file again\n");
		scan_file("f0");
		
	}
    catch ( FatalErrorException )
    {
        ret = 0;		/* ok */
    }
	
	return ret;
END

t_run_module([], '', <<'END', 0);
Test: open text file
memalloc: init
memalloc scan.c(3): alloc 28 bytes at ADDR_1
memalloc scan.c(2): alloc 40 bytes at ADDR_2
memalloc strpool.c(1): alloc 32 bytes at ADDR_3
memalloc strpool.c(2): alloc 36 bytes at ADDR_4
memalloc strpool.c(3): alloc 3 bytes at ADDR_5
memalloc strpool.c(4): alloc 44 bytes at ADDR_6
memalloc strpool.c(4): alloc 384 bytes at ADDR_7
memalloc scan.c(1): alloc 48 bytes at ADDR_8
memalloc dynstr.c(1): alloc 40 bytes at ADDR_9
memalloc dynstr.c(3): alloc 256 bytes at ADDR_10
memalloc scan.c(2): alloc 12 bytes at ADDR_11
memalloc scan.c(5): alloc 48 bytes at ADDR_12
memalloc scan.c(5): alloc 16386 bytes at ADDR_13
memalloc scan.c(5): alloc 4 bytes at ADDR_14
List:f0:1:F0 1
memalloc scan.c(4): alloc 3 bytes at ADDR_15
memalloc test.c(1): free 3 bytes at ADDR_15 allocated at scan.c(4)
Token: f0(1) NAME F0
Token: f0(1) NUMBER 1
Token: f0(1) '\n'
List:f0:2:
Token: f0(2) '\n'
List:f0:3:F0 3
memalloc scan.c(4): alloc 3 bytes at ADDR_16
memalloc test.c(1): free 3 bytes at ADDR_16 allocated at scan.c(4)
Token: f0(3) NAME F0
Token: f0(3) NUMBER 3
Token: f0(3) '\n'
Test: open text file again
memalloc errors.c(1): alloc 40 bytes at ADDR_17
memalloc strhash.c(1): alloc 32 bytes at ADDR_18
Error at file 'f0' line 3: Cannot include file 'f0' recursively
memalloc strhash.c(1): free 32 bytes at ADDR_18 allocated at strhash.c(1)
memalloc errors.c(1): free 40 bytes at ADDR_17 allocated at errors.c(1)
memalloc strpool.c(5): free 384 bytes at ADDR_7 allocated at strpool.c(4)
memalloc strpool.c(5): free 44 bytes at ADDR_6 allocated at strpool.c(4)
memalloc strpool.c(6): free 3 bytes at ADDR_5 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_4 allocated at strpool.c(2)
memalloc strpool.c(1): free 32 bytes at ADDR_3 allocated at strpool.c(1)
memalloc scan.c(6): free 16386 bytes at ADDR_13 allocated at scan.c(5)
memalloc scan.c(6): free 48 bytes at ADDR_12 allocated at scan.c(5)
memalloc scan.c(6): free 4 bytes at ADDR_14 allocated at scan.c(5)
memalloc scan.c(3): free 28 bytes at ADDR_1 allocated at scan.c(3)
memalloc dynstr.c(2): free 256 bytes at ADDR_10 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_9 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_8 allocated at scan.c(1)
memalloc scan.c(2): free 12 bytes at ADDR_11 allocated at scan.c(2)
memalloc scan.c(2): free 40 bytes at ADDR_2 allocated at scan.c(2)
memalloc: cleanup
END


# test open file error
t_compile_module($init, <<'END', $compile);
	int ret = 1;

    init_except();                      /* init exception mechanism */

    try
    {
		warn("Test: open text file\n");
		scan_file("f0");
		n_tokens( 7 );
		
		warn("Test: open fails\n");
		scan_file("f1");
		
	}
    catch ( FatalErrorException )
    {
        ret = 0;		/* ok */
    }
	
	return ret;
END

t_run_module([], '', <<'END', 0);
Test: open text file
memalloc: init
memalloc scan.c(3): alloc 28 bytes at ADDR_1
memalloc scan.c(2): alloc 40 bytes at ADDR_2
memalloc strpool.c(1): alloc 32 bytes at ADDR_3
memalloc strpool.c(2): alloc 36 bytes at ADDR_4
memalloc strpool.c(3): alloc 3 bytes at ADDR_5
memalloc strpool.c(4): alloc 44 bytes at ADDR_6
memalloc strpool.c(4): alloc 384 bytes at ADDR_7
memalloc scan.c(1): alloc 48 bytes at ADDR_8
memalloc dynstr.c(1): alloc 40 bytes at ADDR_9
memalloc dynstr.c(3): alloc 256 bytes at ADDR_10
memalloc scan.c(2): alloc 12 bytes at ADDR_11
memalloc scan.c(5): alloc 48 bytes at ADDR_12
memalloc scan.c(5): alloc 16386 bytes at ADDR_13
memalloc scan.c(5): alloc 4 bytes at ADDR_14
List:f0:1:F0 1
memalloc scan.c(4): alloc 3 bytes at ADDR_15
memalloc test.c(1): free 3 bytes at ADDR_15 allocated at scan.c(4)
Token: f0(1) NAME F0
Token: f0(1) NUMBER 1
Token: f0(1) '\n'
List:f0:2:
Token: f0(2) '\n'
List:f0:3:F0 3
memalloc scan.c(4): alloc 3 bytes at ADDR_16
memalloc test.c(1): free 3 bytes at ADDR_16 allocated at scan.c(4)
Token: f0(3) NAME F0
Token: f0(3) NUMBER 3
Token: f0(3) '\n'
Test: open fails
memalloc strpool.c(2): alloc 36 bytes at ADDR_17
memalloc strpool.c(3): alloc 3 bytes at ADDR_18
memalloc errors.c(1): alloc 40 bytes at ADDR_19
memalloc strhash.c(1): alloc 32 bytes at ADDR_20
Error at file 'f0' line 3: Cannot open file 'f1' for reading
memalloc strhash.c(1): free 32 bytes at ADDR_20 allocated at strhash.c(1)
memalloc errors.c(1): free 40 bytes at ADDR_19 allocated at errors.c(1)
memalloc strpool.c(6): free 3 bytes at ADDR_5 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_4 allocated at strpool.c(2)
memalloc strpool.c(5): free 384 bytes at ADDR_7 allocated at strpool.c(4)
memalloc strpool.c(5): free 44 bytes at ADDR_6 allocated at strpool.c(4)
memalloc strpool.c(6): free 3 bytes at ADDR_18 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_17 allocated at strpool.c(2)
memalloc strpool.c(1): free 32 bytes at ADDR_3 allocated at strpool.c(1)
memalloc scan.c(6): free 16386 bytes at ADDR_13 allocated at scan.c(5)
memalloc scan.c(6): free 48 bytes at ADDR_12 allocated at scan.c(5)
memalloc scan.c(6): free 4 bytes at ADDR_14 allocated at scan.c(5)
memalloc scan.c(3): free 28 bytes at ADDR_1 allocated at scan.c(3)
memalloc dynstr.c(2): free 256 bytes at ADDR_10 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_9 allocated at dynstr.c(1)
memalloc scan.c(1): free 48 bytes at ADDR_8 allocated at scan.c(1)
memalloc scan.c(2): free 12 bytes at ADDR_11 allocated at scan.c(2)
memalloc scan.c(2): free 40 bytes at ADDR_2 allocated at scan.c(2)
memalloc: cleanup
END


# delete directories and files
remove_tree(qw( x1 x2 x3 ));
unlink_testfiles('f0');
done_testing;
