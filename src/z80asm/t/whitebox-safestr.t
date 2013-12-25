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
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-safestr.t,v 1.10 2013-12-25 14:39:50 pauloscustodio Exp $
#
# Test safestr

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

my $objs = "safestr.o lib/strutil.o";

write_file(asm1_file(), {binmode => ':raw'}, "");
write_file(asm2_file(), {binmode => ':raw'}, "A\nB\rC\r\nD\n\rE");
write_file(asm3_file(), {binmode => ':raw'}, "A\nB\rC\r\nD\n\rE\n");
write_file(asm4_file(), {binmode => ':raw'}, "A\nB\rC\r\nD\n\rE\r");
write_file(asm5_file(), {binmode => ':raw'}, "A\nB\rC\r\nD\n\rE\r\n");
write_file(asm6_file(), {binmode => ':raw'}, "A\nB\rC\r\nD\n\rE\n\r");
write_file(asm7_file(), {binmode => ':raw'}, "ABCDEFGHIJ\nabcdefghij\n");

t_compile_module(<<'INIT', <<'END', $objs);
#define SZ (5)
#define ERROR return __LINE__
#define TEST(s,is) \
	if (s->size != SZ)					ERROR;	\
	if (strcmp(s->data, is))			ERROR;	\
	if (sstr_len(s) != strlen(is))	ERROR

char * test_vfset(sstr_t *self, char *format, ...)
{
	va_list argptr;
	va_start(argptr, format);	/* init variable args */

	return sstr_vfset(self, format, argptr);
}

char * test_vfcat(sstr_t *self, char *format, ...)
{
	va_list argptr;
	va_start(argptr, format);	/* init variable args */

	return sstr_vfcat(self, format, argptr);
}

void dump_sstr( sstr_t *s )
{
	int j;
	
	for ( j = 0; j < sstr_len( s ) ; j++ )
	{
		if ( sstr_data( s )[j] > ' ' )
			warn("%c", sstr_data( s )[j] );
		else
			warn("<%02X>", sstr_data( s )[j] );
	}
	warn("\n");
}


SSTR_DEFINE(global, SZ);

INIT
	char buffer[5];
	SSTR_DEFINE( s, SZ );
	SSTR_DEFINE_REF( s2, buffer, sizeof(buffer) );
	char filename[FILENAME_MAX];
	int i;
	FILE *fp;
	char *p;
	BOOL b;

	TEST(s, "");
	p = sstr_set(s, "");
	if (p != sstr_data(s))			ERROR;
	TEST(s, "");
	
	TEST(global, "");
	p = sstr_set(global, "");
	if (p != sstr_data(global))		ERROR;
	TEST(global, "");

	
	sstr_set(s, "1234");
	TEST(s, "1234");
	sstr_set(s, "123");
	TEST(s, "123");
	sstr_set(s, "");
	TEST(s, "");
	
	sstr_set(global, "1234");
	TEST(global, "1234");
	sstr_set(global, "123");
	TEST(global, "123");
	sstr_set(global, "");
	TEST(global, "");
	

	p = sstr_cat(s, "");
	if (p != sstr_data(s))			ERROR;
	TEST(s, "");

	sstr_cat(s, "1");
	TEST(s, "1");
	sstr_cat(s, "2");
	TEST(s, "12");
	sstr_cat(s, "3");
	TEST(s, "123");
	sstr_cat(s, "4");
	TEST(s, "1234");
	sstr_cat(s, "5");
	TEST(s, "1234");
	
	sstr_clear(s);
	TEST(s, "");

	p = sstr_fset(s, "");
	if (p != sstr_data(s))			ERROR;
	TEST(s, "");

	sstr_fset(s, "%d", 1);
	TEST(s, "1");
	sstr_fset(s, "%d", 12);
	TEST(s, "12");
	sstr_fset(s, "%d", 123);
	TEST(s, "123");
	sstr_fset(s, "%d", 1234);
	TEST(s, "1234");
	sstr_fset(s, "%d", 12345);
	TEST(s, "1234");
	sstr_fset(s, "%d", 123456);
	TEST(s, "1234");
	
	p = sstr_fcat(s, "");
	if (p != sstr_data(s))			ERROR;
	TEST(s, "1234");

	sstr_clear(s);
	TEST(s, "");

	sstr_fcat(s, "%d", 1);
	TEST(s, "1");
	sstr_fcat(s, "%d", 2);
	TEST(s, "12");
	sstr_fcat(s, "%d", 3);
	TEST(s, "123");
	sstr_fcat(s, "%d", 4);
	TEST(s, "1234");
	sstr_fcat(s, "%d", 5);
	TEST(s, "1234");
	sstr_fcat(s, "%d", 56);
	TEST(s, "1234");
	sstr_fcat(s, "%d", 567);
	TEST(s, "1234");
	
	sstr_clear(s);
	TEST(s, "");

	p = test_vfset(s, "");
	if (p != sstr_data(s))			ERROR;
	TEST(s, "");

	test_vfset(s, "%d", 1);
	TEST(s, "1");
	test_vfset(s, "%d", 12);
	TEST(s, "12");
	test_vfset(s, "%d", 123);
	TEST(s, "123");
	test_vfset(s, "%d", 1234);
	TEST(s, "1234");
	test_vfset(s, "%d", 12345);
	TEST(s, "1234");
	
	p = test_vfcat(s, "");
	if (p != sstr_data(s))			ERROR;
	TEST(s, "1234");

	sstr_clear(s);
	TEST(s, "");

	test_vfcat(s, "%d", 1);
	TEST(s, "1");
	test_vfcat(s, "%d", 2);
	TEST(s, "12");
	test_vfcat(s, "%d", 3);
	TEST(s, "123");
	test_vfcat(s, "%d", 4);
	TEST(s, "1234");
	test_vfcat(s, "%d", 5);
	TEST(s, "1234");

	// test SSTR_DEFINE_REF()
	if (s2->data != buffer)				ERROR;
	if (s2->size != 5)					ERROR;

	// chomp
	sstr_set(s, "\rx\r\n");
	sstr_chomp(s);
	TEST(s, "\rx");
	
	sstr_set(s, "\r\n \t");
	sstr_chomp(s);
	TEST(s, "");

	sstr_set(s, "\f\r\t\f");
	sstr_chomp(s);
	TEST(s, "");

	// getchars
	sprintf( filename, "test7.asm" );
	fp = fopen( filename, "rb" );
	if ( fp == NULL ) ERROR;
	warn("Read file %s:\n", filename );
	do
	{
		b = sstr_getchars( s, fp, 3 );
		warn("getchars(3) got %d, ", b);
		dump_sstr( s );
	} while ( b );
	
	// getline
	for ( i = 1 ; 1 ; i++ )
	{
		sprintf( filename, "test%d.asm", i );
		fp = fopen( filename, "rb" );
		if ( fp == NULL )
			break;
			
		warn("Read file %s:\n", filename );
		
		while ( sstr_getline( s, fp ) )
			dump_sstr( s );
		
		sstr_set( s, "hello" );
		if ( sstr_getline( s, fp ) )	ERROR;
		if ( sstr_len( s ) > 0 )		ERROR;
		
		fclose( fp );
	}
	
	
	
	return 0;
