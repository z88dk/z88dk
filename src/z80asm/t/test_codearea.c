/*
Unit test for codearea.c

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/test_codearea.c,v 1.4 2014-06-21 02:15:44 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "codearea.h"

#include <glib.h>
#include <stdio.h>
#include <stdarg.h>

char *GetLibfile( char *filename ) { return ""; }

static void dump_sections(char *title, int line)
{
	Section *section, *first_section, *last_section, *old_cur_section;
	SectionHashElem *iter;
	UInt addr, size, total_size;
	UInt num_sections;
	UInt num_modules;
	UInt i, j;
	int old_cur_module_id;

	num_sections = total_size = 0;
	first_section = last_section = NULL;
	for ( section = get_first_section( &iter ) ; section != NULL ; 
		  section = get_next_section( &iter ) )
	{
		if ( first_section == NULL )
			first_section = section;
		last_section = section;

		size = ByteArray_size( section->bytes );
		g_assert_cmpuint( size, ==, get_section_size( section ) );
		total_size += size;

		if ( section == get_cur_section() )
			g_assert_cmpuint( get_PC(), ==, section->asmpc );

		num_sections++;
	}
	g_assert( last_section == get_last_section() );
	g_assert_cmpuint( total_size, ==, get_sections_size() );

	g_printerr("%s (line %d)\n\n", title, line );

	g_printerr("Number of sections = %ld, total size = %ld\n", 
		       (long) num_sections, (long) total_size );

	i = 0;
	for ( section = get_first_section( &iter ) ; section != NULL ; 
		  section = get_next_section( &iter ) )
	{
		g_printerr("%c%d. \"%s\", size = %ld, addr = %ld, asmpc = %ld, opcode_size = %ld\n", 
				   section == get_cur_section() ? '*' : ' ',
				   ++i, section->name,  
				   (long) get_section_size( section ),
				   (long) section->addr, (long) section->asmpc, (long) section->opcode_size );
		g_printerr("    bytes =");
		for ( j = 0; j < ByteArray_size( section->bytes ); j++ )
			g_printerr("%s$%02X", 
					   j != 1 && (j % 16) == 1 ? "\n            " : " ",
					   *ByteArray_item( section->bytes, j ) );
		g_printerr("\n    start =");
		for ( j = 0; j < UIntArray_size( section->module_start ); j++ )
			g_printerr(" %3ld", (long) *UIntArray_item( section->module_start, j ) );
		g_printerr("\n");
	}

	num_modules = UIntArray_size( first_section->module_start );
	g_printerr("\nNumber of modules = %ld\n", 
		       (long) num_modules );

	for ( i = 0; i < num_modules; i++ )
	{
		old_cur_module_id = get_cur_module_id();
		old_cur_section   = get_cur_section();

		set_cur_module_id( i );

		for ( section = get_first_section( &iter ) ; section != NULL ; 
			  section = get_next_section( &iter ) )
		{
			set_cur_section( section );

			addr = get_cur_module_start();
			size = get_cur_module_size();

			if ( section == first_section )
				g_printerr("%c%d. ", i == old_cur_module_id ? '*' : ' ', i );
			else 
				g_printerr("    ");

			g_printerr("\"%s\", start = %ld, size = %ld\n    bytes =",
					   section->name, (long) addr, (long) size );
			for ( j = 0; j < size; j++ )
				g_printerr("%s$%02X", 
						   j != 1 && (j % 16) == 1 ? "\n            " : " ",
						   *ByteArray_item( section->bytes, addr + j )  );
			g_printerr("\n");
		}

		set_cur_module_id( old_cur_module_id );
		set_cur_section( old_cur_section );
	}

	g_printerr("--------------------------------------------------------------------------------\n");
}

static void dump_file( char *title )
{
	FILE *file;
	int i, c;

	g_printerr("Dump file %s\n\n", title );
	g_assert( file = fopen("test.bin", "rb") );
	g_printerr("test.bin =");
	
	for ( i = 0; (c = fgetc( file )) != EOF; i++ )
		g_printerr("%s$%02X", 
				   i != 0 && (i % 16) == 0 ? "\n           " : " ", 
				   c );
	g_printerr("\n--------------------------------------------------------------------------------\n");
}

#define T(code) code; dump_sections(#code ";", __LINE__);

static void test_sections( void )
{
	Section *section_blank, *section_code, *section_data;
	UInt addr;
	int module_id;
	FILE *file;
	Byte *p;
	UInt i, size;
	char title[256];

	T( reset_codearea() );
	
	/* check "" section */
	T( section_blank = new_section("") );
	g_assert( section_blank == get_cur_section() );
	
	/* create module 0 - only bytes in "" */
	T( module_id = new_module_id() );
	g_assert_cmpint( module_id, ==, 0 );
	g_assert( get_cur_section() == section_blank );

	/* append no data */
	T( p = append_reserve( 0 ) );
	g_assert( p == NULL );

	/* append */
	T( append_byte( 1 ) );
	T( next_PC() );
	T( append_word( 0x0302 ) );
	T( next_PC() );
	T( append_long( 0x07060504 ) );
	T( next_PC() );
	T( append_value( 0x0A0908, 3 ) );
	T( next_PC() );
	T( append_2bytes( 11, 12 ) );
	T( next_PC() );
	T( p = append_reserve( 5 ) );
	T( next_PC() );
	
	/* use buffer from append_reserve */
	g_assert( p != NULL );
	g_assert_cmpint( p[0], ==, 0 );
	g_assert_cmpint( p[1], ==, 0 );
	g_assert_cmpint( p[2], ==, 0 );
	g_assert_cmpint( p[3], ==, 0 );
	g_assert_cmpint( p[4], ==, 0 );
	T( memcpy( p, "hello", 5 ) );

	g_assert( file = fopen("test.bin", "wb") );
	fwrite("\xF1\xF2\xF3", 1, 3, file );
	fclose( file );
	
	/* read whole file */
	g_assert( file = fopen("test.bin", "rb") );

	T( append_file_contents( file, -1 ) );
	T( next_PC() );

	/* read zero bytes */
	T( append_file_contents( file, -1 ) );
	T( next_PC() );

	/* read 1 byte from start */
	fseek( file, 0, SEEK_SET );
	T( append_file_contents( file, 1 ) );
	T( next_PC() );

	/* read 1 byte fom middle */
	fseek( file, 2, SEEK_SET );
	T( append_file_contents( file, 1 ) );
	T( next_PC() );

	/* patch */
	addr = 0;
	T( patch_byte( &addr, 12 ) );
	g_assert_cmpuint( addr, ==, 1 );

	T( patch_word( &addr, 0x0A0B ) );
	g_assert_cmpuint( addr, ==, 3 );

	T( patch_long( &addr, 0x06070809 ) );
	g_assert_cmpuint( addr, ==, 7 );

	T( patch_value( &addr, 0x030405, 3 ) );
	g_assert_cmpuint( addr, ==, 10 );

	/* patch whole file */
	fseek( file, 0, SEEK_SET );
	T( patch_file_contents( file, &addr, -1 ) );
	g_assert_cmpuint( addr, ==, 13 );

	/* patch part of file */
	fseek( file, 1, SEEK_SET );
	T( patch_file_contents( file, &addr, -1 ) );
	g_assert_cmpuint( addr, ==, 15 );

	/* patch part of file */
	fseek( file, 0, SEEK_SET );
	T( patch_file_contents( file, &addr, 2 ) );
	g_assert_cmpuint( addr, ==, 17 );

	/* patch expands buffer */
	addr += 4;
	fseek( file, 0, SEEK_SET );
	T( patch_file_contents( file, &addr, -1 ) );
	g_assert_cmpuint( addr, ==, 24 );

	T( next_PC() );

	fclose( file );
	remove("test.bin");

	/* create module 1 - only bytes in "code" */
	T( module_id = new_module_id() );
	g_assert_cmpint( module_id, ==, 1 );
	g_assert( get_cur_section() == section_blank );

	/* create section "code" */
	T( section_code = new_section("code") );
	g_assert( get_cur_section() == section_code );

	T( append_long(0x78563412) );
	T( next_PC() );

	T( append_long(0xF0DEBC9A) );
	T( next_PC() );

	/* create module 2 - only bytes in "data" */
	T( module_id = new_module_id() );
	g_assert_cmpint( module_id, ==, 2 );
	g_assert( get_cur_section() == section_blank );

	T( section_data = new_section("data") );
	g_assert( get_cur_section() == section_data );

	T( memcpy( append_reserve( 11 ), "hello world", 11 ) );
	T( next_PC() );
	
	/* create module 3 - bytes in all sections */
	T( module_id = new_module_id() );
	g_assert_cmpint( module_id, ==, 3 );
	g_assert( get_cur_section() == section_blank );

	T( new_section("data") );
	g_assert( get_cur_section() == section_data );
	T( append_byte(0xAA) );
	T( next_PC() );

	T( new_section("code") );
	g_assert( get_cur_section() == section_code );
	T( append_byte(0xAA) );
	T( next_PC() );

	T( new_section("") );
	g_assert( get_cur_section() == section_blank );
	T( append_byte(0xAA) );
	T( next_PC() );

	/* compute addresses */
	T( sections_alloc_addr( -1 ) );
	T( sections_alloc_addr( 100 ) );

	/* write each module */
