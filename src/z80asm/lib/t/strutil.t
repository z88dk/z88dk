#!/usr/bin/perl

# Copyright (C) Paulo Custodio, 2011-2014
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/t/Attic/strutil.t,v 1.18 2014-07-02 23:45:12 pauloscustodio Exp $
#
# Test strutil.c

use Modern::Perl;
use Test::More;
use File::Slurp;
use Capture::Tiny 'capture';
use Test::Differences; 

my $compile = "cc -Wall -otest test.c strutil.c strpool.c class.c xmalloc.c";

write_file("test.1.asm", {binmode => ':raw'}, "");
write_file("test.2.asm", {binmode => ':raw'}, "A\nB\rC\r\nD\n\rE");
write_file("test.3.asm", {binmode => ':raw'}, "A\nB\rC\r\nD\n\rE\n");
write_file("test.4.asm", {binmode => ':raw'}, "A\nB\rC\r\nD\n\rE\r");
write_file("test.5.asm", {binmode => ':raw'}, "A\nB\rC\r\nD\n\rE\r\n");
write_file("test.6.asm", {binmode => ':raw'}, "A\nB\rC\r\nD\n\rE\n\r");
write_file("test.7.asm", {binmode => ':raw'}, "x" x 1100);
write_file("test.8.asm", {binmode => ':raw'}, "ABCDEFGHIJ\nabcdefghij\n");

write_file("test.c", <<'END');
#include "strutil.h"
#include <assert.h>

#define ERROR die("Test failed at line %d\n", __LINE__)
#define FOPEN(file)		fp = fopen((file), "rb"); if (fp == NULL) ERROR;
#define GETLINE(s,exp_text,exp_ret) \
						{ Bool ret = Str_getline((s), fp); \
						  if (ret != exp_ret) ERROR; \
						  if (strcmp((s)->str, exp_text)) ERROR; \
						}
#define GETCHARS(s,num,exp_text,exp_ret) \
						{ Bool ret = Str_getchars((s), fp, (num)); \
						  if (ret != exp_ret) ERROR; \
						  if (strcmp((s)->str, exp_text)) ERROR; \
						}
#define FCLOSE()		fclose(fp);
#define GET_ABCDE(s,file) FOPEN((file)); \
						GETLINE((s),"A\n",TRUE); \
						GETLINE((s),"B\n",TRUE); \
						GETLINE((s),"C\n",TRUE); \
						GETLINE((s),"D\n",TRUE); \
						GETLINE((s),"E\n",TRUE); \
						GETLINE((s),"",   FALSE); \
						FCLOSE();

char *alias;
void _check_str(Str *str, size_t size, size_t len, char *text, Bool alloc_str,
				char *file, int lineno)
{
	if (str == NULL) 
		warn("%s(%d) str == NULL\n", file, lineno);
	if (str->str == NULL) 
		warn("%s(%d) str->str == NULL\n", file, lineno);
	if (str->size != size)
		warn("%s(%d) str->size %u != %u\n", file, lineno, str->size, size);
	if (str->len != len)
		warn("%s(%d) str->len %u != %u\n", file, lineno, str->len, len);
	if (str->str[str->len] != 0)
		warn("%s(%d) null terminator not found\n", file, lineno);
	if (memcmp(str->str, text, str->len))
		warn("%s(%d) different text found\n", file, lineno);
	if (str->alloc_str != alloc_str)
		warn("%s(%d) str->alloc_str %d != %d\n", file, lineno, str->alloc_str, alloc_str);
	if (str->palias != NULL && str->palias != &alias)
		warn("%s(%d) str->palias incorrect\n", file, lineno);
	if (str->palias != NULL && alias != str->str)
		warn("%s(%d) alias incorrect\n", file, lineno);
}	

#define check_str(str,size,len,text,alloc_str)	\
       _check_str(str,size,len,text,alloc_str,__FILE__,__LINE__)

