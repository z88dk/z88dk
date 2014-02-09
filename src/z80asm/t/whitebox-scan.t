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
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-scan.t,v 1.36 2014-02-09 10:16:15 pauloscustodio Exp $
#
# Test scan.rl

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';
use Test::Differences; 

my $objs = "scan.o errors.o ".
		   "lib/strutil.o lib/xmalloc.o lib/strhash.o lib/fileutil.o ".
		   "lib/srcfile.o lib/strpool.o lib/die.o lib/except.o lib/class.o ".
		   "lib/list.o";
my $compile = "cc -Wall -otest -Ilib test.c $objs";

write_file("test.c", <<'END');
#include "scan.h"
#include <assert.h>

#define T_GET( exp_token, exp_num, exp_str )	\
	token = scan_get(); \
	assert( token == exp_token ); \
	assert( last_token == exp_token ); \
	assert( last_token_num == exp_num ); \
	assert( strcmp( last_token_str, exp_str ) == 0 );
	
int main()
{
	Token token;
	
	scan_reset("", TRUE);
	T_GET( T_END,		0,	"" );
	T_GET( T_END,		0,	"" );
	
	/* at_bol = TRUE */
	scan_reset(" \t start \t : \t . start : \n", TRUE);
	T_GET( T_LABEL,		0,		"START" );
	T_GET( T_DOT,		0,		"START" );
	T_GET( T_NAME,		0,		"START" );
	T_GET( T_COLON,		0,		"START" );
	T_GET( T_NEWLINE,	0,		"START" );
	T_GET( T_END,		0,		"START" );
	T_GET( T_END,		0,		"START" );
	
	scan_reset(" \t . \t start \t : \t . start : \n", TRUE);
	T_GET( T_LABEL,		0,		"START" );
	T_GET( T_DOT,		0,		"START" );
	T_GET( T_NAME,		0,		"START" );
	T_GET( T_COLON,		0,		"START" );
	T_GET( T_NEWLINE,	0,		"START" );
	T_GET( T_END,		0,		"START" );
	T_GET( T_END,		0,		"START" );
	
	scan_reset(" \t . \t start \t . start : \n", TRUE);
	T_GET( T_LABEL,		0,		"START" );
	T_GET( T_DOT,		0,		"START" );
	T_GET( T_NAME,		0,		"START" );
	T_GET( T_COLON,		0,		"START" );
	T_GET( T_NEWLINE,	0,		"START" );
	T_GET( T_END,		0,		"START" );
	T_GET( T_END,		0,		"START" );
	
	scan_reset(" \t . \t : \t . start : \n", TRUE);
	T_GET( T_DOT,		0,		"START" );
	T_GET( T_COLON,		0,		"START" );
	T_GET( T_DOT,		0,		"START" );
	T_GET( T_NAME,		0,		"START" );
	T_GET( T_COLON,		0,		"START" );
	T_GET( T_NEWLINE,	0,		"START" );
	T_GET( T_END,		0,		"START" );
	T_GET( T_END,		0,		"START" );
	
	/* at_bol = FALSE */
	scan_reset(" \t start \t : \t . start : \n", FALSE);
	T_GET( T_NAME,		0,		"START" );
	T_GET( T_COLON,		0,		"START" );
	T_GET( T_DOT,		0,		"START" );
	T_GET( T_NAME,		0,		"START" );
	T_GET( T_COLON,		0,		"START" );
	T_GET( T_NEWLINE,	0,		"START" );
	T_GET( T_END,		0,		"START" );
	T_GET( T_END,		0,		"START" );
	
	scan_reset(" \t . \t start \t : \t . start : \n", FALSE);
	T_GET( T_DOT,		0,		"START" );
	T_GET( T_NAME,		0,		"START" );
	T_GET( T_COLON,		0,		"START" );
	T_GET( T_DOT,		0,		"START" );
	T_GET( T_NAME,		0,		"START" );
	T_GET( T_COLON,		0,		"START" );
	T_GET( T_NEWLINE,	0,		"START" );
	T_GET( T_END,		0,		"START" );
	T_GET( T_END,		0,		"START" );
	
	scan_reset(" \t . \t start \t . start : \n", FALSE);
	T_GET( T_DOT,		0,		"START" );
	T_GET( T_NAME,		0,		"START" );
	T_GET( T_DOT,		0,		"START" );
	T_GET( T_NAME,		0,		"START" );
	T_GET( T_COLON,		0,		"START" );
	T_GET( T_NEWLINE,	0,		"START" );
	T_GET( T_END,		0,		"START" );
	T_GET( T_END,		0,		"START" );
	
	/* reset */
	scan_reset("\"\" 0", FALSE);
	T_GET( T_STRING,	0,		"" );
	T_GET( T_NUMBER,	0,		"" );
	T_GET( T_END,		0,		"" );
	
	/* symbols */
	scan_reset(" \r\f\v\t ; comment "
			   " \n ! # $ % & ( ) * + , - . / : < = > ? @ [ \\ ] ^ ` { | } ~ "
			   " == <> != <= >= || && << >> ** "
			   " ; comment ", 
			   FALSE);
	T_GET( T_NEWLINE,	0,		"" );
	T_GET( T_EXCLAM,	0,		"" );
	T_GET( T_HASH,		0,		"" );
	T_GET( T_DOLLAR,	0,		"" );
	T_GET( T_PERCENT,	0,		"" );
	T_GET( T_AND,		0,		"" );
	T_GET( T_LPAREN,	0,		"" );
	T_GET( T_RPAREN,	0,		"" );
	T_GET( T_STAR,		0,		"" );
	T_GET( T_PLUS,		0,		"" );
	T_GET( T_COMMA,		0,		"" );
	T_GET( T_MINUS,		0,		"" );
	T_GET( T_DOT,		0,		"" );
	T_GET( T_SLASH,		0,		"" );
	T_GET( T_COLON,		0,		"" );
	T_GET( T_LT,		0,		"" );
	T_GET( T_EQ,		0,		"" );
	T_GET( T_GT,		0,		"" );
	T_GET( T_QUESTION,	0,		"" );
	T_GET( T_AT,		0,		"" );
	T_GET( T_LSQUARE,	0,		"" );
	T_GET( T_BSLASH,	0,		"" );
	T_GET( T_RSQUARE,	0,		"" );
	T_GET( T_CARET,		0,		"" );
	T_GET( T_BQUOTE,	0,		"" );
	T_GET( T_LCURLY,	0,		"" );
	T_GET( T_VBAR,		0,		"" );
	T_GET( T_RCURLY,	0,		"" );
	T_GET( T_TILDE,		0,		"" );
	T_GET( T_EQ_EQ,		0,		"" );
	T_GET( T_LT_GT,		0,		"" );
	T_GET( T_EXCLAM_EQ,	0,		"" );
	T_GET( T_LT_EQ,		0,		"" );
	T_GET( T_GT_EQ,		0,		"" );
	T_GET( T_VBAR_VBAR,	0,		"" );
	T_GET( T_AND_AND,	0,		"" );
	T_GET( T_LT_LT,		0,		"" );
	T_GET( T_GT_GT,		0,		"" );
	T_GET( T_STAR_STAR,	0,		"" );
	T_GET( T_END,		0,		"" );
	T_GET( T_END,		0,		"" );

	/* names */
	scan_reset(" _Abc_123 Abc_123 123_Abc_0 0 "
			   " Abc_123	af' b'c'd'e'af' A 0 \"\" ", 
			   FALSE);
	T_GET( T_NAME,		0,		"_ABC_123" );
	T_GET( T_NAME,		0,		"ABC_123" );
	T_GET( T_NUMBER,	123,	"ABC_123" );
	T_GET( T_NAME,		123,	"_ABC_0" );
	T_GET( T_NUMBER,	0,		"_ABC_0" );
	T_GET( T_NAME,		0,		"ABC_123" );
	T_GET( T_NAME,		0,		"AF'" );
	T_GET( T_NAME,		0,		"B" );
	T_GET( T_NUMBER,	'c',	"B" );
	T_GET( T_NAME,		'c',	"D" );
	T_GET( T_NUMBER,	'e',	"D" );
	T_GET( T_NAME,		'e',	"AF'" );
	T_GET( T_NAME,		'e',	"A" );
	T_GET( T_NUMBER,	0,		"A" );
	T_GET( T_STRING,	0,		"" );
	T_GET( T_END,		0,		"" );
	T_GET( T_END,		0,		"" );

	/* labels */
	scan_reset(".   abc   .def ghi: .jkl: \n"
			   "    abc : .def ghi: .jkl: \n"
			   ".   abc : .def ghi: .jkl: \n"
			   "\"\"", 
			   TRUE);
	T_GET( T_LABEL,		0,		"ABC" );
	T_GET( T_DOT,		0,		"ABC" );
	T_GET( T_NAME,		0,		"DEF" );
	T_GET( T_NAME,		0,		"GHI" );
	T_GET( T_COLON,		0,		"GHI" );
	T_GET( T_DOT,		0,		"GHI" );
	T_GET( T_NAME,		0,		"JKL" );
	T_GET( T_COLON,		0,		"JKL" );
	T_GET( T_NEWLINE,	0,		"JKL" );
	
	T_GET( T_LABEL,		0,		"ABC" );
	T_GET( T_DOT,		0,		"ABC" );
	T_GET( T_NAME,		0,		"DEF" );
	T_GET( T_NAME,		0,		"GHI" );
	T_GET( T_COLON,		0,		"GHI" );
	T_GET( T_DOT,		0,		"GHI" );
	T_GET( T_NAME,		0,		"JKL" );
	T_GET( T_COLON,		0,		"JKL" );
	T_GET( T_NEWLINE,	0,		"JKL" );
	
	T_GET( T_LABEL,		0,		"ABC" );
	T_GET( T_DOT,		0,		"ABC" );
	T_GET( T_NAME,		0,		"DEF" );
	T_GET( T_NAME,		0,		"GHI" );
	T_GET( T_COLON,		0,		"GHI" );
	T_GET( T_DOT,		0,		"GHI" );
	T_GET( T_NAME,		0,		"JKL" );
	T_GET( T_COLON,		0,		"JKL" );
	T_GET( T_NEWLINE,	0,		"JKL" );

	T_GET( T_STRING,	0,		"" );
	T_GET( T_END,		0,		"" );
	T_GET( T_END,		0,		"" );

	/* numbers - decimal */
	scan_reset("2147483647 2147483648 0", FALSE);
	T_GET( T_NUMBER,	0x7FFFFFFF,	"" );
	T_GET( T_NUMBER,	0x80000000,	"" );
	T_GET( T_NUMBER,	0,			"" );
	T_GET( T_END,		0,			"" );
	T_GET( T_END,		0,			"" );
	
	/* numbers - binary */
	scan_reset("   0000b     0011b      1111111111111111111111111111111b	"
			   "  @0000     @0011      @1111111111111111111111111111111		"
			   "  %0000     %0011      %1111111111111111111111111111111		"
			   " 0b0000    0b0011     0b1111111111111111111111111111111		"
			   "@\"----\" @\"--##\"  @\"###############################\"	"
			   "%\"----\" %\"--##\"  %\"###############################\"	"
			   "%\"#\" 														"
			   "%\"#---\"													"
			   "%\"#-------\"												"
			   "%\"#-----------\" 											"
			   "%\"#---------------\" 										"
			   "%\"#-------------------\"									"
			   "%\"#-----------------------\" 								"
			   "%\"#---------------------------\" 							"
			   "%\"#-------------------------------\"						"
			   "%\"#--------------------------------\"						",
			   FALSE );
	T_GET( T_NUMBER,	0x00000000,	"" );
	T_GET( T_NUMBER,	0x00000003,	"" );
	T_GET( T_NUMBER,	0x7FFFFFFF,	"" );

	T_GET( T_NUMBER,	0x00000000,	"" );
	T_GET( T_NUMBER,	0x00000003,	"" );
	T_GET( T_NUMBER,	0x7FFFFFFF,	"" );

	T_GET( T_NUMBER,	0x00000000,	"" );
	T_GET( T_NUMBER,	0x00000003,	"" );
	T_GET( T_NUMBER,	0x7FFFFFFF,	"" );

	T_GET( T_NUMBER,	0x00000000,	"" );
	T_GET( T_NUMBER,	0x00000003,	"" );
	T_GET( T_NUMBER,	0x7FFFFFFF,	"" );

	T_GET( T_NUMBER,	0x00000000,	"" );
	T_GET( T_NUMBER,	0x00000003,	"" );
	T_GET( T_NUMBER,	0x7FFFFFFF,	"" );

	T_GET( T_NUMBER,	0x00000000,	"" );
	T_GET( T_NUMBER,	0x00000003,	"" );
	T_GET( T_NUMBER,	0x7FFFFFFF,	"" );

	T_GET( T_NUMBER,	0x00000001,	"" );
	T_GET( T_NUMBER,	0x00000008,	"" );
	T_GET( T_NUMBER,	0x00000080,	"" );
	T_GET( T_NUMBER,	0x00000800,	"" );
	T_GET( T_NUMBER,	0x00008000,	"" );
	T_GET( T_NUMBER,	0x00080000,	"" );
	T_GET( T_NUMBER,	0x00800000,	"" );
	T_GET( T_NUMBER,	0x08000000,	"" );
	T_GET( T_NUMBER,	0x80000000,	"" );
	T_GET( T_NUMBER,	0x00000000,	"" );

	T_GET( T_END,		0,			"" );
	T_GET( T_END,		0,			"" );

	/* numbers - hexadecimal */
	scan_reset("  0h 0ah 0FH   7FFFFFFFh	"
			   " $0   $a  $F  $7FFFFFFF 	"
			   " #0   #a  #F  #7FFFFFFF		"
			   "0x0  0xa 0xF 0x7FFFFFFF		"
			   "0", 
			   FALSE);
	T_GET( T_NUMBER,	0x00000000,	"" );
	T_GET( T_NUMBER,	0x0000000A,	"" );
	T_GET( T_NUMBER,	0x0000000F,	"" );
	T_GET( T_NUMBER,	0x7FFFFFFF,	"" );

	T_GET( T_NUMBER,	0x00000000,	"" );
	T_GET( T_NUMBER,	0x0000000A,	"" );
	T_GET( T_NUMBER,	0x0000000F,	"" );
	T_GET( T_NUMBER,	0x7FFFFFFF,	"" );

	T_GET( T_NUMBER,	0x00000000,	"" );
	T_GET( T_NUMBER,	0x0000000A,	"" );
	T_GET( T_NUMBER,	0x0000000F,	"" );
	T_GET( T_NUMBER,	0x7FFFFFFF,	"" );

	T_GET( T_NUMBER,	0x00000000,	"" );
	T_GET( T_NUMBER,	0x0000000A,	"" );
	T_GET( T_NUMBER,	0x0000000F,	"" );
	T_GET( T_NUMBER,	0x7FFFFFFF,	"" );
	
	T_GET( T_NUMBER,	0,			"" );
	T_GET( T_END,		0,			"" );
	T_GET( T_END,		0,			"" );
	
	/* very long number > MAXLINE = 1024 --> truncates to 0 */
	scan_reset("0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "0000000000000000000000000000000000000000"
			   "1", 
			   FALSE);
	T_GET( T_NUMBER,	0,			"" );
	T_GET( T_END,		0,			"" );
	T_GET( T_END,		0,			"" );
	
	/* strings - single-quote */
	scan_reset("'		\n"
			   "'a		\n"
			   "''		\n"
			   "'a'		\n"
			   "'aa'	\n"
			   "0", 
			   FALSE);
	T_GET( T_NEWLINE,	0,			"" );
	T_GET( T_NEWLINE,	0,			"" );
	T_GET( T_NEWLINE,	0,			"" );
	T_GET( T_NUMBER,	'a',		"" );
	T_GET( T_NEWLINE,	'a',		"" );
	T_GET( T_NEWLINE,	'a',		"" );
	T_GET( T_NUMBER,	0,			"" );
	T_GET( T_END,		0,			"" );
	T_GET( T_END,		0,			"" );

	/* strings - double-quote */
	scan_reset("\"		\n"
			   "\"a		\n"
			   "\"\"	\n"
			   "\"a\"	\n"
			   "\"aa\"	\n"
			   "\"\"", 
			   FALSE);
	T_GET( T_NEWLINE,	0,			"" );
	T_GET( T_NEWLINE,	0,			"" );
	T_GET( T_STRING,	0,			"" );
	T_GET( T_NEWLINE,	0,			"" );
	T_GET( T_STRING,	0,			"a" );
	T_GET( T_NEWLINE,	0,			"a" );
	T_GET( T_STRING,	0,			"aa" );
	T_GET( T_NEWLINE,	0,			"aa" );
	T_GET( T_STRING,	0,			"" );
	T_GET( T_END,		0,			"" );
	T_GET( T_END,		0,			"" );
		
	/* keywords */
	scan_reset(" add ld nop adc \"\"", 
			   FALSE);
	T_GET( T_ADD,		0,			"" );
	T_GET( T_LD,		0,			"" );
	T_GET( T_NOP,		0,			"" );
	T_GET( T_NAME,		0,			"ADC" );
	T_GET( T_STRING,	0,			"" );
	T_GET( T_END,		0,			"" );
	T_GET( T_END,		0,			"" );

	return 0;
}
END
system("make $objs") and die "make failed: $objs\n";
system($compile) and die "compile failed: $compile\n";

