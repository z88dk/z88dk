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
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/scan.t,v 1.4 2014-06-13 19:16:48 pauloscustodio Exp $
#
# Test scan.rl

use Modern::Perl;
use Test::More;
use File::Slurp;
use Test::Differences; 
require 't/test_utils.pl';

my $objs = "scan.o errors.o model.o module.o codearea.o listfile.o ".
		   "options.o hist.o sym.o symtab.o symref.o expr.o ".
		   "lib/strutil.o lib/strhash.o lib/fileutil.o ".
		   "lib/srcfile.o lib/except.o lib/class.o ".
		   "lib/list.o lib/array.o";
		   
my $init = <<'END';
#include "legacy.h"
#include "scan.h"
#include "symbol.h"
#include <assert.h>

char *GetLibfile( char *filename ) {return NULL;}

#define T_GET( exp_token, exp_text ) \
	token = GetSym(); \
	assert( token == exp_token ); \
	assert( tok   == exp_token ); \
	assert( strcmp( tok_text, exp_text ) == 0 );

#define T_NAME_LABEL( exp_token, exp_text ) \
	T_GET( exp_token, "" ); \
	assert( strcmp( tok_name, exp_text ) == 0 );
	
#define T_NAME(  exp_text ) 		T_NAME_LABEL( TK_NAME,  exp_text );
#define T_LABEL( exp_text ) 		T_NAME_LABEL( TK_LABEL, exp_text );
	
#define T_NUMBER( exp_value ) \
	T_GET( TK_NUMBER, "" ); \
	assert( tok_number == exp_value );
	
#define T_STRING( exp_string ) \
	T_GET( TK_STRING, "" ); \
	assert( strcmp( tok_string, exp_string ) == 0 );
	
#define T_STRING_N( exp_string, n ) \
	T_GET( TK_STRING, "" ); \
	assert( memcmp( tok_string, exp_string, n ) == 0 );
	
#define T_NEWLINE() \
	T_GET( TK_NEWLINE, "\n" ); assert( EOL ); \
	T_GET( TK_NEWLINE, "\n" ); assert( EOL ); \
	T_GET( TK_NEWLINE, "\n" ); assert( EOL ); \
	EOL = FALSE;

#define T_NIL()				T_GET( TK_NIL,			"" );
#define T_EXCLAM()			T_GET( TK_LOG_NOT,		"!" );
#define T_HASH()			T_GET( TK_CONST_EXPR,	"#" );
#define T_PERCENT()			T_GET( TK_MOD,			"%" );

#ifdef __LEGACY_Z80ASM_SYNTAX
#define T_AND()				T_GET( TK_STRING_CAT,	"&" );
#else
#define T_AND()				T_GET( TK_BIN_AND,		"&" );
#endif

#define T_AND_AND()			T_GET( TK_LOG_AND,		"&&" );
#define T_LPAREN()			T_GET( TK_LPAREN,		"(" );
#define T_RPAREN()			T_GET( TK_RPAREN,		")" );
#define T_STAR() 			T_GET( TK_MULTIPLY,		"*" );
#define T_PLUS() 			T_GET( TK_PLUS,			"+" );
#define T_COMMA()			T_GET( TK_COMMA,		"," );
#define T_MINUS()			T_GET( TK_MINUS,		"-" );
#define T_DOT()				T_GET( TK_DOT, 			"." );
#define T_SLASH()			T_GET( TK_DIVIDE, 		"/" );

#ifdef __LEGACY_Z80ASM_SYNTAX
#define T_COLON()			T_GET( TK_BIN_XOR,		":" );
#else
#define T_COLON()			T_GET( TK_COLON,		":" );
#endif

#define T_LT()				T_GET( TK_LESS, 		"<" );
#define T_LT_LT()			T_GET( TK_LEFT_SHIFT,	"<<" );
#define T_LT_EQ()			T_GET( TK_LESS_EQ,		"<=" );
#define T_LT_GT()			T_GET( TK_NOT_EQ,		"<>" );
#define T_EXCLAM_EQ()		T_GET( TK_NOT_EQ,		"!=" );
#define T_EQ()				T_GET( TK_EQUAL, 		"=" );
#define T_EQ_EQ()			T_GET( TK_EQUAL, 		"==" );
#define T_GT()				T_GET( TK_GREATER, 		">" );
#define T_GT_GT()			T_GET( TK_RIGHT_SHIFT,	">>" );
#define T_GT_EQ()			T_GET( TK_GREATER_EQ,	">=" );