#define T_MODULE(n,size) \
	T( set_cur_module_id( n ) ); \
	g_assert( file = fopen("test.bin", "wb") ); \
	g_assert( size == fwrite_module_code( file ) ); \
	fclose( file ); \
	dump_file("module " #n );

	T_MODULE( 0, 24 );
	T_MODULE( 1,  8 );
	T_MODULE( 2, 11 );
	T_MODULE( 3,  3 );
#undef T_MODULE

	/* write whole code area */
	g_assert( file = fopen("test.bin", "wb") ); 
	fwrite_codearea( file ); 
	fclose( file );
	dump_file("code area ");

	/* write in chunks of 8 bytes */
	size = 8;
	for ( i = 0; i < get_sections_size(); i += size )
	{
		if ( i + size > get_sections_size() )
			size = get_sections_size() - i;

		sprintf(title, "Chunk from %d to %d, %d bytes", i, i+size-1, size );

		g_assert( file = fopen("test.bin", "wb") ); 
		fwrite_codearea_chunk( file, (UInt) i, (UInt) size ); 
		fclose( file );
		dump_file( title );
	}
}

int main( int argc, char *argv[] )
{
	g_test_init( &argc, &argv, NULL );
	g_test_add_func( "/Sections", test_sections );

	return g_test_run();
}