Bool call_vsprintf (Str *str, char *format, ...)
{
	va_list argptr;
	Bool ret;
	
	va_start(argptr, format);
	ret = Str_vsprintf(str, format, argptr);
	va_end(argptr);
	
	return ret;
}

Bool call_append_vsprintf (Str *str, char *format, ...)
{
	va_list argptr;
	Bool ret;
	
	va_start(argptr, format);
	ret = Str_append_vsprintf(str, format, argptr);
	va_end(argptr);
	
	return ret;
}

Str * static_s1;
DEFINE_STR( static_s2, 5 );

int main()
{
	char s[255];
	char *p;

	/* strtoupper, strtolower */
	strcpy(s, "Abc1");
	p = strtolower(s);
	if (p != s)							ERROR;
	if(strcmp(s, "abc1"))				ERROR;
	
	strcpy(s, "Abc1");
	p = strtoupper(s);
	if (p != s)							ERROR;
	if(strcmp(s, "ABC1"))				ERROR;
	
	/* stricompare */
	if (stricompare("","") != 0)		ERROR;
	if (stricompare("a","") < 1)		ERROR;
	if (stricompare("","a") > -1)		ERROR;
	if (stricompare("a","a") != 0)		ERROR;
	if (stricompare("a","A") != 0)		ERROR;
	if (stricompare("A","a") != 0)		ERROR;
	if (stricompare("ab","a") < 1)		ERROR;
	if (stricompare("a","ab") > -1)		ERROR;
	if (stricompare("ab","ab") != 0)	ERROR;
	
	/* no alias */
	{
		Str *s1 = OBJ_NEW(Str);
		Str_set( s1, "hello" );
		check_str( s1, 16, 5, "hello", TRUE);
	}
	
	/* chomp, Str_chomp */
	{
		Str *s1 = OBJ_NEW(Str);
		Str_set_alias(s1, &alias);
		
		strcpy(s, "\r\n \t\fxxxxxxxx\r\n \t\f\v");
		Str_set( s1, s );
		
		p = chomp(s);
		if (p != s)							ERROR;
		if(strcmp(s, "\r\n \t\fxxxxxxxx"))	ERROR;
		
		Str_chomp(s1);
		if(strcmp(s, s1->str))				ERROR;
	
		strcpy(s, "\r\n \t\f \r\n \t\f\v");
		Str_set( s1, s );

		p = chomp(s);
		if (p != s)							ERROR;
		if(strcmp(s, ""))					ERROR;

		Str_chomp(s1);
		if(strcmp(s, s1->str))				ERROR;
	}
	
	/* strip, Str_strip */
	{
		Str *s1 = OBJ_NEW(Str);
		Str_set_alias(s1, &alias);
		
		strcpy(s, "\r\n \t\fxxxxxxxx\r\n \t\f\v");
		Str_set( s1, s );
		
		p = strip(s);
		if (p != s)							ERROR;
		if(strcmp(s, "xxxxxxxx"))			ERROR;
		
		Str_strip(s1);
		if(strcmp(s, s1->str))				ERROR;
	
		strcpy(s, "\r\n \t\f \r\n \t\f\v");
		Str_set( s1, s );

		p = strip(s);
		if (p != s)							ERROR;
		if(strcmp(s, ""))					ERROR;

		Str_strip(s1);
		if(strcmp(s, s1->str))				ERROR;
	}
	
	/* str_compress_escapes, Str_compress_escapes */
	{
		Str *s1 = OBJ_NEW(Str);
		size_t len;
		int i;
		
		Str_set_alias(s1, &alias);
		
		/* trailing backslash ignored */
		strcpy(s, "\\");
		Str_set( s1, s );
		
		len = str_compress_escapes(s);		
		assert( len == 0 ); assert( *s == '\0' );
		
		Str_compress_escapes( s1 );
		assert( s1->len == 0 ); assert( *s1->str == '\0' );

		/* escape any */
		strcpy(s, "\\" "?" "\\" "\"" "\\" "'");
		Str_set( s1, s );
		
		len = str_compress_escapes(s);		
		assert( len == 3 ); 
		assert( strcmp(s, "?\"'") == 0 );
		
		Str_compress_escapes( s1 );
		assert( s1->len == 3 ); 
		assert( strcmp(s1->str, s) == 0 );

		/* escape chars */
		strcpy(s, "0" "\\a" 
				  "1" "\\b" 
				  "2" "\\e" 
				  "3" "\\f" 
				  "4" "\\n" 
				  "5" "\\r" 
				  "6" "\\t" 
				  "7" "\\v" 
				  "8");
		Str_set( s1, s );
		
		len = str_compress_escapes(s);		
		assert( len == 17 ); 
		assert( strcmp(s, "0" "\a" 
						  "1" "\b" 
						  "2" "\x1B" 
						  "3" "\f" 
						  "4" "\n" 
						  "5" "\r" 
						  "6" "\t" 
						  "7" "\v" 
						  "8" ) == 0 );
		
		Str_compress_escapes( s1 );
		assert( s1->len == 17 ); 
		assert( strcmp(s1->str, s) == 0 );

		/* octal and hexadecimal, including '\0' */
		for ( i = 0; i < 256; i++ )
		{
			sprintf(s, "\\%o \\x%x", i, i );
			Str_set( s1, s );
			
			len = str_compress_escapes(s);		
			assert( len  == 3 );
			assert( s[0] == (char)i );
			assert( s[1] == ' ' );
			assert( s[2] == (char)i );
			assert( s[3] == '\0' );

			Str_compress_escapes( s1 );
			assert( s1->len == 3 ); 
			assert( memcmp(s1->str, s, 3) == 0 );
		}
		
		/* octal and hexadecimal with longer digit string */
		sprintf(s, "\\3770\\xff0");
		Str_set( s1, s );
		
		len = str_compress_escapes(s);		
		assert( len  == 4 );
		assert( strcmp(s, "\xFF" "0" "\xFF" "0") == 0 );

		Str_compress_escapes( s1 );
		assert( s1->len == 4 ); 
		assert( strcmp(s1->str, s) == 0 );
	}
	
	/* Str */
	{
		Str *s1 = OBJ_NEW(Str);
		Str *s2;
		char buffer[5] = "";
		Str _s3 = INIT_STR( buffer ), *s3 = & _s3;
		DEFINE_STR( s4, 10 );

		Str_set_alias(s1, &alias);
		
		check_str( s1,  16, 0, "", TRUE);
		check_str( s3,   5, 0, "", FALSE);
		check_str( s4,  10, 0, "", FALSE);

		/* unreserve */
		Str_unreserve( s1 );
		Str_unreserve( s3 );
		Str_unreserve( s4 );

		check_str( s1,   1, 0, "", TRUE);
		check_str( s3,   5, 0, "", FALSE);
		check_str( s4,  10, 0, "", FALSE);


		Str_clear( s1 ); Str_unreserve( s1 );
		Str_clear( s3 ); Str_unreserve( s3 );
		Str_clear( s4 ); Str_unreserve( s4 );

		
		/* append char */
		Str_append_char( s1, 0 );
		Str_append_char( s3, 0 );
		Str_append_char( s4, 0 );

		check_str( s1,  16, 1, "\0", TRUE);
		check_str( s3,   5, 1, "\0", FALSE);
		check_str( s4,  10, 1, "\0", FALSE);

		Str_append_char( s1, 1 );
		Str_append_char( s3, 1 );
		Str_append_char( s4, 1 );

		check_str( s1,  16, 2, "\0\1", TRUE);
		check_str( s3,   5, 2, "\0\1", FALSE);
		check_str( s4,  10, 2, "\0\1", FALSE);

		Str_append_char( s1, 2 );
		Str_append_char( s3, 2 );
		Str_append_char( s4, 2 );

		check_str( s1,  16, 3, "\0\1\2", TRUE);
		check_str( s3,   5, 3, "\0\1\2", FALSE);
		check_str( s4,  10, 3, "\0\1\2", FALSE);

		Str_append_char( s1, 3 );
		Str_append_char( s3, 3 );
		Str_append_char( s4, 3 );

		check_str( s1,  16, 4, "\0\1\2\3", TRUE);
		check_str( s3,   5, 4, "\0\1\2\3", FALSE);
		check_str( s4,  10, 4, "\0\1\2\3", FALSE);

		Str_append_char( s1, 4 );
		Str_append_char( s3, 4 );
		Str_append_char( s4, 4 );

		check_str( s1,  16, 5, "\0\1\2\3\4", TRUE);
		check_str( s3,   5, 4, "\0\1\2\3",   FALSE);
		check_str( s4,  10, 5, "\0\1\2\3\4", FALSE);


		Str_clear( s1 ); Str_unreserve( s1 );
		Str_clear( s3 ); Str_unreserve( s3 );
		Str_clear( s4 ); Str_unreserve( s4 );

		/* append */
		Str_append( s1, "h" );
		Str_append( s3, "h" );
		Str_append( s4, "h" );

		check_str( s1,  16, 1, "h", TRUE);
		check_str( s3,   5, 1, "h", FALSE);
		check_str( s4,  10, 1, "h", FALSE);

		Str_append_bytes( s1, "el\0o", 4 );
		Str_append_bytes( s3, "el\0o", 4 );
		Str_append_bytes( s4, "el\0o", 4 );

		check_str( s1,  16, 5, "hel\0o", TRUE);
		check_str( s3,   5, 4, "hel\0",  FALSE);
		check_str( s4,  10, 5, "hel\0o", FALSE);

		Str_append_char( s1, 32 );
		Str_append_char( s3, 32 );
		Str_append_char( s4, 32 );

		check_str( s1,  16, 6, "hel\0o ", TRUE);
		check_str( s3,   5, 4, "hel\0",   FALSE);
		check_str( s4,  10, 6, "hel\0o ", FALSE);

		Str_append( s1, "world" );
		Str_append( s3, "world" );
		Str_append( s4, "world" );

		check_str( s1,  16, 11, "hel\0o world", TRUE);
		check_str( s3,   5,  4, "hel\0",        FALSE);
		check_str( s4,  10,  9, "hel\0o wor",   FALSE);


		Str_clear( s1 ); Str_unreserve( s1 );
		Str_clear( s3 ); Str_unreserve( s3 );
		Str_clear( s4 ); Str_unreserve( s4 );


		/* set */
		Str_set( s1, "X" );
		Str_set( s3, "X" );
		Str_set( s4, "X" );

		check_str( s1,  16, 1, "X", TRUE);
		check_str( s3,   5, 1, "X", FALSE);
		check_str( s4,  10, 1, "X", FALSE);

		Str_set_bytes( s1, "\0\1", 2 );
		Str_set_bytes( s3, "\0\1", 2 );
		Str_set_bytes( s4, "\0\1", 2 );

		check_str( s1,  16, 2, "\0\1", TRUE);
		check_str( s3,   5, 2, "\0\1", FALSE);
		check_str( s4,  10, 2, "\0\1", FALSE);

		Str_set_char( s1, 33 );
		Str_set_char( s3, 33 );
		Str_set_char( s4, 33 );

		check_str( s1,  16, 1, "!", TRUE);
		check_str( s3,   5, 1, "!", FALSE);
		check_str( s4,  10, 1, "!", FALSE);


		Str_clear( s1 ); Str_unreserve( s1 );
		Str_clear( s3 ); Str_unreserve( s3 );
		Str_clear( s4 ); Str_unreserve( s4 );


		/* set_n, append_n */
		Str_set_n( s1, "1234567890", 3 );
		Str_set_n( s3, "1234567890", 3 );
		Str_set_n( s4, "1234567890", 3 );

		check_str( s1,  16, 3, "123", TRUE);
		check_str( s3,   5, 3, "123", FALSE);
		check_str( s4,  10, 3, "123", FALSE);

		Str_append_n( s1, "1234567890", 3 );
		Str_append_n( s3, "1234567890", 3 );
		Str_append_n( s4, "1234567890", 3 );

		check_str( s1,  16, 6, "123123", TRUE);
		check_str( s3,   5, 4, "1231",   FALSE);
		check_str( s4,  10, 6, "123123", FALSE);


		Str_set_n( s1, "123", 10 );
		Str_set_n( s3, "123", 10 );
		Str_set_n( s4, "123", 10 );

		check_str( s1,  16, 3, "123", TRUE);
		check_str( s3,   5, 3, "123", FALSE);
		check_str( s4,  10, 3, "123", FALSE);

		Str_append_n( s1, "123", 10 );
		Str_append_n( s3, "123", 10 );
		Str_append_n( s4, "123", 10 );

		check_str( s1,  16, 6, "123123", TRUE);
		check_str( s3,   5, 4, "1231",   FALSE);
		check_str( s4,  10, 6, "123123", FALSE);

		
		Str_clear( s1 ); Str_unreserve( s1 );
		Str_clear( s3 ); Str_unreserve( s3 );
		Str_clear( s4 ); Str_unreserve( s4 );
		
		
		/* clear */
		Str_clear( s1 );
		Str_clear( s3 );
		Str_clear( s4 );

		check_str( s1,   1, 0, "", TRUE);
		check_str( s3,   5, 0, "", FALSE);
		check_str( s4,  10, 0, "", FALSE);
		

		Str_clear( s1 ); Str_unreserve( s1 );
		Str_clear( s3 ); Str_unreserve( s3 );
		Str_clear( s4 ); Str_unreserve( s4 );
		

		/* reserve in 16-byte blocks */
		Str_reserve( s1, 15 );
		Str_reserve( s3, 15 );
		Str_reserve( s4, 15 );
		
		check_str( s1,  16, 0, "", TRUE);
		check_str( s3,   5, 0, "", FALSE);
		check_str( s4,  10, 0, "", FALSE);
			
		Str_reserve( s1,  16 );
		Str_reserve( s3,  16 );
		Str_reserve( s4,  16 );
		
		check_str( s1,  32, 0, "", TRUE);
		check_str( s3,   5, 0, "", FALSE);
		check_str( s4,  10, 0, "", FALSE);
			
		Str_reserve( s1, 31 );
		Str_reserve( s3, 31 );
		Str_reserve( s4, 31 );
		
		check_str( s1,  32, 0, "", TRUE);
		check_str( s3,   5, 0, "", FALSE);
		check_str( s4,  10, 0, "", FALSE);

		
		Str_clear( s1 ); Str_unreserve( s1 );
		Str_clear( s3 ); Str_unreserve( s3 );
		Str_clear( s4 ); Str_unreserve( s4 );
		

		/* clone */
		Str_set( s1, "hello" );
		Str_set( s3, "hello" );
		Str_set( s4, "hello" );
		
		check_str( s1,  16, 5, "hello", TRUE);
		check_str( s3,   5, 4, "hell",  FALSE);
		check_str( s4,  10, 5, "hello", FALSE);

		s2 = Str_clone( s1 );
		check_str( s2,  16, 5, "hello", TRUE);
		if (s1 == s2)					ERROR;
		if (s1->str == s2->str)			ERROR;
		OBJ_DELETE( s2 );
		if (s2)							ERROR;


		Str_clear( s1 ); Str_unreserve( s1 );
		Str_clear( s3 ); Str_unreserve( s3 );
		Str_clear( s4 ); Str_unreserve( s4 );
		
		
		/* sprintf */
		Str_sprintf( s1, "%s %d", "hello", 123);		/* BUG_0046 */
		Str_sprintf( s3, "%s %d", "hello", 123);
		Str_sprintf( s4, "%s %d", "hello", 123);
		
		check_str( s1,  16, 9, "hello 123", TRUE);
		check_str( s3,   5, 4, "hell",      FALSE);
		check_str( s4,  10, 9, "hello 123", FALSE);

		/* append_sprintf */
		Str_append_sprintf( s1, "%s", "");	/* empty */
		Str_append_sprintf( s3, "%s", "");	/* empty */
		Str_append_sprintf( s4, "%s", "");	/* empty */
		
		check_str( s1,  16, 9, "hello 123", TRUE);
		check_str( s3,   5, 4, "hell",      FALSE);
		check_str( s4,  10, 9, "hello 123", FALSE);

		Str_append_sprintf( s1, "%s", " and world");
		Str_append_sprintf( s3, "%s", " and world");
		Str_append_sprintf( s4, "%s", " and world");
		
		check_str( s1,  32, 19, "hello 123 and world", TRUE);
		check_str( s3,   5,  4, "hell",                FALSE);
		check_str( s4,  10,  9, "hello 123",           FALSE);


		Str_clear( s1 ); Str_unreserve( s1 );
		Str_clear( s3 ); Str_unreserve( s3 );
		Str_clear( s4 ); Str_unreserve( s4 );


		/* vsprintf */
		assert( ! call_vsprintf( s1, "%s %d", "hello", 123) );		/* BUG_0046 */
		assert(   call_vsprintf( s1, "%s %d", "hello", 123) );
		assert(   call_vsprintf( s3, "%s %d", "hello", 123) );
		assert(   call_vsprintf( s4, "%s %d", "hello", 123) );
		
		check_str( s1,  16, 9, "hello 123", TRUE);
		check_str( s3,   5, 4, "hell",      FALSE);
		check_str( s4,  10, 9, "hello 123", FALSE);
		
		/* append_vsprintf */
		assert(   call_append_vsprintf( s1, "%s", "") );	/* empty */
		assert(   call_append_vsprintf( s3, "%s", "") );	/* empty */
		assert(   call_append_vsprintf( s4, "%s", "") );	/* empty */
		
		check_str( s1,  16, 9, "hello 123", TRUE);
		check_str( s3,   5, 4, "hell",      FALSE);
		check_str( s4,  10, 9, "hello 123", FALSE);
		
		assert( ! call_append_vsprintf( s1, "%s", " and world") );	/* BUG_0046 */
		assert(   call_append_vsprintf( s1, "%s", " and world") );
		assert(   call_append_vsprintf( s3, "%s", " and world") );
		assert(   call_append_vsprintf( s4, "%s", " and world") );

		check_str( s1,  32, 19, "hello 123 and world", TRUE);
		check_str( s3,   5,  4, "hell",                FALSE);
		check_str( s4,  10,  9, "hello 123",           FALSE);


		Str_clear( s1 ); Str_unreserve( s1 );
		Str_clear( s3 ); Str_unreserve( s3 );
		Str_clear( s4 ); Str_unreserve( s4 );


		/* unreserve and sprintf */
		Str_sprintf( s1, "%d", 12345 );
		Str_sprintf( s3, "%d", 12345 );
		Str_sprintf( s4, "%d", 12345 );
		
		check_str( s1,  16, 5, "12345", TRUE);
		check_str( s3,   5, 4, "1234",  FALSE);
		check_str( s4,  10, 5, "12345", FALSE);
	}
	
	/* static */
	{
		Str * p;

		p = INIT_OBJ( Str, &static_s1 );
		if (! p)						ERROR;
		if (p != static_s1)				ERROR;
		
		p = INIT_OBJ( Str, &static_s1 );
		if (! p)						ERROR;
		if (p != static_s1)				ERROR;
		
		Str_set( static_s1, "1234567890" );
		Str_set( static_s2, "1234567890" );

		check_str( static_s1,  16, 10, "1234567890", TRUE);
		check_str( static_s2,   5,  4, "1234",       FALSE);
	}
	
	/* getline */
	{
		Str *s1 = OBJ_NEW(Str);
		DEFINE_STR( s2, 10 );
		FILE * fp;
	
		FOPEN("test.1.asm");
		GETLINE( s1, "", FALSE);
		FCLOSE();
		
		FOPEN("test.1.asm");
		GETLINE( s2, "", FALSE);
		FCLOSE();
		
		GET_ABCDE( s1, "test.2.asm" );
		GET_ABCDE( s1, "test.3.asm" );
		GET_ABCDE( s1, "test.4.asm" );
		GET_ABCDE( s1, "test.5.asm" );
		GET_ABCDE( s1, "test.6.asm" );

		GET_ABCDE( s2, "test.2.asm" );
		GET_ABCDE( s2, "test.3.asm" );
		GET_ABCDE( s2, "test.4.asm" );
		GET_ABCDE( s2, "test.5.asm" );
		GET_ABCDE( s2, "test.6.asm" );

		FOPEN("test.7.asm");
		GETLINE( s1, 
				"xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx"
				"xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx"
				"xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx"
				"xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx"
				"xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx"
				"xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx"
				"xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx"
				"xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx"
				"xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx"
				"xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx"
				"xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx"
				"xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx"
				"xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx"
				"xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx"
				"xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx"
				"xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx"
				"xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx"
				"xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx"
				"xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx"
				"xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx"
				"xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx"
				"xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx" "xxxxxxxxxx"
				"\n", TRUE);
		GETLINE( s1, "", FALSE);
		FCLOSE();
		
		FOPEN("test.7.asm");
		GETLINE( s2, "xxxxxxxxx", TRUE);
		GETLINE( s2, "", FALSE);
		FCLOSE();
	}
		
	/* getchars */
	{
		Str *s1 = OBJ_NEW(Str);
		DEFINE_STR( s2, 10 );
		DEFINE_STR( s3,  3 );
		FILE *fp;

		FOPEN("test.8.asm");
		GETCHARS( s1, 3, "ABC",  TRUE );
		GETCHARS( s1, 3, "DEF",  TRUE );
		GETCHARS( s1, 3, "GHI",  TRUE );
		GETCHARS( s1, 3, "J\na", TRUE );
		GETCHARS( s1, 3, "bcd",  TRUE );
		GETCHARS( s1, 3, "efg",  TRUE );
		GETCHARS( s1, 3, "hij",  TRUE );
		GETCHARS( s1, 3, "\n",   FALSE );
		FCLOSE();

		FOPEN("test.8.asm");
		GETCHARS( s2, 3, "ABC",  TRUE );
		GETCHARS( s2, 3, "DEF",  TRUE );
		GETCHARS( s2, 3, "GHI",  TRUE );
		GETCHARS( s2, 3, "J\na", TRUE );
		GETCHARS( s2, 3, "bcd",  TRUE );
		GETCHARS( s2, 3, "efg",  TRUE );
		GETCHARS( s2, 3, "hij",  TRUE );
		GETCHARS( s2, 3, "\n",   FALSE );
		FCLOSE();

		FOPEN("test.8.asm");
		GETCHARS( s3, 3, "AB",  TRUE );
		GETCHARS( s3, 3, "DE",  TRUE );
		GETCHARS( s3, 3, "GH",  TRUE );
		GETCHARS( s3, 3, "J\n", TRUE );
		GETCHARS( s3, 3, "bc",  TRUE );
		GETCHARS( s3, 3, "ef",  TRUE );
		GETCHARS( s3, 3, "hi",  TRUE );
		GETCHARS( s3, 3, "\n",  FALSE );
		FCLOSE();
	}
	
	return 0;
}
END
system($compile) and die "compile failed: $compile\n";

t_capture("./test", "", "", 0);

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
