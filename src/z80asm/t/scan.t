#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Test scan.rl

use Modern::Perl;
use Test::More;
use File::Slurp;
use Test::Differences; 
require 't/test_utils.pl';

my $objs = "scan.o errors.o error_func.o model.o module.o codearea.o listfile.o ".
		   "options.o hist.o sym.o symtab.o expr.o ".
		   "lib/str.o lib/strhash.o lib/fileutil.o ".
		   "lib/srcfile.o lib/class.o ".
		   "lib/list.o lib/array.o lib/dbg.o";
		   
my $init = <<'END';
#include "scan.h"
#include "symbol.h"
#include <assert.h>

char *GetLibfile( char *filename ) {return NULL;}

#define T_GET_N( exp_token, exp_text, exp_len ) \
	token = GetSym(); \
	assert( token   == exp_token ); \
	assert( sym.tok == exp_token ); \
	assert( sym.tlen == exp_len ); \
	assert( strncmp( sym.tstart, exp_text, sym.tlen ) == 0 );

#define T_GET( exp_token, exp_text ) \
	T_GET_N( exp_token, exp_text, strlen(exp_text) )

#define T_NAME_LABEL( exp_token, exp_text ) \
	T_GET( exp_token, exp_text );
	
#define T_NAME(  exp_text ) 		T_NAME_LABEL( TK_NAME,  exp_text );
#define T_LABEL( exp_text ) 		T_NAME_LABEL( TK_LABEL, exp_text );
	
#define T_NUMBER( exp_value ) \
	T_GET( TK_NUMBER, "" ); \
	assert( sym.number == exp_value );
	
#define T_STRING_N( exp_string, n ) \
	T_GET_N( TK_STRING, exp_string, n ); \
	assert( sym.tlen == n); \
	assert( strncmp( sym.tstart, exp_string, sym.tlen ) == 0 );
	
#define T_STRING( exp_string ) \
	T_STRING_N( exp_string, strlen(exp_string) );
	
#define T_NEWLINE() \
	T_GET( TK_NEWLINE, "\n" ); assert( EOL ); \
	T_GET( TK_NEWLINE, "\n" ); assert( EOL ); \
	T_GET( TK_NEWLINE, "\n" ); assert( EOL ); \
	EOL = FALSE;

#define T_NIL()				T_GET( TK_NIL,			"" );
#define T_EXCLAM()			T_GET( TK_LOG_NOT,		"!" );
#define T_HASH()			T_GET( TK_CONST_EXPR,	"#" );
#define T_PERCENT()			T_GET( TK_MOD,			"%" );

#define T_AND()				T_GET( TK_BIN_AND,		"&" );

#define T_AND_AND()			T_GET( TK_LOG_AND,		"&&" );
#define T_LPAREN()			T_GET( TK_LPAREN,		"(" );
#define T_RPAREN()			T_GET( TK_RPAREN,		")" );
#define T_STAR() 			T_GET( TK_MULTIPLY,		"*" );
#define T_PLUS() 			T_GET( TK_PLUS,			"+" );
#define T_COMMA()			T_GET( TK_COMMA,		"," );
#define T_MINUS()			T_GET( TK_MINUS,		"-" );
#define T_DOT()				T_GET( TK_DOT, 			"." );
#define T_SLASH()			T_GET( TK_DIVIDE, 		"/" );

#define T_COLON()			T_GET( TK_COLON,		":" );

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

#define TEXT_QUESTION()		" ? "
#define T_QUESTION()		T_GET( TK_QUESTION,		"?" );

#define T_LSQUARE()			T_GET( TK_LSQUARE, 		"[" );
#define T_RSQUARE()			T_GET( TK_RSQUARE, 		"]" );

#define T_CARET()			T_GET( TK_BIN_XOR, 		"^" );

#define T_STAR_STAR()		T_GET( TK_POWER, 		"**" );

#define T_LCURLY()			T_GET( TK_LCURLY, 		"{" );
#define T_VBAR()			T_GET( TK_BIN_OR, 		"|" );
#define T_VBAR_VBAR()		T_GET( TK_LOG_OR, 		"||" );
#define T_RCURLY()			T_GET( TK_RCURLY, 		"}" );

#define T_TILDE()			T_GET( TK_BIN_NOT, 		"~" );