#ifdef __LEGACY_Z80ASM_SYNTAX
#define TEXT_QUESTION()		"   "
#define T_QUESTION()		
#else
#define TEXT_QUESTION()		" ? "
#define T_QUESTION()		T_GET( TK_QUESTION,		"?" );
#endif

#define T_LSQUARE()			T_GET( TK_LSQUARE, 		"[" );
#define T_RSQUARE()			T_GET( TK_RSQUARE, 		"]" );

#ifdef __LEGACY_Z80ASM_SYNTAX
#define T_CARET()			T_GET( TK_POWER, 		"^" );
#else
#define T_CARET()			T_GET( TK_BIN_XOR, 		"^" );
#endif

#define T_STAR_STAR()		T_GET( TK_POWER, 		"**" );

#define T_LCURLY()			T_GET( TK_LCURLY, 		"{" );
#define T_VBAR()			T_GET( TK_BIN_OR, 		"|" );
#define T_VBAR_VBAR()		T_GET( TK_LOG_OR, 		"||" );
#define T_RCURLY()			T_GET( TK_RCURLY, 		"}" );

#ifdef __LEGACY_Z80ASM_SYNTAX
#define T_TILDE()			T_GET( TK_BIN_AND, 		"~" );
#else
#define T_TILDE()			T_GET( TK_BIN_NOT, 		"~" );
#endif

#define T_END() \
	T_GET( TK_END, "" ); \
	T_GET( TK_END, "" ); \
	T_GET( TK_END, "" );

END