t_capture("test", "", <<'END', 0);
Warning: integer '-2147483648' out of range
Warning: integer '-2147483648' out of range
Warning: integer '0' out of range
Error: invalid single quoted character
Error: invalid single quoted character
Error: invalid single quoted character
Error: invalid single quoted character
Error: unclosed quoted string
Error: unclosed quoted string
END


unlink <test.*>;
done_testing;

sub t_capture {
	my($cmd, $exp_out, $exp_err, $exp_exit) = @_;
	my $line = "[line ".((caller)[2])."]";
	ok 1, "$line command: $cmd";
	
	my($out, $err, $exit) = capture { system $cmd; };
	eq_or_diff_text $out, $exp_out, "$line out";
	eq_or_diff_text $err, $exp_err, "$line err";
	ok !!$exit == !!$exp_exit, "$line exit";
}


# $Log: whitebox-scan.t,v $
# Revision 1.36  2014-02-09 10:16:15  pauloscustodio
# Remove complexity out of scan.rl by relying on srcfile to handle contexts of
# recursive includes, and reading of lines of text, and by assuming scan.c
# will not be reentred, simplifying the keeping of state variables for the scan.
#
# Revision 1.35  2014/02/08 18:30:49  pauloscustodio
# lib/srcfile.c to read source files and handle recursive includes,
# used to read @lists, removed opts.files;
# model.c to hold global data model
#
# Revision 1.34  2014/01/20 23:29:18  pauloscustodio
# Moved file.c to lib/fileutil.c
#
# Revision 1.33  2014/01/11 01:29:46  pauloscustodio
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
