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
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/scan.t,v 1.5 2014-07-02 23:45:12 pauloscustodio Exp $
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