t_compile_module($init, <<'END', $objs);
	tokid_t token;
	

	SetTemporaryLine("");
	T_END();

	
	/* invalid chars */
	SetTemporaryLine(" \\ hello \n . ");
	T_NIL();
	T_NEWLINE();
	T_DOT();
	T_END();
	
	
	/* at_bol = TRUE */
	SetTemporaryLine("\n \t start \t : \t . start : \n");
	T_NEWLINE();
	T_LABEL("start");
	T_DOT();
	T_NAME("start");
	T_COLON();
	T_NEWLINE();
	T_END();
	
	SetTemporaryLine("\n \t . \t start \t : \t . start : \n");
	T_NEWLINE();
	T_LABEL("start");
	T_COLON();
	T_DOT();
	T_NAME("start");
	T_COLON();
	T_NEWLINE();
	T_END();
	
	SetTemporaryLine("\n \t . \t start \t . start : \n");
	T_NEWLINE();
	T_LABEL("start");
	T_DOT();
	T_NAME("start");
	T_COLON();
	T_NEWLINE();
	T_END();
	
	SetTemporaryLine("\n \t . \t : \t . start : \n");
	T_NEWLINE();
	T_DOT();
	T_COLON();
	T_DOT();
	T_NAME("start");
	T_COLON();
	T_NEWLINE();
	T_END();
	
	
	/* at_bol = FALSE */
	SetTemporaryLine(" \t start \t : \t . start : \n");
	T_NAME("start");
	T_COLON();
	T_DOT();
	T_NAME("start");
	T_COLON();
	T_NEWLINE();
	T_END();
	
	SetTemporaryLine(" \t . \t start \t : \t . start : \n");
	T_DOT();
	T_NAME("start");
	T_COLON();
	T_DOT();
	T_NAME("start");
	T_COLON();
	T_NEWLINE();
	T_END();
	
	SetTemporaryLine(" \t . \t start \t . start : \n");
	T_DOT();
	T_NAME("start");
	T_DOT();
	T_NAME("start");
	T_COLON();
	T_NEWLINE();
	T_END();
	
	SetTemporaryLine(" \t . \t : \t . start : \n");
	T_DOT();
	T_COLON();
	T_DOT();
	T_NAME("start");
	T_COLON();
	T_NEWLINE();
	T_END();
	
	
	/* symbols */
	SetTemporaryLine(" \r\f\v\t ; comment \n ! # % & && ( ) * + , - . / : ; comment ");
	T_NEWLINE();
	T_EXCLAM();
	T_HASH();
	T_PERCENT();
	T_AND();
	T_AND_AND();
	T_LPAREN();
	T_RPAREN();
	T_STAR();
	T_PLUS();
	T_COMMA();
	T_MINUS();
	T_DOT();
	T_SLASH();
	T_COLON();
	T_END();
	
	SetTemporaryLine(" < << <= <> != = == > >> >= ; comment ");
	T_LT();
	T_LT_LT();
	T_LT_EQ();
	T_LT_GT();
	T_EXCLAM_EQ();
	T_EQ();
	T_EQ_EQ();
	T_GT();
	T_GT_GT();
	T_GT_EQ();
	T_END();
	
	SetTemporaryLine( TEXT_QUESTION() " [ ] ^ ** { | || } ~ ; comment ");
	T_QUESTION();
	T_LSQUARE();
	T_RSQUARE();
	T_CARET();
	T_STAR_STAR();
	T_LCURLY();
	T_VBAR();
	T_VBAR_VBAR();
	T_RCURLY();
	T_TILDE();
	T_END();
	
	
	/* names */
	SetTemporaryLine(" _Abc_123 Abc_123 123_Abc_0 0 af' ");
	T_NAME("_Abc_123");	
	T_NAME("Abc_123");
	T_NUMBER(123);
	T_NAME("_Abc_0");
	T_NUMBER(0);
	T_NAME("af'");
	T_END();
	
	
	/* labels */
	SetTemporaryLine(  "\n . abc   . def ghi : . jkl : "
					   "\n   abc : . def ghi : . jkl : "
					   "\n . abc : . def ghi : . jkl : "
					   "\n");
	T_NEWLINE();
	T_LABEL("abc");
	T_DOT();
	T_NAME("def");
	T_NAME("ghi");
	T_COLON();
	T_DOT();
	T_NAME("jkl");
	T_COLON();
	
	T_NEWLINE();
	T_LABEL("abc");
	T_DOT();
	T_NAME("def");
	T_NAME("ghi");
	T_COLON();
	T_DOT();
	T_NAME("jkl");
	T_COLON();

	T_NEWLINE();
	T_LABEL("abc");
	T_COLON();
	T_DOT();
	T_NAME("def");
	T_NAME("ghi");
	T_COLON();
	T_DOT();
	T_NAME("jkl");
	T_COLON();

	T_NEWLINE();
	T_END();
	
	
	/* numbers - decimal */
	SetTemporaryLine("2147483647 2147483648 0 1");
	T_NUMBER(0x7FFFFFFF);
	T_NUMBER(0x80000000);
	T_NUMBER(0);
	T_NUMBER(1);
	T_END();

	
	/* numbers - binary */
	SetTemporaryLine  ("   0000b     0011b      1111111111111111111111111111111b	"
					   "  @0000     @0011      @1111111111111111111111111111111		"
					   " 0b0000    0b0011     0b1111111111111111111111111111111		"
					   "@\"----\" @\"--##\"  @\"###############################\"	"
					   "@\"#\" 														"
					   "@\"#---\"													"
					   "@\"#-------\"												"
					   "@\"#-----------\" 											"
					   "@\"#---------------\" 										"
					   "@\"#-------------------\"									"
					   "@\"#-----------------------\" 								"
					   "@\"#---------------------------\" 							"
					   "@\"#-------------------------------\"						");
	T_NUMBER(0x00000000);
	T_NUMBER(0x00000003);
	T_NUMBER(0x7FFFFFFF);

	T_NUMBER(0x00000000);
	T_NUMBER(0x00000003);
	T_NUMBER(0x7FFFFFFF);

	T_NUMBER(0x00000000);
	T_NUMBER(0x00000003);
	T_NUMBER(0x7FFFFFFF);

	T_NUMBER(0x00000000);
	T_NUMBER(0x00000003);
	T_NUMBER(0x7FFFFFFF);

	T_NUMBER(0x00000001);
	T_NUMBER(0x00000008);
	T_NUMBER(0x00000080);
	T_NUMBER(0x00000800);
	T_NUMBER(0x00008000);
	T_NUMBER(0x00080000);
	T_NUMBER(0x00800000);
	T_NUMBER(0x08000000);
	T_NUMBER(0x80000000);
	T_END();


	/* numbers - hexadecimal */
	SetTemporaryLine(  "  0h  0ah 0FH  7FFFFFFFh	"
					   " $0   $a  $F  $7FFFFFFF 	"
					   "0x0  0xa 0xF 0x7FFFFFFF		"
					   "0");
	T_NUMBER(0x00000000);
	T_NUMBER(0x0000000A);
	T_NUMBER(0x0000000F);
	T_NUMBER(0x7FFFFFFF);

	T_NUMBER(0x00000000);
	T_NUMBER(0x0000000A);
	T_NUMBER(0x0000000F);
	T_NUMBER(0x7FFFFFFF);

	T_NUMBER(0x00000000);
	T_NUMBER(0x0000000A);
	T_NUMBER(0x0000000F);
	T_NUMBER(0x7FFFFFFF);
	
	T_NUMBER(0);
	T_END();
	
	
	/* very long number > MAXLINE = 1024 --> truncates to 0 */
	SetTemporaryLine(  "0000000000000000000000000000000000000000"
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
					   "1");
	T_NUMBER(1);
	T_END();
	
	
	/* strings - single-quote */
	SetTemporaryLine(  "'\n"
					   "'a\n"
					   "''\n"
					   "'a'\n"
					   "'aa'\n"
					   "'\\a''\\b''\\f''\\n''\\r''\\t''\\v'"
					   "'\\\\''\\'''\\0''\\377''\\xff'\n"
					   "0");
	T_NUMBER(0);
	T_NEWLINE();
	
	T_NUMBER(0);
	T_NEWLINE();
	
	T_NUMBER(0);
	T_NEWLINE();
	
	T_NUMBER('a');
	T_NEWLINE();
	
	T_NUMBER(0);
	T_NEWLINE();
	
	T_NUMBER(7); 
	T_NUMBER(8); 
	T_NUMBER(12); 
	T_NUMBER(10); 
	T_NUMBER(13); 
	T_NUMBER(9); 
	T_NUMBER(11); 
	T_NUMBER('\\'); 
	T_NUMBER('\''); 
	T_NUMBER(0); 
	T_NUMBER(-1); 
	T_NUMBER(-1); 
	T_NEWLINE();
	
	T_NUMBER(0);
	T_END();
	

	/* strings - double-quote */
	SetTemporaryLine(  "\"\n"
					   "\"a\n"
					   "\"\"\n"
					   "\"a\"\n"
					   "\"aa\"\n"
					   "\"\"\n"
					   "\"\\a\\b\\f\\n\\r\\t\\v"
					   "\\\\" "\\\"" "\\0\\377\\xff\"\n"
					   "0");
	T_STRING("");
	T_NEWLINE();
	
	T_STRING("");
	T_NEWLINE();
	
	T_STRING("");
	T_NEWLINE();
	
	T_STRING("a");
	T_NEWLINE();
	
	T_STRING("aa");
	T_NEWLINE();
	
	T_STRING("");
	T_NEWLINE();
	
	T_STRING_N("\a\b\f\n\r\t\v\\\"\0\xff\xff", 12);
	T_NEWLINE();
	
	T_NUMBER(0);
	T_END();

	return 0;