END

t_run_module([], '', <<'END', 0);
Read file test7.asm:
getchars(3) got 1, ABC
getchars(3) got 1, DEF
getchars(3) got 1, GHI
getchars(3) got 1, J<0A>a
getchars(3) got 1, bcd
getchars(3) got 1, efg
getchars(3) got 1, hij
getchars(3) got 0, <0A>
Read file test1.asm:
Read file test2.asm:
A<0A>
B<0A>
C<0A>
D<0A>
E<0A>
Read file test3.asm:
A<0A>
B<0A>
C<0A>
D<0A>
E<0A>
Read file test4.asm:
A<0A>
B<0A>
C<0A>
D<0A>
E<0A>
Read file test5.asm:
A<0A>
B<0A>
C<0A>
D<0A>
E<0A>
Read file test6.asm:
A<0A>
B<0A>
C<0A>
D<0A>
E<0A>
Read file test7.asm:
ABCD
abcd
END

unlink_testfiles();
done_testing;


__END__
# $Log: whitebox-safestr.t,v $
# Revision 1.10  2013-12-25 14:39:50  pauloscustodio
# Move strutil.c to the z80asm/lib directory
#
# Revision 1.9  2013/12/15 13:18:35  pauloscustodio
# Move memory allocation routines to lib/xmalloc, instead of glib,
# introduce memory leak report on exit and memory fence check.
#
# Revision 1.8  2013/09/24 00:05:36  pauloscustodio
# Replaced chomp by g_strchomp; tolower by g_ascii_tolower;
# toupper by g_ascii_toupper; stricompare by g_ascii_strcasecmp.
# Removed normalize_eol.
#
# Revision 1.7  2013/09/09 00:20:45  pauloscustodio
# Add default set of modules to t_compile_module:
# -DMEMALLOC_DEBUG xmalloc.c die.o except.o strpool.o
#
# Revision 1.6  2013/05/07 22:10:56  pauloscustodio
# sstr_getchars(): get N characters from input, return FALSE on EOF
#
# Revision 1.5  2013/05/01 22:23:39  pauloscustodio
# Added chomp and normalize_eol
#
# Revision 1.4  2013/05/01 21:37:50  pauloscustodio
# Added chset, chcat and getline
#
# Revision 1.3  2013/04/06 10:55:15  pauloscustodio
# SSTR_DEFINE() caused compilation error "C2099: initializer is not a constant" when used to define global variables
#
# Revision 1.2  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.1  2012/06/14 15:01:27  pauloscustodio
# Split safe strings from strutil.c to safestr.c
#
