/*
Unit test for codearea.c

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/test_codearea.c,v 1.1 2014-06-13 15:51:59 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "codearea.h"

#include <glib.h>
#include <stdio.h>
#include <stdarg.h>

char *GetLibfile( char *filename ) { return ""; }

static void test_bytes( int val, ...)
{
	Section *section = get_cur_section();
	UInt size = ByteArray_size( section->bytes );
	va_list ap;
	Byte *pitem;
	UInt i;

	va_start( ap, val );
	for ( i = 0; val >= 0 && i < size; i++ )
	{
		pitem = ByteArray_item( section->bytes, i );
		g_assert_cmpuint( *pitem, ==, (Byte) val );
		
		val = va_arg( ap, int );
	}
	va_end( ap );
	
	g_assert_cmpuint( i, ==, size );
}

static void test_module_start( int val, ... )
{
	Section *section = get_cur_section();
	UInt size = UIntArray_size( section->module_start );
	va_list ap;
	UInt i;
	UInt *pitem;

	va_start( ap, val );
	for ( i = 0; val >= 0 && i < size; i++ )
	{
		pitem = UIntArray_item( section->module_start, i );
		g_assert_cmpuint( *pitem, ==, (UInt) val );
		
		val = va_arg( ap, int );
	}
	va_end( ap );
	
	g_assert_cmpuint( i, ==, size );
}

static void test_reset_codearea( void )
{
	Section *section;
	SectionHashElem *iter;
	
	reset_codearea();
	
	test_bytes(-1);
	test_module_start(-1);
	
	section = sections_first( &iter ); 
	g_assert( iter ); 
	g_assert( section );
	g_assert( section == get_cur_section() );
	g_assert( section == get_default_section() );
	g_assert_cmpstr(  section->name, ==, "" );
	g_assert_cmpuint( section->addr, ==, 0 );
	g_assert_cmpuint( section->asmpc, ==, 0 );
	g_assert_cmpuint( section->opcode_size, ==, 0 );
	
	test_bytes(-1);
	test_module_start(-1);
	
	section = sections_next( &iter ); 
	g_assert( ! iter ); 
	g_assert( ! section );
}

static void test_sections( void )
{
	Section *section, *section_blank, *section_code;
	SectionHashElem *iter;
	int module_id;
	UInt addr;
	
	test_reset_codearea();
	
	/* "" section */
	section_blank = get_default_section();
	g_assert( section_blank == get_cur_section() );
	
	/* module 0 - only bytes in "" */
	module_id = section_new_module();

	g_assert_cmpint( module_id, ==, 0 );
	test_module_start(0, -1);
	
	addr = section_module_start( section_blank, module_id );
	g_assert_cmpuint( addr, ==, 0 );
	test_module_start(0, -1);

	/* append */
	g_assert_cmpuint( get_section_size( get_cur_section() ), ==, 0 );
	append_byte( 1 );
	g_assert_cmpuint( get_PC(), ==, 0 );
	g_assert_cmpuint( get_section_size( get_cur_section() ), ==, 1 );
	next_PC();
	g_assert_cmpuint( get_PC(), ==, 1 );
	test_bytes( 1, -1);

	set_PC( 10 );
	append_word( 0x0302 );
	next_PC();
	g_assert_cmpuint( get_PC(), ==, 12 );
	g_assert_cmpuint( get_section_size( get_cur_section() ), ==, 3 );
	test_bytes( 1, 2, 3, -1);

	append_long( 0x07060504 );
	next_PC();
	g_assert_cmpuint( get_PC(), ==, 16 );
	g_assert_cmpuint( get_section_size( get_cur_section() ), ==, 7 );
	test_bytes( 1, 2, 3, 4, 5, 6, 7, -1);

	append_value( 0x0A0908, 3 );
	next_PC();
	g_assert_cmpuint( get_PC(), ==, 19 );
	g_assert_cmpuint( get_section_size( get_cur_section() ), ==, 10 );
	test_bytes( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, -1);

	append_2bytes( 11, 12 );
	next_PC();
	g_assert_cmpuint( get_PC(), ==, 21 );
	g_assert_cmpuint( get_section_size( get_cur_section() ), ==, 12 );
	test_bytes( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, -1);

	/* patch */
	addr = 0; 
	patch_byte( &addr, 12 );
	next_PC();
	g_assert_cmpuint( addr, ==, 1 );
	g_assert_cmpuint( get_PC(), ==, 21 );
	g_assert_cmpuint( get_section_size( get_cur_section() ), ==, 12 );
	test_bytes( 12, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, -1);

	patch_word( &addr, 0x0A0B );
	next_PC();
	g_assert_cmpuint( addr, ==, 3 );
	g_assert_cmpuint( get_PC(), ==, 21 );
	g_assert_cmpuint( get_section_size( get_cur_section() ), ==, 12 );
	test_bytes( 12, 11, 10, 4, 5, 6, 7, 8, 9, 10, 11, 12, -1);

	patch_long( &addr, 0x06070809 );
	next_PC();
	g_assert_cmpuint( addr, ==, 7 );
	g_assert_cmpuint( get_PC(), ==, 21 );
	g_assert_cmpuint( get_section_size( get_cur_section() ), ==, 12 );
	test_bytes( 12, 11, 10, 9, 8, 7, 6, 8, 9, 10, 11, 12, -1);

	patch_value( &addr, 0x030405, 3 );
	next_PC();
	g_assert_cmpuint( addr, ==, 10 );
	g_assert_cmpuint( get_PC(), ==, 21 );
	g_assert_cmpuint( get_section_size( get_cur_section() ), ==, 12 );
	test_bytes( 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 11, 12, -1);

	patch_value( &addr, 0x000102, 3 );
	next_PC();
	g_assert_cmpuint( addr, ==, 13 );
	g_assert_cmpuint( get_PC(), ==, 22 );
	g_assert_cmpuint( get_section_size( get_cur_section() ), ==, 13 );
	test_bytes( 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, -1);

	/* module 1 - only bytes in "code" */
	test_module_start(0, -1);
	module_id = section_new_module();
	g_assert_cmpint( module_id, ==, 1 );
	test_module_start(0, 13, -1);
	
	/* add section code */
	section_code = get_section("code");
	g_assert_cmpstr( section_code->name, ==, "code" );
	g_assert( get_cur_section() == get_default_section() );
	g_assert( get_cur_section() == section_blank );

	set_cur_section( get_section("code") );
	g_assert( get_cur_section() == section_code );
	
	section = sections_first( &iter ); 
	g_assert( iter ); 
	g_assert( section == section_blank );
	section = sections_next( &iter ); 
	g_assert( iter ); 
	g_assert( section == section_code );
	section = sections_next( &iter ); 
	g_assert( ! iter ); 
	g_assert( ! section );

	/* add bytes to module 1 two sections */
	set_cur_section( section_blank );
	append_byte( 1 );
	test_module_start( 0, 13, -1 );
	test_bytes( 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 1, -1);

	set_cur_section( section_code );
	addr = 5;
	patch_byte( &addr, 5 );
	test_module_start( 0, 0, -1 );
	test_bytes( 0, 0, 0, 0, 0, 5, -1);

	/* get start address irrespective of current section */
	g_assert_cmpuint( section_module_start( section_blank, 0 ), ==, 0 );
	g_assert_cmpuint( section_module_start( section_blank, 1 ), ==, 13 );
	g_assert_cmpuint( get_section_size( section_blank ), ==, 14 );

	g_assert_cmpuint( section_module_start( section_code, 0 ), ==, 0 );
	g_assert_cmpuint( section_module_start( section_code, 1 ), ==, 0 );
	g_assert_cmpuint( get_section_size( section_code ), ==, 6 );

	/* compute addresses */
	sections_alloc_addr( -1 );
	g_assert_cmpuint( section_blank->addr, ==, 0 );
	g_assert_cmpuint( section_code->addr, ==, 14 );
	g_assert_cmpuint( section_code->addr + get_section_size( section_code ), ==, 20 );

	sections_alloc_addr( 10 );
	g_assert_cmpuint( section_blank->addr, ==, 10 );
	g_assert_cmpuint( section_code->addr, ==, 24 );
	g_assert_cmpuint( section_code->addr + get_section_size( section_code ), ==, 30 );

}

int main( int argc, char *argv[] )
{
	g_test_init( &argc, &argv, NULL );
	g_test_add_func( "/Sections", test_sections );

	return g_test_run();
}

/*
* $Log: test_codearea.c,v $
* Revision 1.1  2014-06-13 15:51:59  pauloscustodio
* Added test_codearea.c using GLib's unit testing framework.
*
*
*/