END

t_run_module([], '', <<'ERR', 0);
Error: invalid single quoted character
Error: invalid single quoted character
Error: invalid single quoted character
Error: invalid single quoted character
Error: unclosed quoted string
Error: unclosed quoted string
ERR

unlink_testfiles();
done_testing;


# $Log: scan.t,v $
# Revision 1.4  2014-06-13 19:16:48  pauloscustodio
# Remove CreateLibfile() - no longer used
#
# Revision 1.3  2014/05/02 20:24:39  pauloscustodio
# New class Module to replace struct module and struct modules
#
# Revision 1.2  2014/04/19 17:55:51  pauloscustodio
# Update for 64-bit architecture
#
# Revision 1.1  2014/04/06 22:31:42  pauloscustodio
# Renamed whitebox-scan.t scan.t
#
# Revision 1.39  2014/04/05 23:36:11  pauloscustodio
# CH_0024: Case-preserving, case-insensitive symbols
# Symbols no longer converted to upper-case, but still case-insensitive
# searched. Warning when a symbol is used with different case than
# defined. Intermidiate stage before making z80asm case-sensitive, to
# be more C-code friendly.
#
# Revision 1.38  2014/03/30 10:39:51  pauloscustodio
# CH_0023: Accept C-like escape sequences in character constants and strings
# Accepts \a, \b, \e (0x1B), \f, \n, \r, \t, \v, \{any character}, \{octal}, \x{hexadecimal}, allows \0 within the string.
# Existing code may have to be modified, e.g. defb '\' --> defb '\\'
#
# Revision 1.37  2014/03/29 00:33:29  pauloscustodio
# BUG_0044: binary constants with more than 8 bits not accepted
# CH_0022: Added syntax to define binary numbers as bitmaps
# Replaced tokenizer with Ragel based scanner.
# Simplified scanning code by using ragel instead of hand-built scanner
# and tokenizer.
# Removed 'D' suffix to signal decimal number.
# Parse AF' correctly.
# Decimal numbers expressed as sequence of digits, e.g. 1234.
# Hexadecimal numbers either prefixed with '0x' or '$' or suffixed with 'H',
# in which case they need to start with a digit, or start with a zero,
# e.g. 0xFF, $ff, 0FFh.
# Binary numbers either prefixed with '0b' or '@', or suffixed with 'B',
# e.g. 0b10101, @10101, 10101b.
#
# Revision 1.36  2014/02/09 10:16:15  pauloscustodio
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
