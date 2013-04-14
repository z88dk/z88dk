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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-scan.t,v 1.4 2013-04-14 18:17:00 pauloscustodio Exp $
# $Log: whitebox-scan.t,v $
# Revision 1.4  2013-04-14 18:17:00  pauloscustodio
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
ok ! system "make $objs";
my $compile = "-DMEMALLOC_DEBUG memalloc.c $objs";
my $init = <<'END_INIT';
#define ERROR return __LINE__
#define ASSERT(expr) \
			if ( ! (expr) ) { \
				warn("TEST FAILED (%s) at file %s, line %d\n", \
					 #expr, __FILE__, __LINE__); \
				ERROR; \
			} \
			else

#define CASE_TOK(a)	case TOK_##a : return #a;
char *decode_token (TokType tok_type)
{
	static char token_str[16];
	
	switch (tok_type) {
		CASE_TOK( NULL			)
		CASE_TOK( NEWLINE		)
		CASE_TOK( EXCLAM		)
		CASE_TOK( HASH			)
		CASE_TOK( DOLLAR		)
		CASE_TOK( PERCENT		)
		CASE_TOK( AMPERSAND		)
		CASE_TOK( LPAREN		)
		CASE_TOK( RPAREN		)
		CASE_TOK( ASTERISK		)
		CASE_TOK( PLUS			)
		CASE_TOK( COMMA			)
		CASE_TOK( HYPHEN		)
		CASE_TOK( PERIOD		)
		CASE_TOK( SLASH			)
		CASE_TOK( COLON			)
		CASE_TOK( LESS			)
		CASE_TOK( EQUAL			)
		CASE_TOK( GREATER		)
		CASE_TOK( QUESTION		)
		CASE_TOK( ATSIGN		)
		CASE_TOK( LSQUARE		)
		CASE_TOK( BACKSLASH		)
		CASE_TOK( RSQUARE		)
		CASE_TOK( CARET			)
		CASE_TOK( BACKQUOTE		)
		CASE_TOK( LCURLY		)
		CASE_TOK( VBAR			)
		CASE_TOK( RCURLY		)
		CASE_TOK( TILDE			)
		CASE_TOK( EQUAL_EQUAL	)
		CASE_TOK( LESS_GREATER	)
		CASE_TOK( NOT_EQUAL		)
		CASE_TOK( LESS_EQUAL	)
		CASE_TOK( GREATER_EQUAL	)
		CASE_TOK( DBL_VBAR		)
		CASE_TOK( DBL_AMPERSAND	)
		CASE_TOK( DBL_LESS		)
		CASE_TOK( DBL_GREATER	)
		CASE_TOK( DBL_ASTERISK	)
		CASE_TOK( NAME			)
		CASE_TOK( NUMBER		)
		CASE_TOK( STRING		)
		
		default:	
			sprintf(token_str, "tok(%d)", tok_type);
			return token_str;
	}
}

TokType next_token (void)
{
	TokType tok_type;
	Token *token;
	char *token_str;
	
	tok_type = scan_get();
	token = scan_token(0);
	
	ASSERT( tok_type == scan_tok_type(0) );
	if ( tok_type == TOK_NULL )
	{
		ASSERT( token == NULL );
		ASSERT( TOK_NULL 	== scan_tok_type(0) );
		ASSERT( 0		 	== scan_num_value(0) );
		ASSERT( strcmp( "", scan_str_value(0) ) == 0 );
		ASSERT( NULL	 	== scan_filename(0) );
		ASSERT( 0		 	== scan_line_nr(0) );
	}
	else
	{
		ASSERT( token != NULL );
		ASSERT( token->tok_type 	== scan_tok_type(0) );
		ASSERT( token->num_value 	== scan_num_value(0) );
		ASSERT( strcmp( Str_data( token->str_value ), scan_str_value(0) ) == 0 );
		ASSERT( token->filename 	== scan_filename(0) );
		ASSERT( token->line_nr	 	== scan_line_nr(0) );
	}
	
	token_str = decode_token(tok_type);
	
	warn( "Token: %s(%d) %s", 
		  scan_filename(0) ? scan_filename(0) : "", 
		  scan_line_nr(0), token_str );
	switch (tok_type) {
		case TOK_NAME:
			warn(" %s", scan_str_value(0) );
			break;
		case TOK_STRING:
			warn(" '%s'", scan_str_value(0) );
			break;
		case TOK_NUMBER:
			warn(" %ld", scan_num_value(0) );
			break;
		default:
			break;
	}
	warn("\n");
	
	return tok_type;
}

void n_tokens (int n)
{
	Token *token;
	TokType t;
	
	while ( n != 0 ) 
	{
		n--;
		t = next_token();
		if ( t == TOK_NULL )
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
	char buffer[MAXLINE];
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


# tests without error catching
t_compile_module($init, <<'END', $compile);
	
	add_source_file_path("x1");
	add_source_file_path("x2");
	add_source_file_path("x3");
	
	warn("Test: Read before start\n");
	n_tokens( -1 );

	warn("Test: push text once\n");
	scan_text(" \f \n \t \r 1 2 3 a b c \n ");
	n_tokens( -1 );
	
	warn("Test: push text twice\n");
	scan_text(" \f \n \t \r 1 2 3 a b c \n ");
	scan_text("defc c=2;hello\ndefc d=3;hello\rworld\r\n");
	n_tokens( -1 );

	warn("Test: push text in middle of reading\n");
	scan_text(" \f \n \t \r 1 2 3 a b c \n ");
	n_tokens( 4 );

	scan_text("defc c=2;hello\ndefc d=3;hello\rworld\r\n");
	n_tokens( -1 );

	warn("Test: open text file\n");
	scan_file("f0");
	n_tokens( 7 );
	
	scan_text("defc c=2;hello\ndefc d=3;hello\rworld\r\n");
	n_tokens( 13 );
	
	scan_file("f1");
	n_tokens( -1 );

	scan_file("f2");
	n_tokens( -1 );
	
	/* look-ahead tokens */
	scan_text("a b c");
	ASSERT( scan_tok_type(0) == TOK_NAME );
	ASSERT( scan_tok_type(1) == TOK_NAME );
	ASSERT( scan_tok_type(2) == TOK_NAME );
	ASSERT( strcmp( scan_str_value(0), "A" ) == 0 );
	ASSERT( strcmp( scan_str_value(1), "B" ) == 0 );
	ASSERT( strcmp( scan_str_value(2), "C" ) == 0 );
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
memalloc scan_context.c(2): alloc 40 bytes at ADDR_14
Token: (0) NULL
Token: (0) NULL
Test: push text once
memalloc scan_context.c(1): alloc 64 bytes at ADDR_15
memalloc scan_struct.c(1): alloc 40 bytes at ADDR_16
memalloc scan_token.c(2): alloc 56 bytes at ADDR_17
memalloc scan_token.c(1): alloc 48 bytes at ADDR_18
memalloc dynstr.c(1): alloc 40 bytes at ADDR_19
memalloc dynstr.c(3): alloc 256 bytes at ADDR_20
memalloc scan_token.c(1): alloc 48 bytes at ADDR_21
memalloc dynstr.c(1): alloc 40 bytes at ADDR_22
memalloc dynstr.c(3): alloc 256 bytes at ADDR_23
memalloc scan_token.c(1): alloc 48 bytes at ADDR_24
memalloc dynstr.c(1): alloc 40 bytes at ADDR_25
memalloc dynstr.c(3): alloc 256 bytes at ADDR_26
memalloc scan_token.c(1): alloc 48 bytes at ADDR_27
memalloc dynstr.c(1): alloc 40 bytes at ADDR_28
memalloc dynstr.c(3): alloc 256 bytes at ADDR_29
memalloc scan_token.c(1): alloc 48 bytes at ADDR_30
memalloc dynstr.c(1): alloc 40 bytes at ADDR_31
memalloc dynstr.c(3): alloc 256 bytes at ADDR_32
memalloc scan.c(1): alloc 92 bytes at ADDR_33
memalloc scan_context.c(2): alloc 12 bytes at ADDR_34
memalloc scan.c(1): alloc 25 bytes at ADDR_35
memalloc scan.c(1): alloc 48 bytes at ADDR_36
memalloc scan.c(1): alloc 4 bytes at ADDR_37
Token: (0) NEWLINE
Token: (0) NEWLINE
Token: (0) NUMBER 1
Token: (0) NUMBER 2
Token: (0) NUMBER 3
Token: (0) NAME A
Token: (0) NAME B
Token: (0) NAME C
Token: (0) NEWLINE
memalloc scan_context.c(2): free 12 bytes at ADDR_34 allocated at scan_context.c(2)
memalloc scan.c(2): free 25 bytes at ADDR_35 allocated at scan.c(1)
memalloc scan.c(2): free 48 bytes at ADDR_36 allocated at scan.c(1)
memalloc scan.c(2): free 4 bytes at ADDR_37 allocated at scan.c(1)
memalloc scan.c(2): free 92 bytes at ADDR_33 allocated at scan.c(1)
memalloc scan_struct.c(1): free 40 bytes at ADDR_16 allocated at scan_struct.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_20 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_19 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_18 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_23 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_22 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_21 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_26 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_25 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_24 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_29 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_28 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_27 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_32 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_31 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_30 allocated at scan_token.c(1)
memalloc scan_token.c(2): free 56 bytes at ADDR_17 allocated at scan_token.c(2)
memalloc scan_context.c(1): free 64 bytes at ADDR_15 allocated at scan_context.c(1)
Token: (0) NULL
Token: (0) NULL
Test: push text twice
memalloc scan_context.c(1): alloc 64 bytes at ADDR_38
memalloc scan_struct.c(1): alloc 40 bytes at ADDR_39
memalloc scan_token.c(2): alloc 56 bytes at ADDR_40
memalloc scan_token.c(1): alloc 48 bytes at ADDR_41
memalloc dynstr.c(1): alloc 40 bytes at ADDR_42
memalloc dynstr.c(3): alloc 256 bytes at ADDR_43
memalloc scan_token.c(1): alloc 48 bytes at ADDR_44
memalloc dynstr.c(1): alloc 40 bytes at ADDR_45
memalloc dynstr.c(3): alloc 256 bytes at ADDR_46
memalloc scan_token.c(1): alloc 48 bytes at ADDR_47
memalloc dynstr.c(1): alloc 40 bytes at ADDR_48
memalloc dynstr.c(3): alloc 256 bytes at ADDR_49
memalloc scan_token.c(1): alloc 48 bytes at ADDR_50
memalloc dynstr.c(1): alloc 40 bytes at ADDR_51
memalloc dynstr.c(3): alloc 256 bytes at ADDR_52
memalloc scan_token.c(1): alloc 48 bytes at ADDR_53
memalloc dynstr.c(1): alloc 40 bytes at ADDR_54
memalloc dynstr.c(3): alloc 256 bytes at ADDR_55
memalloc scan.c(1): alloc 92 bytes at ADDR_56
memalloc scan_context.c(2): alloc 12 bytes at ADDR_57
memalloc scan.c(1): alloc 25 bytes at ADDR_58
memalloc scan.c(1): alloc 48 bytes at ADDR_59
memalloc scan.c(1): alloc 4 bytes at ADDR_60
memalloc scan_context.c(1): alloc 64 bytes at ADDR_61
memalloc scan_struct.c(1): alloc 40 bytes at ADDR_62
memalloc scan_token.c(2): alloc 56 bytes at ADDR_63
memalloc scan_token.c(1): alloc 48 bytes at ADDR_64
memalloc dynstr.c(1): alloc 40 bytes at ADDR_65
memalloc dynstr.c(3): alloc 256 bytes at ADDR_66
memalloc scan_token.c(1): alloc 48 bytes at ADDR_67
memalloc dynstr.c(1): alloc 40 bytes at ADDR_68
memalloc dynstr.c(3): alloc 256 bytes at ADDR_69
memalloc scan_token.c(1): alloc 48 bytes at ADDR_70
memalloc dynstr.c(1): alloc 40 bytes at ADDR_71
memalloc dynstr.c(3): alloc 256 bytes at ADDR_72
memalloc scan_token.c(1): alloc 48 bytes at ADDR_73
memalloc dynstr.c(1): alloc 40 bytes at ADDR_74
memalloc dynstr.c(3): alloc 256 bytes at ADDR_75
memalloc scan_token.c(1): alloc 48 bytes at ADDR_76
memalloc dynstr.c(1): alloc 40 bytes at ADDR_77
memalloc dynstr.c(3): alloc 256 bytes at ADDR_78
memalloc scan.c(1): alloc 92 bytes at ADDR_79
memalloc scan_context.c(2): alloc 12 bytes at ADDR_80
memalloc scan.c(1): alloc 39 bytes at ADDR_81
memalloc scan.c(1): alloc 48 bytes at ADDR_82
memalloc scan.c(1): alloc 4 bytes at ADDR_83
Token: (0) NAME DEFC
Token: (0) NAME C
Token: (0) EQUAL
Token: (0) NUMBER 2
Token: (0) NEWLINE
Token: (0) NAME DEFC
Token: (0) NAME D
Token: (0) EQUAL
Token: (0) NUMBER 3
Token: (0) NEWLINE
memalloc scan_context.c(2): free 12 bytes at ADDR_80 allocated at scan_context.c(2)
memalloc scan.c(2): free 39 bytes at ADDR_81 allocated at scan.c(1)
memalloc scan.c(2): free 48 bytes at ADDR_82 allocated at scan.c(1)
memalloc scan.c(2): free 4 bytes at ADDR_83 allocated at scan.c(1)
memalloc scan.c(2): free 92 bytes at ADDR_79 allocated at scan.c(1)
memalloc scan_struct.c(1): free 40 bytes at ADDR_62 allocated at scan_struct.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_66 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_65 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_64 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_69 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_68 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_67 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_72 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_71 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_70 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_75 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_74 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_73 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_78 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_77 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_76 allocated at scan_token.c(1)
memalloc scan_token.c(2): free 56 bytes at ADDR_63 allocated at scan_token.c(2)
memalloc scan_context.c(1): free 64 bytes at ADDR_61 allocated at scan_context.c(1)
Token: (0) NEWLINE
Token: (0) NEWLINE
Token: (0) NUMBER 1
Token: (0) NUMBER 2
Token: (0) NUMBER 3
Token: (0) NAME A
Token: (0) NAME B
Token: (0) NAME C
Token: (0) NEWLINE
memalloc scan_context.c(2): free 12 bytes at ADDR_57 allocated at scan_context.c(2)
memalloc scan.c(2): free 25 bytes at ADDR_58 allocated at scan.c(1)
memalloc scan.c(2): free 48 bytes at ADDR_59 allocated at scan.c(1)
memalloc scan.c(2): free 4 bytes at ADDR_60 allocated at scan.c(1)
memalloc scan.c(2): free 92 bytes at ADDR_56 allocated at scan.c(1)
memalloc scan_struct.c(1): free 40 bytes at ADDR_39 allocated at scan_struct.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_43 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_42 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_41 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_46 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_45 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_44 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_49 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_48 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_47 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_52 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_51 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_50 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_55 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_54 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_53 allocated at scan_token.c(1)
memalloc scan_token.c(2): free 56 bytes at ADDR_40 allocated at scan_token.c(2)
memalloc scan_context.c(1): free 64 bytes at ADDR_38 allocated at scan_context.c(1)
Token: (0) NULL
Token: (0) NULL
Test: push text in middle of reading
memalloc scan_context.c(1): alloc 64 bytes at ADDR_84
memalloc scan_struct.c(1): alloc 40 bytes at ADDR_85
memalloc scan_token.c(2): alloc 56 bytes at ADDR_86
memalloc scan_token.c(1): alloc 48 bytes at ADDR_87
memalloc dynstr.c(1): alloc 40 bytes at ADDR_88
memalloc dynstr.c(3): alloc 256 bytes at ADDR_89
memalloc scan_token.c(1): alloc 48 bytes at ADDR_90
memalloc dynstr.c(1): alloc 40 bytes at ADDR_91
memalloc dynstr.c(3): alloc 256 bytes at ADDR_92
memalloc scan_token.c(1): alloc 48 bytes at ADDR_93
memalloc dynstr.c(1): alloc 40 bytes at ADDR_94
memalloc dynstr.c(3): alloc 256 bytes at ADDR_95
memalloc scan_token.c(1): alloc 48 bytes at ADDR_96
memalloc dynstr.c(1): alloc 40 bytes at ADDR_97
memalloc dynstr.c(3): alloc 256 bytes at ADDR_98
memalloc scan_token.c(1): alloc 48 bytes at ADDR_99
memalloc dynstr.c(1): alloc 40 bytes at ADDR_100
memalloc dynstr.c(3): alloc 256 bytes at ADDR_101
memalloc scan.c(1): alloc 92 bytes at ADDR_102
memalloc scan_context.c(2): alloc 12 bytes at ADDR_103
memalloc scan.c(1): alloc 25 bytes at ADDR_104
memalloc scan.c(1): alloc 48 bytes at ADDR_105
memalloc scan.c(1): alloc 4 bytes at ADDR_106
Token: (0) NEWLINE
Token: (0) NEWLINE
Token: (0) NUMBER 1
Token: (0) NUMBER 2
memalloc scan_context.c(1): alloc 64 bytes at ADDR_107
memalloc scan_struct.c(1): alloc 40 bytes at ADDR_108
memalloc scan_token.c(2): alloc 56 bytes at ADDR_109
memalloc scan_token.c(1): alloc 48 bytes at ADDR_110
memalloc dynstr.c(1): alloc 40 bytes at ADDR_111
memalloc dynstr.c(3): alloc 256 bytes at ADDR_112
memalloc scan_token.c(1): alloc 48 bytes at ADDR_113
memalloc dynstr.c(1): alloc 40 bytes at ADDR_114
memalloc dynstr.c(3): alloc 256 bytes at ADDR_115
memalloc scan_token.c(1): alloc 48 bytes at ADDR_116
memalloc dynstr.c(1): alloc 40 bytes at ADDR_117
memalloc dynstr.c(3): alloc 256 bytes at ADDR_118
memalloc scan_token.c(1): alloc 48 bytes at ADDR_119
memalloc dynstr.c(1): alloc 40 bytes at ADDR_120
memalloc dynstr.c(3): alloc 256 bytes at ADDR_121
memalloc scan_token.c(1): alloc 48 bytes at ADDR_122
memalloc dynstr.c(1): alloc 40 bytes at ADDR_123
memalloc dynstr.c(3): alloc 256 bytes at ADDR_124
memalloc scan.c(1): alloc 92 bytes at ADDR_125
memalloc scan_context.c(2): alloc 12 bytes at ADDR_126
memalloc scan.c(1): alloc 39 bytes at ADDR_127
memalloc scan.c(1): alloc 48 bytes at ADDR_128
memalloc scan.c(1): alloc 4 bytes at ADDR_129
Token: (0) NAME DEFC
Token: (0) NAME C
Token: (0) EQUAL
Token: (0) NUMBER 2
Token: (0) NEWLINE
Token: (0) NAME DEFC
Token: (0) NAME D
Token: (0) EQUAL
Token: (0) NUMBER 3
Token: (0) NEWLINE
memalloc scan_context.c(2): free 12 bytes at ADDR_126 allocated at scan_context.c(2)
memalloc scan.c(2): free 39 bytes at ADDR_127 allocated at scan.c(1)
memalloc scan.c(2): free 48 bytes at ADDR_128 allocated at scan.c(1)
memalloc scan.c(2): free 4 bytes at ADDR_129 allocated at scan.c(1)
memalloc scan.c(2): free 92 bytes at ADDR_125 allocated at scan.c(1)
memalloc scan_struct.c(1): free 40 bytes at ADDR_108 allocated at scan_struct.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_112 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_111 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_110 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_115 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_114 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_113 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_118 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_117 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_116 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_121 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_120 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_119 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_124 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_123 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_122 allocated at scan_token.c(1)
memalloc scan_token.c(2): free 56 bytes at ADDR_109 allocated at scan_token.c(2)
memalloc scan_context.c(1): free 64 bytes at ADDR_107 allocated at scan_context.c(1)
Token: (0) NUMBER 3
Token: (0) NAME A
Token: (0) NAME B
Token: (0) NAME C
Token: (0) NEWLINE
memalloc scan_context.c(2): free 12 bytes at ADDR_103 allocated at scan_context.c(2)
memalloc scan.c(2): free 25 bytes at ADDR_104 allocated at scan.c(1)
memalloc scan.c(2): free 48 bytes at ADDR_105 allocated at scan.c(1)
memalloc scan.c(2): free 4 bytes at ADDR_106 allocated at scan.c(1)
memalloc scan.c(2): free 92 bytes at ADDR_102 allocated at scan.c(1)
memalloc scan_struct.c(1): free 40 bytes at ADDR_85 allocated at scan_struct.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_89 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_88 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_87 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_92 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_91 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_90 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_95 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_94 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_93 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_98 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_97 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_96 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_101 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_100 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_99 allocated at scan_token.c(1)
memalloc scan_token.c(2): free 56 bytes at ADDR_86 allocated at scan_token.c(2)
memalloc scan_context.c(1): free 64 bytes at ADDR_84 allocated at scan_context.c(1)
Token: (0) NULL
Token: (0) NULL
Test: open text file
memalloc strpool.c(2): alloc 36 bytes at ADDR_130
memalloc strpool.c(3): alloc 3 bytes at ADDR_131
memalloc scan_context.c(1): alloc 64 bytes at ADDR_132
memalloc scan_struct.c(1): alloc 40 bytes at ADDR_133
memalloc scan_token.c(2): alloc 56 bytes at ADDR_134
memalloc scan_token.c(1): alloc 48 bytes at ADDR_135
memalloc dynstr.c(1): alloc 40 bytes at ADDR_136
memalloc dynstr.c(3): alloc 256 bytes at ADDR_137
memalloc scan_token.c(1): alloc 48 bytes at ADDR_138
memalloc dynstr.c(1): alloc 40 bytes at ADDR_139
memalloc dynstr.c(3): alloc 256 bytes at ADDR_140
memalloc scan_token.c(1): alloc 48 bytes at ADDR_141
memalloc dynstr.c(1): alloc 40 bytes at ADDR_142
memalloc dynstr.c(3): alloc 256 bytes at ADDR_143
memalloc scan_token.c(1): alloc 48 bytes at ADDR_144
memalloc dynstr.c(1): alloc 40 bytes at ADDR_145
memalloc dynstr.c(3): alloc 256 bytes at ADDR_146
memalloc scan_token.c(1): alloc 48 bytes at ADDR_147
memalloc dynstr.c(1): alloc 40 bytes at ADDR_148
memalloc dynstr.c(3): alloc 256 bytes at ADDR_149
memalloc scan.c(1): alloc 92 bytes at ADDR_150
memalloc scan_context.c(2): alloc 12 bytes at ADDR_151
memalloc scan.c(1): alloc 4 bytes at ADDR_152
memalloc scan.c(1): alloc 48 bytes at ADDR_153
memalloc scan.c(1): alloc 16386 bytes at ADDR_154
List:f0:1:F0 1
Token: f0(1) NAME F0
Token: f0(1) NUMBER 1
Token: f0(1) NEWLINE
List:f0:2:
Token: f0(2) NEWLINE
List:f0:3:F0 3
Token: f0(3) NAME F0
Token: f0(3) NUMBER 3
Token: f0(3) NEWLINE
memalloc scan_context.c(1): alloc 64 bytes at ADDR_155
memalloc scan_struct.c(1): alloc 40 bytes at ADDR_156
memalloc scan_token.c(2): alloc 56 bytes at ADDR_157
memalloc scan_token.c(1): alloc 48 bytes at ADDR_158
memalloc dynstr.c(1): alloc 40 bytes at ADDR_159
memalloc dynstr.c(3): alloc 256 bytes at ADDR_160
memalloc scan_token.c(1): alloc 48 bytes at ADDR_161
memalloc dynstr.c(1): alloc 40 bytes at ADDR_162
memalloc dynstr.c(3): alloc 256 bytes at ADDR_163
memalloc scan_token.c(1): alloc 48 bytes at ADDR_164
memalloc dynstr.c(1): alloc 40 bytes at ADDR_165
memalloc dynstr.c(3): alloc 256 bytes at ADDR_166
memalloc scan_token.c(1): alloc 48 bytes at ADDR_167
memalloc dynstr.c(1): alloc 40 bytes at ADDR_168
memalloc dynstr.c(3): alloc 256 bytes at ADDR_169
memalloc scan_token.c(1): alloc 48 bytes at ADDR_170
memalloc dynstr.c(1): alloc 40 bytes at ADDR_171
memalloc dynstr.c(3): alloc 256 bytes at ADDR_172
memalloc scan.c(1): alloc 92 bytes at ADDR_173
memalloc scan_context.c(2): alloc 12 bytes at ADDR_174
memalloc scan.c(1): alloc 39 bytes at ADDR_175
memalloc scan.c(1): alloc 48 bytes at ADDR_176
memalloc scan.c(1): alloc 4 bytes at ADDR_177
Token: f0(4) NAME DEFC
Token: f0(4) NAME C
Token: f0(4) EQUAL
Token: f0(4) NUMBER 2
Token: f0(4) NEWLINE
Token: f0(4) NAME DEFC
Token: f0(4) NAME D
Token: f0(4) EQUAL
Token: f0(4) NUMBER 3
Token: f0(4) NEWLINE
memalloc scan_context.c(2): free 12 bytes at ADDR_174 allocated at scan_context.c(2)
memalloc scan.c(2): free 39 bytes at ADDR_175 allocated at scan.c(1)
memalloc scan.c(2): free 48 bytes at ADDR_176 allocated at scan.c(1)
memalloc scan.c(2): free 4 bytes at ADDR_177 allocated at scan.c(1)
memalloc scan.c(2): free 92 bytes at ADDR_173 allocated at scan.c(1)
memalloc scan_struct.c(1): free 40 bytes at ADDR_156 allocated at scan_struct.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_160 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_159 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_158 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_163 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_162 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_161 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_166 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_165 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_164 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_169 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_168 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_167 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_172 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_171 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_170 allocated at scan_token.c(1)
memalloc scan_token.c(2): free 56 bytes at ADDR_157 allocated at scan_token.c(2)
memalloc scan_context.c(1): free 64 bytes at ADDR_155 allocated at scan_context.c(1)
List:f0:4:
Token: f0(4) NEWLINE
List:f0:5:F0 5
Token: f0(5) NAME F0
Token: f0(5) NUMBER 5
memalloc strpool.c(2): alloc 36 bytes at ADDR_178
memalloc strpool.c(3): alloc 6 bytes at ADDR_179
memalloc scan_context.c(1): alloc 64 bytes at ADDR_180
memalloc scan_struct.c(1): alloc 40 bytes at ADDR_181
memalloc scan_token.c(2): alloc 56 bytes at ADDR_182
memalloc scan_token.c(1): alloc 48 bytes at ADDR_183
memalloc dynstr.c(1): alloc 40 bytes at ADDR_184
memalloc dynstr.c(3): alloc 256 bytes at ADDR_185
memalloc scan_token.c(1): alloc 48 bytes at ADDR_186
memalloc dynstr.c(1): alloc 40 bytes at ADDR_187
memalloc dynstr.c(3): alloc 256 bytes at ADDR_188
memalloc scan_token.c(1): alloc 48 bytes at ADDR_189
memalloc dynstr.c(1): alloc 40 bytes at ADDR_190
memalloc dynstr.c(3): alloc 256 bytes at ADDR_191
memalloc scan_token.c(1): alloc 48 bytes at ADDR_192
memalloc dynstr.c(1): alloc 40 bytes at ADDR_193
memalloc dynstr.c(3): alloc 256 bytes at ADDR_194
memalloc scan_token.c(1): alloc 48 bytes at ADDR_195
memalloc dynstr.c(1): alloc 40 bytes at ADDR_196
memalloc dynstr.c(3): alloc 256 bytes at ADDR_197
memalloc scan.c(1): alloc 92 bytes at ADDR_198
memalloc scan_context.c(2): alloc 12 bytes at ADDR_199
memalloc scan.c(1): alloc 4 bytes at ADDR_200
memalloc scan.c(1): alloc 48 bytes at ADDR_201
memalloc scan.c(1): alloc 16386 bytes at ADDR_202
List:x1/f1:1:F1 1
Token: x1/f1(1) NAME F1
Token: x1/f1(1) NUMBER 1
Token: x1/f1(1) NEWLINE
List:x1/f1:2:F1 2
Token: x1/f1(2) NAME F1
Token: x1/f1(2) NUMBER 2
Token: x1/f1(2) NEWLINE
List:x1/f1:3:F1 3
Token: x1/f1(3) NAME F1
Token: x1/f1(3) NUMBER 3
Token: x1/f1(3) NEWLINE
memalloc scan_context.c(2): free 12 bytes at ADDR_199 allocated at scan_context.c(2)
memalloc scan.c(2): free 16386 bytes at ADDR_202 allocated at scan.c(1)
memalloc scan.c(2): free 48 bytes at ADDR_201 allocated at scan.c(1)
memalloc scan.c(2): free 4 bytes at ADDR_200 allocated at scan.c(1)
memalloc scan.c(2): free 92 bytes at ADDR_198 allocated at scan.c(1)
memalloc scan_struct.c(1): free 40 bytes at ADDR_181 allocated at scan_struct.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_185 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_184 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_183 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_188 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_187 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_186 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_191 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_190 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_189 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_194 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_193 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_192 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_197 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_196 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_195 allocated at scan_token.c(1)
memalloc scan_token.c(2): free 56 bytes at ADDR_182 allocated at scan_token.c(2)
memalloc scan_context.c(1): free 64 bytes at ADDR_180 allocated at scan_context.c(1)
Token: f0(5) NEWLINE
List:f0:6:
Token: f0(6) NEWLINE
List:f0:7:F0 7
Token: f0(7) NAME F0
Token: f0(7) NUMBER 7
Token: f0(7) NEWLINE
List:f0:8:
Token: f0(8) NEWLINE
List:f0:9:F0 9
Token: f0(9) NAME F0
Token: f0(9) NUMBER 9
Token: f0(9) NEWLINE
List:f0:10:
Token: f0(10) NEWLINE
List:f0:11:F0 11
Token: f0(11) NAME F0
Token: f0(11) NUMBER 11
Token: f0(11) NEWLINE
List:f0:12:
Token: f0(12) NEWLINE
List:f0:13:F0 13
Token: f0(13) NAME F0
Token: f0(13) NUMBER 13
memalloc scan_context.c(2): free 12 bytes at ADDR_151 allocated at scan_context.c(2)
memalloc scan.c(2): free 16386 bytes at ADDR_154 allocated at scan.c(1)
memalloc scan.c(2): free 48 bytes at ADDR_153 allocated at scan.c(1)
memalloc scan.c(2): free 4 bytes at ADDR_152 allocated at scan.c(1)
memalloc scan.c(2): free 92 bytes at ADDR_150 allocated at scan.c(1)
memalloc scan_struct.c(1): free 40 bytes at ADDR_133 allocated at scan_struct.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_137 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_136 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_135 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_140 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_139 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_138 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_143 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_142 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_141 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_146 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_145 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_144 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_149 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_148 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_147 allocated at scan_token.c(1)
memalloc scan_token.c(2): free 56 bytes at ADDR_134 allocated at scan_token.c(2)
memalloc scan_context.c(1): free 64 bytes at ADDR_132 allocated at scan_context.c(1)
Token: (0) NULL
Token: (0) NULL
memalloc strpool.c(2): alloc 36 bytes at ADDR_203
memalloc strpool.c(3): alloc 6 bytes at ADDR_204
memalloc scan_context.c(1): alloc 64 bytes at ADDR_205
memalloc scan_struct.c(1): alloc 40 bytes at ADDR_206
memalloc scan_token.c(2): alloc 56 bytes at ADDR_207
memalloc scan_token.c(1): alloc 48 bytes at ADDR_208
memalloc dynstr.c(1): alloc 40 bytes at ADDR_209
memalloc dynstr.c(3): alloc 256 bytes at ADDR_210
memalloc scan_token.c(1): alloc 48 bytes at ADDR_211
memalloc dynstr.c(1): alloc 40 bytes at ADDR_212
memalloc dynstr.c(3): alloc 256 bytes at ADDR_213
memalloc scan_token.c(1): alloc 48 bytes at ADDR_214
memalloc dynstr.c(1): alloc 40 bytes at ADDR_215
memalloc dynstr.c(3): alloc 256 bytes at ADDR_216
memalloc scan_token.c(1): alloc 48 bytes at ADDR_217
memalloc dynstr.c(1): alloc 40 bytes at ADDR_218
memalloc dynstr.c(3): alloc 256 bytes at ADDR_219
memalloc scan_token.c(1): alloc 48 bytes at ADDR_220
memalloc dynstr.c(1): alloc 40 bytes at ADDR_221
memalloc dynstr.c(3): alloc 256 bytes at ADDR_222
memalloc scan.c(1): alloc 92 bytes at ADDR_223
memalloc scan_context.c(2): alloc 12 bytes at ADDR_224
memalloc scan.c(1): alloc 4 bytes at ADDR_225
memalloc scan.c(1): alloc 48 bytes at ADDR_226
memalloc scan.c(1): alloc 16386 bytes at ADDR_227
List:x2/f2:1:; sigle-character tokens
Token: x2/f2(1) NEWLINE
List:x2/f2:2:! # $ % & ( ) * + , - . / : < = > ? @ [ \ ] ^ ` { | } ~
Token: x2/f2(2) EXCLAM
Token: x2/f2(2) HASH
Token: x2/f2(2) DOLLAR
Token: x2/f2(2) PERCENT
Token: x2/f2(2) AMPERSAND
Token: x2/f2(2) LPAREN
Token: x2/f2(2) RPAREN
Token: x2/f2(2) ASTERISK
Token: x2/f2(2) PLUS
Token: x2/f2(2) COMMA
Token: x2/f2(2) HYPHEN
Token: x2/f2(2) PERIOD
Token: x2/f2(2) SLASH
Token: x2/f2(2) COLON
Token: x2/f2(2) LESS
Token: x2/f2(2) EQUAL
Token: x2/f2(2) GREATER
Token: x2/f2(2) QUESTION
Token: x2/f2(2) ATSIGN
Token: x2/f2(2) LSQUARE
Token: x2/f2(2) BACKSLASH
Token: x2/f2(2) RSQUARE
Token: x2/f2(2) CARET
Token: x2/f2(2) BACKQUOTE
Token: x2/f2(2) LCURLY
Token: x2/f2(2) VBAR
Token: x2/f2(2) RCURLY
Token: x2/f2(2) TILDE
Token: x2/f2(2) NEWLINE
List:x2/f2:3:
Token: x2/f2(3) NEWLINE
List:x2/f2:4:; multiple-character tokens
Token: x2/f2(4) NEWLINE
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
Token: x2/f2(5) NEWLINE
List:x2/f2:6:
Token: x2/f2(6) NEWLINE
List:x2/f2:7:; names
Token: x2/f2(7) NEWLINE
List:x2/f2:8:_Abc_123 Abc_123 123_Abc_
Token: x2/f2(8) NAME _ABC_123
Token: x2/f2(8) NAME ABC_123
Token: x2/f2(8) NUMBER 123
Token: x2/f2(8) NAME _ABC_
Token: x2/f2(8) NEWLINE
List:x2/f2:9:Abc_123	af' bc'de'af'
Token: x2/f2(9) NAME ABC_123
Token: x2/f2(9) NAME AF'
Token: x2/f2(9) NAME BC
Token: x2/f2(9) STRING 'de'
Token: x2/f2(9) NAME AF'
Token: x2/f2(9) NEWLINE
List:x2/f2:10:
Token: x2/f2(10) NEWLINE
List:x2/f2:11:; numbers - decimal
Token: x2/f2(11) NEWLINE
List:x2/f2:12:0 2147483647 2147483648
Token: x2/f2(12) NUMBER 0
Token: x2/f2(12) NUMBER 2147483647
Token: x2/f2(12) NUMBER -2147483648
Token: x2/f2(12) NEWLINE
List:x2/f2:13:
Token: x2/f2(13) NEWLINE
List:x2/f2:14:; numbers - binary
Token: x2/f2(14) NEWLINE
List:x2/f2:15:  0000b   0011b    1111111111111111111111111111111b
Token: x2/f2(15) NUMBER 0
Token: x2/f2(15) NUMBER 3
Token: x2/f2(15) NUMBER 2147483647
Token: x2/f2(15) NEWLINE
List:x2/f2:16: @0000   @0011    @1111111111111111111111111111111
Token: x2/f2(16) NUMBER 0
Token: x2/f2(16) NUMBER 3
Token: x2/f2(16) NUMBER 2147483647
Token: x2/f2(16) NEWLINE
List:x2/f2:17: %0000   %0011    %1111111111111111111111111111111
Token: x2/f2(17) NUMBER 0
Token: x2/f2(17) NUMBER 3
Token: x2/f2(17) NUMBER 2147483647
Token: x2/f2(17) NEWLINE
List:x2/f2:18:0b0000  0b0011   0b1111111111111111111111111111111
Token: x2/f2(18) NUMBER 0
Token: x2/f2(18) NUMBER 3
Token: x2/f2(18) NUMBER 2147483647
Token: x2/f2(18) NEWLINE
List:x2/f2:19:@'----' @'--##'  @'###############################'
Token: x2/f2(19) NUMBER 0
Token: x2/f2(19) NUMBER 3
Token: x2/f2(19) NUMBER 2147483647
Token: x2/f2(19) NEWLINE
List:x2/f2:20:%'----' %'--##'  %'###############################'
Token: x2/f2(20) NUMBER 0
Token: x2/f2(20) NUMBER 3
Token: x2/f2(20) NUMBER 2147483647
Token: x2/f2(20) NEWLINE
List:x2/f2:21:@"----" @"--##"  @"###############################"
Token: x2/f2(21) NUMBER 0
Token: x2/f2(21) NUMBER 3
Token: x2/f2(21) NUMBER 2147483647
Token: x2/f2(21) NEWLINE
List:x2/f2:22:%"----" %"--##"  %"###############################"
Token: x2/f2(22) NUMBER 0
Token: x2/f2(22) NUMBER 3
Token: x2/f2(22) NUMBER 2147483647
Token: x2/f2(22) NEWLINE
List:x2/f2:23:
Token: x2/f2(23) NEWLINE
List:x2/f2:24:; numbers - hexadecimal
Token: x2/f2(24) NEWLINE
List:x2/f2:25:  0h 0ah 0FH   7FFFFFFFh
Token: x2/f2(25) NUMBER 0
Token: x2/f2(25) NUMBER 10
Token: x2/f2(25) NUMBER 15
Token: x2/f2(25) NUMBER 2147483647
Token: x2/f2(25) NEWLINE
List:x2/f2:26: $0   $a  $F  $7FFFFFFF
Token: x2/f2(26) NUMBER 0
Token: x2/f2(26) NUMBER 10
Token: x2/f2(26) NUMBER 15
Token: x2/f2(26) NUMBER 2147483647
Token: x2/f2(26) NEWLINE
List:x2/f2:27: #0   #a  #F  #7FFFFFFF
Token: x2/f2(27) NUMBER 0
Token: x2/f2(27) NUMBER 10
Token: x2/f2(27) NUMBER 15
Token: x2/f2(27) NUMBER 2147483647
Token: x2/f2(27) NEWLINE
List:x2/f2:28:0x0  0xa 0xF 0x7FFFFFFF
Token: x2/f2(28) NUMBER 0
Token: x2/f2(28) NUMBER 10
Token: x2/f2(28) NUMBER 15
Token: x2/f2(28) NUMBER 2147483647
Token: x2/f2(28) NEWLINE
List:x2/f2:29:
Token: x2/f2(29) NEWLINE
List:x2/f2:30:; strings - single-quote
Token: x2/f2(30) NEWLINE
List:x2/f2:31:'''a''"'';';comment
Token: x2/f2(31) STRING ''
Token: x2/f2(31) STRING 'a'
Token: x2/f2(31) STRING '"'
Token: x2/f2(31) STRING ';'
Token: x2/f2(31) NEWLINE
List:x2/f2:32:'unclosed
memalloc errors.c(1): alloc 40 bytes at ADDR_228
memalloc strhash.c(1): alloc 32 bytes at ADDR_229
Error at file 'x2/f2' line 32: Unclosed string
Token: x2/f2(32) NEWLINE
List:x2/f2:33:
Token: x2/f2(33) NEWLINE
List:x2/f2:34:; strings - double-quotes
Token: x2/f2(34) NEWLINE
List:x2/f2:35:"""a""'"";";comment
Token: x2/f2(35) STRING ''
Token: x2/f2(35) STRING 'a'
Token: x2/f2(35) STRING '''
Token: x2/f2(35) STRING ';'
Token: x2/f2(35) NEWLINE
List:x2/f2:36:"unclosed
Error at file 'x2/f2' line 36: Unclosed string
Token: x2/f2(36) NEWLINE
List:x2/f2:37:
Token: x2/f2(37) NEWLINE
memalloc scan_context.c(2): free 12 bytes at ADDR_224 allocated at scan_context.c(2)
memalloc scan.c(2): free 16386 bytes at ADDR_227 allocated at scan.c(1)
memalloc scan.c(2): free 48 bytes at ADDR_226 allocated at scan.c(1)
memalloc scan.c(2): free 4 bytes at ADDR_225 allocated at scan.c(1)
memalloc scan.c(2): free 92 bytes at ADDR_223 allocated at scan.c(1)
memalloc scan_struct.c(1): free 40 bytes at ADDR_206 allocated at scan_struct.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_210 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_209 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_208 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_213 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_212 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_211 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_216 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_215 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_214 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_219 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_218 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_217 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_222 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_221 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_220 allocated at scan_token.c(1)
memalloc scan_token.c(2): free 56 bytes at ADDR_207 allocated at scan_token.c(2)
memalloc scan_context.c(1): free 64 bytes at ADDR_205 allocated at scan_context.c(1)
Token: (0) NULL
Token: (0) NULL
memalloc scan_context.c(1): alloc 64 bytes at ADDR_230
memalloc scan_struct.c(1): alloc 40 bytes at ADDR_231
memalloc scan_token.c(2): alloc 56 bytes at ADDR_232
memalloc scan_token.c(1): alloc 48 bytes at ADDR_233
memalloc dynstr.c(1): alloc 40 bytes at ADDR_234
memalloc dynstr.c(3): alloc 256 bytes at ADDR_235
memalloc scan_token.c(1): alloc 48 bytes at ADDR_236
memalloc dynstr.c(1): alloc 40 bytes at ADDR_237
memalloc dynstr.c(3): alloc 256 bytes at ADDR_238
memalloc scan_token.c(1): alloc 48 bytes at ADDR_239
memalloc dynstr.c(1): alloc 40 bytes at ADDR_240
memalloc dynstr.c(3): alloc 256 bytes at ADDR_241
memalloc scan_token.c(1): alloc 48 bytes at ADDR_242
memalloc dynstr.c(1): alloc 40 bytes at ADDR_243
memalloc dynstr.c(3): alloc 256 bytes at ADDR_244
memalloc scan_token.c(1): alloc 48 bytes at ADDR_245
memalloc dynstr.c(1): alloc 40 bytes at ADDR_246
memalloc dynstr.c(3): alloc 256 bytes at ADDR_247
memalloc scan.c(1): alloc 92 bytes at ADDR_248
memalloc scan_context.c(2): alloc 12 bytes at ADDR_249
memalloc scan.c(1): alloc 7 bytes at ADDR_250
memalloc scan.c(1): alloc 48 bytes at ADDR_251
memalloc scan.c(1): alloc 4 bytes at ADDR_252
Token: (0) NAME A
Token: (0) NAME B
Token: (0) NAME C
memalloc scan_context.c(2): free 12 bytes at ADDR_249 allocated at scan_context.c(2)
memalloc scan.c(2): free 7 bytes at ADDR_250 allocated at scan.c(1)
memalloc scan.c(2): free 48 bytes at ADDR_251 allocated at scan.c(1)
memalloc scan.c(2): free 4 bytes at ADDR_252 allocated at scan.c(1)
memalloc scan.c(2): free 92 bytes at ADDR_248 allocated at scan.c(1)
memalloc scan_struct.c(1): free 40 bytes at ADDR_231 allocated at scan_struct.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_235 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_234 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_233 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_238 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_237 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_236 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_241 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_240 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_239 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_244 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_243 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_242 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_247 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_246 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_245 allocated at scan_token.c(1)
memalloc scan_token.c(2): free 56 bytes at ADDR_232 allocated at scan_token.c(2)
memalloc scan_context.c(1): free 64 bytes at ADDR_230 allocated at scan_context.c(1)
Token: (0) NULL
Token: (0) NULL
memalloc strhash.c(1): free 32 bytes at ADDR_229 allocated at strhash.c(1)
memalloc errors.c(1): free 40 bytes at ADDR_228 allocated at errors.c(1)
memalloc scan_context.c(2): free 40 bytes at ADDR_14 allocated at scan_context.c(2)
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
memalloc strpool.c(6): free 3 bytes at ADDR_131 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_130 allocated at strpool.c(2)
memalloc strpool.c(6): free 6 bytes at ADDR_179 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_178 allocated at strpool.c(2)
memalloc strpool.c(5): free 384 bytes at ADDR_7 allocated at strpool.c(4)
memalloc strpool.c(5): free 44 bytes at ADDR_6 allocated at strpool.c(4)
memalloc strpool.c(6): free 6 bytes at ADDR_204 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_203 allocated at strpool.c(2)
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
memalloc scan_context.c(2): alloc 40 bytes at ADDR_1
memalloc strpool.c(1): alloc 32 bytes at ADDR_2
memalloc strpool.c(2): alloc 36 bytes at ADDR_3
memalloc strpool.c(3): alloc 3 bytes at ADDR_4
memalloc strpool.c(4): alloc 44 bytes at ADDR_5
memalloc strpool.c(4): alloc 384 bytes at ADDR_6
memalloc scan_context.c(1): alloc 64 bytes at ADDR_7
memalloc scan_struct.c(1): alloc 40 bytes at ADDR_8
memalloc scan_token.c(2): alloc 56 bytes at ADDR_9
memalloc scan_token.c(1): alloc 48 bytes at ADDR_10
memalloc dynstr.c(1): alloc 40 bytes at ADDR_11
memalloc dynstr.c(3): alloc 256 bytes at ADDR_12
memalloc scan_token.c(1): alloc 48 bytes at ADDR_13
memalloc dynstr.c(1): alloc 40 bytes at ADDR_14
memalloc dynstr.c(3): alloc 256 bytes at ADDR_15
memalloc scan_token.c(1): alloc 48 bytes at ADDR_16
memalloc dynstr.c(1): alloc 40 bytes at ADDR_17
memalloc dynstr.c(3): alloc 256 bytes at ADDR_18
memalloc scan_token.c(1): alloc 48 bytes at ADDR_19
memalloc dynstr.c(1): alloc 40 bytes at ADDR_20
memalloc dynstr.c(3): alloc 256 bytes at ADDR_21
memalloc scan_token.c(1): alloc 48 bytes at ADDR_22
memalloc dynstr.c(1): alloc 40 bytes at ADDR_23
memalloc dynstr.c(3): alloc 256 bytes at ADDR_24
memalloc scan.c(1): alloc 92 bytes at ADDR_25
memalloc scan_context.c(2): alloc 12 bytes at ADDR_26
memalloc scan.c(1): alloc 4 bytes at ADDR_27
memalloc scan.c(1): alloc 48 bytes at ADDR_28
memalloc scan.c(1): alloc 16386 bytes at ADDR_29
List:f0:1:F0 1
Token: f0(1) NAME F0
Token: f0(1) NUMBER 1
Token: f0(1) NEWLINE
List:f0:2:
Token: f0(2) NEWLINE
List:f0:3:F0 3
Token: f0(3) NAME F0
Token: f0(3) NUMBER 3
Token: f0(3) NEWLINE
Test: open text file again
memalloc errors.c(1): alloc 40 bytes at ADDR_30
memalloc strhash.c(1): alloc 32 bytes at ADDR_31
Error at file 'f0' line 3: Cannot include file 'f0' recursively
memalloc strhash.c(1): free 32 bytes at ADDR_31 allocated at strhash.c(1)
memalloc errors.c(1): free 40 bytes at ADDR_30 allocated at errors.c(1)
memalloc strpool.c(5): free 384 bytes at ADDR_6 allocated at strpool.c(4)
memalloc strpool.c(5): free 44 bytes at ADDR_5 allocated at strpool.c(4)
memalloc strpool.c(6): free 3 bytes at ADDR_4 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_3 allocated at strpool.c(2)
memalloc strpool.c(1): free 32 bytes at ADDR_2 allocated at strpool.c(1)
memalloc scan.c(2): free 16386 bytes at ADDR_29 allocated at scan.c(1)
memalloc scan.c(2): free 48 bytes at ADDR_28 allocated at scan.c(1)
memalloc scan.c(2): free 4 bytes at ADDR_27 allocated at scan.c(1)
memalloc scan.c(2): free 92 bytes at ADDR_25 allocated at scan.c(1)
memalloc scan_struct.c(1): free 40 bytes at ADDR_8 allocated at scan_struct.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_12 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_11 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_10 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_15 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_14 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_13 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_18 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_17 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_16 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_21 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_20 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_19 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_24 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_23 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_22 allocated at scan_token.c(1)
memalloc scan_token.c(2): free 56 bytes at ADDR_9 allocated at scan_token.c(2)
memalloc scan_context.c(1): free 64 bytes at ADDR_7 allocated at scan_context.c(1)
memalloc scan_context.c(2): free 12 bytes at ADDR_26 allocated at scan_context.c(2)
memalloc scan_context.c(2): free 40 bytes at ADDR_1 allocated at scan_context.c(2)
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
memalloc scan_context.c(2): alloc 40 bytes at ADDR_1
memalloc strpool.c(1): alloc 32 bytes at ADDR_2
memalloc strpool.c(2): alloc 36 bytes at ADDR_3
memalloc strpool.c(3): alloc 3 bytes at ADDR_4
memalloc strpool.c(4): alloc 44 bytes at ADDR_5
memalloc strpool.c(4): alloc 384 bytes at ADDR_6
memalloc scan_context.c(1): alloc 64 bytes at ADDR_7
memalloc scan_struct.c(1): alloc 40 bytes at ADDR_8
memalloc scan_token.c(2): alloc 56 bytes at ADDR_9
memalloc scan_token.c(1): alloc 48 bytes at ADDR_10
memalloc dynstr.c(1): alloc 40 bytes at ADDR_11
memalloc dynstr.c(3): alloc 256 bytes at ADDR_12
memalloc scan_token.c(1): alloc 48 bytes at ADDR_13
memalloc dynstr.c(1): alloc 40 bytes at ADDR_14
memalloc dynstr.c(3): alloc 256 bytes at ADDR_15
memalloc scan_token.c(1): alloc 48 bytes at ADDR_16
memalloc dynstr.c(1): alloc 40 bytes at ADDR_17
memalloc dynstr.c(3): alloc 256 bytes at ADDR_18
memalloc scan_token.c(1): alloc 48 bytes at ADDR_19
memalloc dynstr.c(1): alloc 40 bytes at ADDR_20
memalloc dynstr.c(3): alloc 256 bytes at ADDR_21
memalloc scan_token.c(1): alloc 48 bytes at ADDR_22
memalloc dynstr.c(1): alloc 40 bytes at ADDR_23
memalloc dynstr.c(3): alloc 256 bytes at ADDR_24
memalloc scan.c(1): alloc 92 bytes at ADDR_25
memalloc scan_context.c(2): alloc 12 bytes at ADDR_26
memalloc scan.c(1): alloc 4 bytes at ADDR_27
memalloc scan.c(1): alloc 48 bytes at ADDR_28
memalloc scan.c(1): alloc 16386 bytes at ADDR_29
List:f0:1:F0 1
Token: f0(1) NAME F0
Token: f0(1) NUMBER 1
Token: f0(1) NEWLINE
List:f0:2:
Token: f0(2) NEWLINE
List:f0:3:F0 3
Token: f0(3) NAME F0
Token: f0(3) NUMBER 3
Token: f0(3) NEWLINE
Test: open fails
memalloc strpool.c(2): alloc 36 bytes at ADDR_30
memalloc strpool.c(3): alloc 3 bytes at ADDR_31
memalloc errors.c(1): alloc 40 bytes at ADDR_32
memalloc strhash.c(1): alloc 32 bytes at ADDR_33
Error at file 'f0' line 3: Cannot open file 'f1' for reading
memalloc strhash.c(1): free 32 bytes at ADDR_33 allocated at strhash.c(1)
memalloc errors.c(1): free 40 bytes at ADDR_32 allocated at errors.c(1)
memalloc strpool.c(6): free 3 bytes at ADDR_4 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_3 allocated at strpool.c(2)
memalloc strpool.c(5): free 384 bytes at ADDR_6 allocated at strpool.c(4)
memalloc strpool.c(5): free 44 bytes at ADDR_5 allocated at strpool.c(4)
memalloc strpool.c(6): free 3 bytes at ADDR_31 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_30 allocated at strpool.c(2)
memalloc strpool.c(1): free 32 bytes at ADDR_2 allocated at strpool.c(1)
memalloc scan.c(2): free 16386 bytes at ADDR_29 allocated at scan.c(1)
memalloc scan.c(2): free 48 bytes at ADDR_28 allocated at scan.c(1)
memalloc scan.c(2): free 4 bytes at ADDR_27 allocated at scan.c(1)
memalloc scan.c(2): free 92 bytes at ADDR_25 allocated at scan.c(1)
memalloc scan_struct.c(1): free 40 bytes at ADDR_8 allocated at scan_struct.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_12 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_11 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_10 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_15 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_14 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_13 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_18 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_17 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_16 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_21 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_20 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_19 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_24 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_23 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_22 allocated at scan_token.c(1)
memalloc scan_token.c(2): free 56 bytes at ADDR_9 allocated at scan_token.c(2)
memalloc scan_context.c(1): free 64 bytes at ADDR_7 allocated at scan_context.c(1)
memalloc scan_context.c(2): free 12 bytes at ADDR_26 allocated at scan_context.c(2)
memalloc scan_context.c(2): free 40 bytes at ADDR_1 allocated at scan_context.c(2)
memalloc: cleanup
END


# test struct, ERR_UNBALANCED_STRUCT, ERR_UNBALANCED_STRUCT_AT
write_file('x3/f3', {binmode => ':raw'}, " a \n b \n c \n");
write_file('x3/f4', {binmode => ':raw'}, " d \n e \n f \n");

t_compile_module($init, <<'END', $compile);

	warn("push before start\n");
	scan_push_struct( 1, 10 );
	if ( scan_top_id()    != -1 ) 		ERROR;
	if ( scan_top_value() != -1 )		ERROR;
	n_tokens( -1 );

	warn("replace before start\n");
	scan_replace_struct( 1, 10 );
	if ( scan_top_id()    != -1 ) 		ERROR;
	if ( scan_top_value() != -1 )		ERROR;
	n_tokens( -1 );

	warn("pop before start\n");
	scan_pop_struct( 1 );
	n_tokens( -1 );

	warn("push without pop\n");
	scan_file("x3/f3");
	scan_push_struct( 1, 10 );
	if ( scan_top_id()    != 1  ) 		ERROR;
	if ( scan_top_value() != 10 )		ERROR;
	n_tokens( 2 );
	scan_file("x3/f4");
	scan_push_struct( 2, 20 );
	if ( scan_top_id()    != 2  ) 		ERROR;
	if ( scan_top_value() != 20 )		ERROR;
	n_tokens( 8 );
	if ( scan_top_id()    != 1  ) 		ERROR;
	if ( scan_top_value() != 10 )		ERROR;
	n_tokens( -1 );

	warn("push, replace, pop\n");
	scan_file("x3/f3");
	scan_push_struct( 1, 10 );
	if ( scan_top_id()    != 1  ) 		ERROR;
	if ( scan_top_value() != 10 )		ERROR;
	n_tokens( 4 );
	scan_replace_struct( 2, 20 );
	if ( scan_top_id()    != 2  ) 		ERROR;
	if ( scan_top_value() != 20 )		ERROR;
	scan_pop_struct( 2 );
	n_tokens( -1 );

	warn("push, wrong pop\n");
	scan_file("x3/f3");
	scan_push_struct( 1, 10 );
	if ( scan_top_id()    != 1  ) 		ERROR;
	if ( scan_top_value() != 10 )		ERROR;
	n_tokens( 4 );
	scan_pop_struct( 2 );
	n_tokens( -1 );
	
	return 0;
END

t_run_module([], '', <<'END', 0);
push before start
memalloc: init
memalloc scan_context.c(2): alloc 40 bytes at ADDR_1
memalloc errors.c(1): alloc 40 bytes at ADDR_2
memalloc strpool.c(1): alloc 32 bytes at ADDR_3
memalloc strhash.c(1): alloc 32 bytes at ADDR_4
Error: Unbalanced struct
Error: Unbalanced struct
Error: Unbalanced struct
Token: (0) NULL
Token: (0) NULL
replace before start
Error: Unbalanced struct
Error: Unbalanced struct
Error: Unbalanced struct
Token: (0) NULL
Token: (0) NULL
pop before start
Error: Unbalanced struct
Token: (0) NULL
Token: (0) NULL
push without pop
memalloc strpool.c(2): alloc 36 bytes at ADDR_5
memalloc strpool.c(3): alloc 6 bytes at ADDR_6
memalloc strpool.c(4): alloc 44 bytes at ADDR_7
memalloc strpool.c(4): alloc 384 bytes at ADDR_8
memalloc scan_context.c(1): alloc 64 bytes at ADDR_9
memalloc scan_struct.c(2): alloc 40 bytes at ADDR_10
memalloc scan_token.c(2): alloc 56 bytes at ADDR_11
memalloc scan_token.c(1): alloc 48 bytes at ADDR_12
memalloc dynstr.c(1): alloc 40 bytes at ADDR_13
memalloc dynstr.c(3): alloc 256 bytes at ADDR_14
memalloc scan_token.c(1): alloc 48 bytes at ADDR_15
memalloc dynstr.c(1): alloc 40 bytes at ADDR_16
memalloc dynstr.c(3): alloc 256 bytes at ADDR_17
memalloc scan_token.c(1): alloc 48 bytes at ADDR_18
memalloc dynstr.c(1): alloc 40 bytes at ADDR_19
memalloc dynstr.c(3): alloc 256 bytes at ADDR_20
memalloc scan_token.c(1): alloc 48 bytes at ADDR_21
memalloc dynstr.c(1): alloc 40 bytes at ADDR_22
memalloc dynstr.c(3): alloc 256 bytes at ADDR_23
memalloc scan_token.c(1): alloc 48 bytes at ADDR_24
memalloc dynstr.c(1): alloc 40 bytes at ADDR_25
memalloc dynstr.c(3): alloc 256 bytes at ADDR_26
memalloc scan.c(1): alloc 92 bytes at ADDR_27
memalloc scan_context.c(2): alloc 12 bytes at ADDR_28
memalloc scan_struct.c(1): alloc 40 bytes at ADDR_29
memalloc scan_struct.c(2): alloc 12 bytes at ADDR_30
memalloc scan.c(1): alloc 4 bytes at ADDR_31
memalloc scan.c(1): alloc 48 bytes at ADDR_32
memalloc scan.c(1): alloc 16386 bytes at ADDR_33
List:x3/f3:1: a
Token: x3/f3(1) NAME A
Token: x3/f3(1) NEWLINE
memalloc strpool.c(2): alloc 36 bytes at ADDR_34
memalloc strpool.c(3): alloc 6 bytes at ADDR_35
memalloc scan_context.c(1): alloc 64 bytes at ADDR_36
memalloc scan_struct.c(2): alloc 40 bytes at ADDR_37
memalloc scan_token.c(2): alloc 56 bytes at ADDR_38
memalloc scan_token.c(1): alloc 48 bytes at ADDR_39
memalloc dynstr.c(1): alloc 40 bytes at ADDR_40
memalloc dynstr.c(3): alloc 256 bytes at ADDR_41
memalloc scan_token.c(1): alloc 48 bytes at ADDR_42
memalloc dynstr.c(1): alloc 40 bytes at ADDR_43
memalloc dynstr.c(3): alloc 256 bytes at ADDR_44
memalloc scan_token.c(1): alloc 48 bytes at ADDR_45
memalloc dynstr.c(1): alloc 40 bytes at ADDR_46
memalloc dynstr.c(3): alloc 256 bytes at ADDR_47
memalloc scan_token.c(1): alloc 48 bytes at ADDR_48
memalloc dynstr.c(1): alloc 40 bytes at ADDR_49
memalloc dynstr.c(3): alloc 256 bytes at ADDR_50
memalloc scan_token.c(1): alloc 48 bytes at ADDR_51
memalloc dynstr.c(1): alloc 40 bytes at ADDR_52
memalloc dynstr.c(3): alloc 256 bytes at ADDR_53
memalloc scan.c(1): alloc 92 bytes at ADDR_54
memalloc scan_context.c(2): alloc 12 bytes at ADDR_55
memalloc scan_struct.c(1): alloc 40 bytes at ADDR_56
memalloc scan_struct.c(2): alloc 12 bytes at ADDR_57
memalloc scan.c(1): alloc 4 bytes at ADDR_58
memalloc scan.c(1): alloc 48 bytes at ADDR_59
memalloc scan.c(1): alloc 16386 bytes at ADDR_60
List:x3/f4:1: d
Token: x3/f4(1) NAME D
Token: x3/f4(1) NEWLINE
List:x3/f4:2: e
Token: x3/f4(2) NAME E
Token: x3/f4(2) NEWLINE
List:x3/f4:3: f
Token: x3/f4(3) NAME F
Token: x3/f4(3) NEWLINE
memalloc scan_struct.c(2): free 12 bytes at ADDR_57 allocated at scan_struct.c(2)
Error at file 'x3/f4' line 3: Unbalanced struct started at line 1
memalloc scan_struct.c(1): free 40 bytes at ADDR_56 allocated at scan_struct.c(1)
memalloc scan_context.c(2): free 12 bytes at ADDR_55 allocated at scan_context.c(2)
memalloc scan.c(2): free 16386 bytes at ADDR_60 allocated at scan.c(1)
memalloc scan.c(2): free 48 bytes at ADDR_59 allocated at scan.c(1)
memalloc scan.c(2): free 4 bytes at ADDR_58 allocated at scan.c(1)
memalloc scan.c(2): free 92 bytes at ADDR_54 allocated at scan.c(1)
memalloc scan_struct.c(2): free 40 bytes at ADDR_37 allocated at scan_struct.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_41 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_40 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_39 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_44 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_43 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_42 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_47 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_46 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_45 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_50 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_49 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_48 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_53 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_52 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_51 allocated at scan_token.c(1)
memalloc scan_token.c(2): free 56 bytes at ADDR_38 allocated at scan_token.c(2)
memalloc scan_context.c(1): free 64 bytes at ADDR_36 allocated at scan_context.c(1)
List:x3/f3:2: b
Token: x3/f3(2) NAME B
Token: x3/f3(2) NEWLINE
List:x3/f3:3: c
Token: x3/f3(3) NAME C
Token: x3/f3(3) NEWLINE
memalloc scan_struct.c(2): free 12 bytes at ADDR_30 allocated at scan_struct.c(2)
Error at file 'x3/f3' line 3: Unbalanced struct started at line 1
memalloc scan_struct.c(1): free 40 bytes at ADDR_29 allocated at scan_struct.c(1)
memalloc scan_context.c(2): free 12 bytes at ADDR_28 allocated at scan_context.c(2)
memalloc scan.c(2): free 16386 bytes at ADDR_33 allocated at scan.c(1)
memalloc scan.c(2): free 48 bytes at ADDR_32 allocated at scan.c(1)
memalloc scan.c(2): free 4 bytes at ADDR_31 allocated at scan.c(1)
memalloc scan.c(2): free 92 bytes at ADDR_27 allocated at scan.c(1)
memalloc scan_struct.c(2): free 40 bytes at ADDR_10 allocated at scan_struct.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_14 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_13 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_12 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_17 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_16 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_15 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_20 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_19 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_18 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_23 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_22 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_21 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_26 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_25 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_24 allocated at scan_token.c(1)
memalloc scan_token.c(2): free 56 bytes at ADDR_11 allocated at scan_token.c(2)
memalloc scan_context.c(1): free 64 bytes at ADDR_9 allocated at scan_context.c(1)
Token: (0) NULL
Token: (0) NULL
push, replace, pop
memalloc scan_context.c(1): alloc 64 bytes at ADDR_61
memalloc scan_struct.c(2): alloc 40 bytes at ADDR_62
memalloc scan_token.c(2): alloc 56 bytes at ADDR_63
memalloc scan_token.c(1): alloc 48 bytes at ADDR_64
memalloc dynstr.c(1): alloc 40 bytes at ADDR_65
memalloc dynstr.c(3): alloc 256 bytes at ADDR_66
memalloc scan_token.c(1): alloc 48 bytes at ADDR_67
memalloc dynstr.c(1): alloc 40 bytes at ADDR_68
memalloc dynstr.c(3): alloc 256 bytes at ADDR_69
memalloc scan_token.c(1): alloc 48 bytes at ADDR_70
memalloc dynstr.c(1): alloc 40 bytes at ADDR_71
memalloc dynstr.c(3): alloc 256 bytes at ADDR_72
memalloc scan_token.c(1): alloc 48 bytes at ADDR_73
memalloc dynstr.c(1): alloc 40 bytes at ADDR_74
memalloc dynstr.c(3): alloc 256 bytes at ADDR_75
memalloc scan_token.c(1): alloc 48 bytes at ADDR_76
memalloc dynstr.c(1): alloc 40 bytes at ADDR_77
memalloc dynstr.c(3): alloc 256 bytes at ADDR_78
memalloc scan.c(1): alloc 92 bytes at ADDR_79
memalloc scan_context.c(2): alloc 12 bytes at ADDR_80
memalloc scan_struct.c(1): alloc 40 bytes at ADDR_81
memalloc scan_struct.c(2): alloc 12 bytes at ADDR_82
memalloc scan.c(1): alloc 4 bytes at ADDR_83
memalloc scan.c(1): alloc 48 bytes at ADDR_84
memalloc scan.c(1): alloc 16386 bytes at ADDR_85
List:x3/f3:1: a
Token: x3/f3(1) NAME A
Token: x3/f3(1) NEWLINE
List:x3/f3:2: b
Token: x3/f3(2) NAME B
Token: x3/f3(2) NEWLINE
memalloc scan_struct.c(2): free 12 bytes at ADDR_82 allocated at scan_struct.c(2)
memalloc scan_struct.c(1): free 40 bytes at ADDR_81 allocated at scan_struct.c(1)
List:x3/f3:3: c
Token: x3/f3(3) NAME C
Token: x3/f3(3) NEWLINE
memalloc scan_context.c(2): free 12 bytes at ADDR_80 allocated at scan_context.c(2)
memalloc scan.c(2): free 16386 bytes at ADDR_85 allocated at scan.c(1)
memalloc scan.c(2): free 48 bytes at ADDR_84 allocated at scan.c(1)
memalloc scan.c(2): free 4 bytes at ADDR_83 allocated at scan.c(1)
memalloc scan.c(2): free 92 bytes at ADDR_79 allocated at scan.c(1)
memalloc scan_struct.c(2): free 40 bytes at ADDR_62 allocated at scan_struct.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_66 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_65 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_64 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_69 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_68 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_67 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_72 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_71 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_70 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_75 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_74 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_73 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_78 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_77 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_76 allocated at scan_token.c(1)
memalloc scan_token.c(2): free 56 bytes at ADDR_63 allocated at scan_token.c(2)
memalloc scan_context.c(1): free 64 bytes at ADDR_61 allocated at scan_context.c(1)
Token: (0) NULL
Token: (0) NULL
push, wrong pop
memalloc scan_context.c(1): alloc 64 bytes at ADDR_86
memalloc scan_struct.c(2): alloc 40 bytes at ADDR_87
memalloc scan_token.c(2): alloc 56 bytes at ADDR_88
memalloc scan_token.c(1): alloc 48 bytes at ADDR_89
memalloc dynstr.c(1): alloc 40 bytes at ADDR_90
memalloc dynstr.c(3): alloc 256 bytes at ADDR_91
memalloc scan_token.c(1): alloc 48 bytes at ADDR_92
memalloc dynstr.c(1): alloc 40 bytes at ADDR_93
memalloc dynstr.c(3): alloc 256 bytes at ADDR_94
memalloc scan_token.c(1): alloc 48 bytes at ADDR_95
memalloc dynstr.c(1): alloc 40 bytes at ADDR_96
memalloc dynstr.c(3): alloc 256 bytes at ADDR_97
memalloc scan_token.c(1): alloc 48 bytes at ADDR_98
memalloc dynstr.c(1): alloc 40 bytes at ADDR_99
memalloc dynstr.c(3): alloc 256 bytes at ADDR_100
memalloc scan_token.c(1): alloc 48 bytes at ADDR_101
memalloc dynstr.c(1): alloc 40 bytes at ADDR_102
memalloc dynstr.c(3): alloc 256 bytes at ADDR_103
memalloc scan.c(1): alloc 92 bytes at ADDR_104
memalloc scan_context.c(2): alloc 12 bytes at ADDR_105
memalloc scan_struct.c(1): alloc 40 bytes at ADDR_106
memalloc scan_struct.c(2): alloc 12 bytes at ADDR_107
memalloc scan.c(1): alloc 4 bytes at ADDR_108
memalloc scan.c(1): alloc 48 bytes at ADDR_109
memalloc scan.c(1): alloc 16386 bytes at ADDR_110
List:x3/f3:1: a
Token: x3/f3(1) NAME A
Token: x3/f3(1) NEWLINE
List:x3/f3:2: b
Token: x3/f3(2) NAME B
Token: x3/f3(2) NEWLINE
memalloc scan_struct.c(2): free 12 bytes at ADDR_107 allocated at scan_struct.c(2)
Error at file 'x3/f3' line 2: Unbalanced struct started at line 1
memalloc scan_struct.c(1): free 40 bytes at ADDR_106 allocated at scan_struct.c(1)
List:x3/f3:3: c
Token: x3/f3(3) NAME C
Token: x3/f3(3) NEWLINE
memalloc scan_context.c(2): free 12 bytes at ADDR_105 allocated at scan_context.c(2)
memalloc scan.c(2): free 16386 bytes at ADDR_110 allocated at scan.c(1)
memalloc scan.c(2): free 48 bytes at ADDR_109 allocated at scan.c(1)
memalloc scan.c(2): free 4 bytes at ADDR_108 allocated at scan.c(1)
memalloc scan.c(2): free 92 bytes at ADDR_104 allocated at scan.c(1)
memalloc scan_struct.c(2): free 40 bytes at ADDR_87 allocated at scan_struct.c(2)
memalloc dynstr.c(2): free 256 bytes at ADDR_91 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_90 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_89 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_94 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_93 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_92 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_97 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_96 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_95 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_100 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_99 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_98 allocated at scan_token.c(1)
memalloc dynstr.c(2): free 256 bytes at ADDR_103 allocated at dynstr.c(3)
memalloc dynstr.c(1): free 40 bytes at ADDR_102 allocated at dynstr.c(1)
memalloc scan_token.c(1): free 48 bytes at ADDR_101 allocated at scan_token.c(1)
memalloc scan_token.c(2): free 56 bytes at ADDR_88 allocated at scan_token.c(2)
memalloc scan_context.c(1): free 64 bytes at ADDR_86 allocated at scan_context.c(1)
Token: (0) NULL
Token: (0) NULL
memalloc strhash.c(1): free 32 bytes at ADDR_4 allocated at strhash.c(1)
memalloc errors.c(1): free 40 bytes at ADDR_2 allocated at errors.c(1)
memalloc strpool.c(6): free 6 bytes at ADDR_6 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_5 allocated at strpool.c(2)
memalloc strpool.c(5): free 384 bytes at ADDR_8 allocated at strpool.c(4)
memalloc strpool.c(5): free 44 bytes at ADDR_7 allocated at strpool.c(4)
memalloc strpool.c(6): free 6 bytes at ADDR_35 allocated at strpool.c(3)
memalloc strpool.c(7): free 36 bytes at ADDR_34 allocated at strpool.c(2)
memalloc strpool.c(1): free 32 bytes at ADDR_3 allocated at strpool.c(1)
memalloc scan_context.c(2): free 40 bytes at ADDR_1 allocated at scan_context.c(2)
memalloc: cleanup
END


# delete directories and files
remove_tree(qw( x1 x2 x3 ));
unlink_testfiles('f0');
done_testing;