#define T_END() \
	T_GET( TK_END, "" ); \
	T_GET( TK_END, "" ); \
	T_GET( TK_END, "" );

#define T_Z80		1
#define T_RABBIT	2
#define T_ALL		3

#define T_OPCODE1(opcode, opcode_cmp) \
			SetTemporaryLine(string); \
			scan_expect_opcode(); \
			T_GET(TK_##opcode, opcode_cmp); \
			T_NAME(opcode_cmp); \
			T_END(); \
			SetTemporaryLine(string); \
			scan_expect_operands(); \
			T_NAME(opcode_cmp); \
			T_NAME(opcode_cmp); \
			T_END();

#define T_OPCODE2(opcode, opcode_cmp, _cpu) \
		if (_cpu & CPU_Z80) { \
			opts.cpu &= ~CPU_RABBIT; \
			T_OPCODE1(opcode, opcode_cmp); \
		} \
		if (_cpu & CPU_RABBIT) { \
			opts.cpu |= CPU_RABBIT; \
			T_OPCODE1(opcode, opcode_cmp); \
		}

#define T_OPCODE(opcode, _cpu)	\
		strcpy(opcode_lcase, #opcode); \
		stolower(opcode_lcase); \
		strcpy(string, #opcode " " #opcode); \
		stolower(string); \
		T_OPCODE2(opcode, opcode_lcase, _cpu); \
		stoupper(string); \
		T_OPCODE2(opcode, #opcode, _cpu);

END

t_compile_module($init, <<'END', $objs);
	tokid_t token;
	char string[MAXLINE];
	char opcode_lcase[MAXLINE];
	

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
	SetTemporaryLine(" _Abc_123 Abc_123 123_Abc_0 0 ");
	T_NAME("_Abc_123");	
	T_NAME("Abc_123");
	T_NUMBER(123);
	T_NAME("_Abc_0");
	T_NUMBER(0);
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
					   "  %0000     %0011      %1111111111111111111111111111111		"
					   " 0b0000    0b0011     0b1111111111111111111111111111111		"
					   "@\"----\" @\"--##\"  @\"###############################\"	"
					   "%\"----\" %\"--##\"  %\"###############################\"	"
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

	/* keywords */
	SetTemporaryLine("nz z nc c po pe p m "
					 "NZ Z NC C PO PE P M ");
	T_GET(TK_NZ, "nz"); 
	T_GET(TK_Z,  "z");  
	T_GET(TK_NC, "nc"); 
	T_GET(TK_C,  "c");  
	T_GET(TK_PO, "po"); 
	T_GET(TK_PE, "pe"); 
	T_GET(TK_P,  "p");  
	T_GET(TK_M,  "m");  

	T_GET(TK_NZ, "NZ"); 
	T_GET(TK_Z,  "Z");  
	T_GET(TK_NC, "NC"); 
	T_GET(TK_C,  "C");  
	T_GET(TK_PO, "PO"); 
	T_GET(TK_PE, "PE"); 
	T_GET(TK_P,  "P");  
	T_GET(TK_M,  "M");  
	T_END();

	SetTemporaryLine("b c d e h l a ixh ixl iyh iyl "
					 "B C D E H L A IXH IXL IYH IYL ");
	T_GET(TK_B,   "b");   
	T_GET(TK_C,   "c");   
	T_GET(TK_D,   "d");   
	T_GET(TK_E,   "e");   
	T_GET(TK_H,   "h");   
	T_GET(TK_L,   "l");   
	T_GET(TK_A,   "a");   
	T_GET(TK_IXH, "ixh"); 
	T_GET(TK_IXL, "ixl"); 
	T_GET(TK_IYH, "iyh"); 
	T_GET(TK_IYL, "iyl"); 
	
	T_GET(TK_B,   "B");   
	T_GET(TK_C,   "C");   
	T_GET(TK_D,   "D");   
	T_GET(TK_E,   "E");   
	T_GET(TK_H,   "H");   
	T_GET(TK_L,   "L");   
	T_GET(TK_A,   "A");   
	T_GET(TK_IXH, "IXH"); 
	T_GET(TK_IXL, "IXL"); 
	T_GET(TK_IYH, "IYH"); 
	T_GET(TK_IYL, "IYL"); 
	T_END();
	
	SetTemporaryLine("f (c) (\t c \t) "
					 "F (C) (\t C \t) ");
	T_GET(TK_F,     "f");
	T_GET(TK_IND_C, "(c)");
	T_GET(TK_IND_C, "(\t c \t)");
					 
	T_GET(TK_F,     "F");
	T_GET(TK_IND_C, "(C)");
	T_GET(TK_IND_C, "(\t C \t)");
	T_END();
					 
	SetTemporaryLine("bc de hl af af' sp ix iy "
					 "BC DE HL AF AF' SP IX IY ");
	T_GET(TK_BC,  "bc");  
	T_GET(TK_DE,  "de");  
	T_GET(TK_HL,  "hl");  
	T_GET(TK_AF,  "af");  
	T_GET(TK_AF1, "af'"); 
	T_GET(TK_SP,  "sp");  
	T_GET(TK_IX,  "ix");  
	T_GET(TK_IY,  "iy");  
	
	T_GET(TK_BC,  "BC");  
	T_GET(TK_DE,  "DE");  
	T_GET(TK_HL,  "HL");  
	T_GET(TK_AF,  "AF");  
	T_GET(TK_AF1, "AF'"); 
	T_GET(TK_SP,  "SP");  
	T_GET(TK_IX,  "IX");  
	T_GET(TK_IY,  "IY");  
	T_END();
	
	SetTemporaryLine("(bc) (de) (hl) (sp) (\t bc \t) (\t de \t) (\t hl \t) (\t sp \t) "
					 "(BC) (DE) (HL) (SP) (\t BC \t) (\t DE \t) (\t HL \t) (\t SP \t) ");
	T_GET(TK_IND_BC, "(bc)"); 
	T_GET(TK_IND_DE, "(de)"); 
	T_GET(TK_IND_HL, "(hl)"); 
	T_GET(TK_IND_SP, "(sp)"); 

	T_GET(TK_IND_BC, "(\t bc \t)"); 
	T_GET(TK_IND_DE, "(\t de \t)"); 
	T_GET(TK_IND_HL, "(\t hl \t)"); 
	T_GET(TK_IND_SP, "(\t sp \t)"); 
	
	T_GET(TK_IND_BC, "(BC)"); 
	T_GET(TK_IND_DE, "(DE)"); 
	T_GET(TK_IND_HL, "(HL)"); 
	T_GET(TK_IND_SP, "(SP)"); 
	
	T_GET(TK_IND_BC, "(\t BC \t)");
	T_GET(TK_IND_DE, "(\t DE \t)");
	T_GET(TK_IND_HL, "(\t HL \t)");
	T_GET(TK_IND_SP, "(\t SP \t)");
	T_END();
	
	SetTemporaryLine("(ix) (iy) (\t ix \t) (\t iy \t) "
					 "(IX) (IY) (\t IX \t) (\t IY \t) ");
	T_GET(TK_IND_IX, "(ix");  
	T_RPAREN();
	T_GET(TK_IND_IY, "(iy");  
	T_RPAREN();
	T_GET(TK_IND_IX, "(\t ix \t");  
	T_RPAREN();
	T_GET(TK_IND_IY, "(\t iy \t");  
	T_RPAREN();
	
	T_GET(TK_IND_IX, "(IX");  
	T_RPAREN();
	T_GET(TK_IND_IY, "(IY");  
	T_RPAREN();
	T_GET(TK_IND_IX, "(\t IX \t");  
	T_RPAREN();
	T_GET(TK_IND_IY, "(\t IY \t");  
	T_RPAREN();
	T_END();
	
	SetTemporaryLine("( \t ix \t ) ( \t ix \t + \t 0 \t ) ( \t ix \t - \t 0 \t ) "
					 "( \t iy \t ) ( \t iy \t + \t 0 \t ) ( \t iy \t - \t 0 \t ) "
					 "( \t IX \t ) ( \t IX \t + \t 0 \t ) ( \t IX \t - \t 0 \t ) "
					 "( \t IY \t ) ( \t IY \t + \t 0 \t ) ( \t IY \t - \t 0 \t ) "
					 );
	T_GET(TK_IND_IX, "( \t ix \t ");
	T_RPAREN();
	T_GET(TK_IND_IX, "( \t ix \t ");
	T_PLUS();
	T_NUMBER(0);
	T_RPAREN();
	T_GET(TK_IND_IX, "( \t ix \t ");
	T_MINUS();
	T_NUMBER(0);
	T_RPAREN();
	
	T_GET(TK_IND_IY, "( \t iy \t ");
	T_RPAREN();
	T_GET(TK_IND_IY, "( \t iy \t ");
	T_PLUS();
	T_NUMBER(0);
	T_RPAREN();
	T_GET(TK_IND_IY, "( \t iy \t ");
	T_MINUS();
	T_NUMBER(0);
	T_RPAREN();
	
	T_GET(TK_IND_IX, "( \t IX \t ");
	T_RPAREN();
	T_GET(TK_IND_IX, "( \t IX \t ");
	T_PLUS();
	T_NUMBER(0);
	T_RPAREN();
	T_GET(TK_IND_IX, "( \t IX \t ");
	T_MINUS();
	T_NUMBER(0);
	T_RPAREN();
	
	T_GET(TK_IND_IY, "( \t IY \t ");
	T_RPAREN();
	T_GET(TK_IND_IY, "( \t IY \t ");
	T_PLUS();
	T_NUMBER(0);
	T_RPAREN();
	T_GET(TK_IND_IY, "( \t IY \t ");
	T_MINUS();
	T_NUMBER(0);
	T_RPAREN();
	T_END();

	SetTemporaryLine("ds.b ds.w ds.p ds.q "
					 "DS.B DS.W DS.P DS.Q ");
	T_GET(TK_DS_B, "ds.b"); 
	T_GET(TK_DS_W, "ds.w"); 
	T_GET(TK_DS_P, "ds.p"); 
	T_GET(TK_DS_Q, "ds.q"); 

	T_GET(TK_DS_B, "DS.B"); 
	T_GET(TK_DS_W, "DS.W"); 
	T_GET(TK_DS_P, "DS.P"); 
	T_GET(TK_DS_Q, "DS.Q"); 
	T_END();

	
	/* assembly operands */
	SetTemporaryLine("i r I R iir eir IIR EIR ");
	scan_expect_operands();
	T_GET(TK_I,    "i");
	T_GET(TK_R,    "r");
	T_GET(TK_I,    "I");
	T_GET(TK_R,    "R");
	T_GET(TK_IIR,   "iir");
	T_GET(TK_EIR,   "eir");
	T_GET(TK_IIR,   "IIR");
	T_GET(TK_EIR,   "EIR");
	T_END();

	
	/* assembly directives */
	T_OPCODE(BINARY,	T_ALL);
	T_OPCODE(DEFB,		T_ALL);
	T_OPCODE(DEFC,		T_ALL);
	T_OPCODE(DEFGROUP,	T_ALL);
	T_OPCODE(DEFINE,	T_ALL);
	T_OPCODE(DEFQ,		T_ALL);
	T_OPCODE(DEFM,		T_ALL);
	T_OPCODE(DEFS,		T_ALL);
	T_OPCODE(DEFVARS,	T_ALL);
	T_OPCODE(DEFW,		T_ALL);
	T_OPCODE(ELSE,		T_ALL);
	T_OPCODE(ENDIF,		T_ALL);
	T_OPCODE(EXTERN,	T_ALL);
	T_OPCODE(GLOBAL,	T_ALL);
	T_OPCODE(IF,		T_ALL);
	T_OPCODE(IFDEF,		T_ALL);
	T_OPCODE(IFNDEF,	T_ALL);
	T_OPCODE(INCLUDE,	T_ALL);
	T_OPCODE(LINE,		T_ALL);
	T_OPCODE(LSTOFF,	T_ALL);
	T_OPCODE(LSTON,		T_ALL);
	T_OPCODE(MODULE,	T_ALL);
	T_OPCODE(ORG,		T_ALL);
	T_OPCODE(PUBLIC,	T_ALL);
	T_OPCODE(SECTION,	T_ALL);
	T_OPCODE(UNDEFINE,	T_ALL);
	
	/* assembly opcodes */
	T_OPCODE(ADC,	T_ALL);
	T_OPCODE(ADD,	T_ALL);
	T_OPCODE(AND,	T_ALL);
	T_OPCODE(BIT,  	T_ALL)
	T_OPCODE(CALL,	T_ALL);
	T_OPCODE(CCF,	T_ALL);
	T_OPCODE(CP,	T_ALL);
	T_OPCODE(CPD,	T_ALL);
	T_OPCODE(CPDR,	T_ALL);
	T_OPCODE(CPI,	T_ALL);
	T_OPCODE(CPIR,	T_ALL);
	T_OPCODE(CPL,	T_ALL);
	T_OPCODE(DAA,	T_Z80);
	T_OPCODE(DEC,	T_ALL);
	T_OPCODE(DI,	T_Z80);
	T_OPCODE(DJNZ,	T_ALL);
	T_OPCODE(EI,	T_Z80);
	T_OPCODE(EX,	T_ALL);
	T_OPCODE(EXX,	T_ALL);
	T_OPCODE(HALT,	T_Z80);
	T_OPCODE(IM,	T_Z80);
	T_OPCODE(IN,	T_Z80);
	T_OPCODE(INC,	T_ALL);
	T_OPCODE(IND,	T_Z80);
	T_OPCODE(INDR,	T_Z80);
	T_OPCODE(INI,	T_Z80);
	T_OPCODE(INIR,	T_Z80);
	T_OPCODE(JP,	T_ALL);
	T_OPCODE(JR,	T_ALL);
	T_OPCODE(LD,	T_ALL);
	T_OPCODE(LDD,	T_ALL);
	T_OPCODE(LDDR,	T_ALL);
	T_OPCODE(LDI,	T_ALL);
	T_OPCODE(LDIR,	T_ALL);
	T_OPCODE(NEG,	T_ALL);
	T_OPCODE(NOP,	T_ALL);
	T_OPCODE(OR,	T_ALL);
	T_OPCODE(OTDR,	T_Z80);
	T_OPCODE(OTIR,	T_Z80);
	T_OPCODE(OUT,	T_Z80);
	T_OPCODE(OUTD,	T_Z80);
	T_OPCODE(OUTI,	T_Z80);
	T_OPCODE(POP,	T_ALL);
	T_OPCODE(PUSH,	T_ALL);
	T_OPCODE(RES,  	T_ALL)
	T_OPCODE(RET,	T_ALL);
	T_OPCODE(RETI,	T_ALL);
	T_OPCODE(RETN,	T_Z80);
	T_OPCODE(RL,   	T_ALL)
	T_OPCODE(RLA,  	T_ALL);
	T_OPCODE(RLC,  	T_ALL)
	T_OPCODE(RLCA, 	T_ALL);
	T_OPCODE(RLD,	T_ALL);
	T_OPCODE(RR,   	T_ALL)
	T_OPCODE(RRA,  	T_ALL);
	T_OPCODE(RRC,  	T_ALL)
	T_OPCODE(RRCA, 	T_ALL);
	T_OPCODE(RRD,	T_ALL);
	T_OPCODE(RST,	T_ALL);
	T_OPCODE(SBC,	T_ALL);
	T_OPCODE(SCF,	T_ALL);
	T_OPCODE(SET,  	T_ALL)
	T_OPCODE(SLA,  	T_ALL)
	T_OPCODE(SLL,  	T_Z80)
	T_OPCODE(SRA,  	T_ALL)
	T_OPCODE(SRL,  	T_ALL)
	T_OPCODE(SUB,	T_ALL);
	T_OPCODE(XOR,	T_ALL);
	
	/* Z88DK specific opcodes */
	T_OPCODE(CALL_OZ,	T_ALL);
	T_OPCODE(CALL_PKG,	T_ALL);
	T_OPCODE(FPP,		T_ALL);
	T_OPCODE(INVOKE,	T_ALL);
	
	/* check limit cases */
	SetTemporaryLine("ld(ix_save+2),ix "
					 "ld ( ix_save + 2 ) , ix ");
	T_NAME("ld");
	T_LPAREN();
	T_NAME("ix_save");
	T_PLUS();
	T_NUMBER(2);
	T_RPAREN();
	T_COMMA();
	T_GET(TK_IX, "ix");

	T_NAME("ld");
	T_LPAREN();
	T_NAME("ix_save");
	T_PLUS();
	T_NUMBER(2);
	T_RPAREN();
	T_COMMA();
	T_GET(TK_IX, "ix");
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
