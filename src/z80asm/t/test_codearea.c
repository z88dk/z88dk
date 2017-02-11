/*
Z88DK Z80 Macro Assembler

Unit test for codearea.c

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "codearea.h"
#include "options.h"
#include <assert.h>
#include <stdio.h>
#include <stdarg.h>

int sizeof_relocroutine = 0;
int sizeof_reloctable = 0;

char *GetLibfile( char *filename ) { return ""; }

static void dump_sections(char *title, int line)
{
	Section *section, *first_section, *last_section, *old_cur_section;
	SectionHashElem *iter;
	int addr, size, total_size;
	int num_sections;
	int num_modules;
	int i, j;
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
		assert( size == get_section_size( section ) );
		total_size += size;

		if ( section == get_cur_section() )
			assert( get_PC() == section->asmpc );

		num_sections++;
	}
	assert( last_section == get_last_section() );
	assert( total_size == get_sections_size() );

	warn("%s (line %d)\n\n", title, line );

	warn("Number of sections = %ld, total size = %ld\n", 
		       (long) num_sections, (long) total_size );

	i = 0;
	for ( section = get_first_section( &iter ) ; section != NULL ; 
		  section = get_next_section( &iter ) )
	{
		warn("%c%d. \"%s\", size = %ld, addr = %ld, origin = %ld, asmpc = %ld, opcode_size = %ld\n", 
				   section == get_cur_section() ? '*' : ' ',
				   ++i, section->name,  
				   (long) get_section_size( section ),
				   (long) section->addr, (long) section->origin, (long) section->asmpc, 
				   (long) section->opcode_size );
		warn("    bytes =");
		for ( j = 0; j < ByteArray_size( section->bytes ); j++ )
			warn("%s$%02X", 
					   j != 1 && (j % 16) == 1 ? "\n            " : " ",
					   *ByteArray_item( section->bytes, j ) );
		warn("\n    start =");
		for ( j = 0; j < intArray_size( section->module_start ); j++ )
			warn(" %3ld", (long) *intArray_item( section->module_start, j ) );
		warn("\n");
	}

	num_modules = intArray_size( first_section->module_start );
	warn("\nNumber of modules = %ld\n", 
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
				warn("%c%d. ", i == old_cur_module_id ? '*' : ' ', i );
			else 
				warn("    ");

			warn("\"%s\", start = %ld, size = %ld\n    bytes =",
					   section->name, (long) addr, (long) size );
			for ( j = 0; j < size; j++ )
				warn("%s$%02X", 
						   j != 1 && (j % 16) == 1 ? "\n            " : " ",
						   *ByteArray_item( section->bytes, addr + j )  );
			warn("\n");
		}

		set_cur_module_id( old_cur_module_id );
		set_cur_section( old_cur_section );
	}

	warn("--------------------------------------------------------------------------------\n");
}

static void dump_file( char *title )
{
	FILE *file;
	int i, c;

	warn("Dump file %s\n\n", title );
	assert( (file = fopen("test.bin", "rb")) != NULL );
	warn("test.bin =");
	
	for ( i = 0; (c = fgetc( file )) != EOF; i++ )
		warn("%s$%02X", 
				   i != 0 && (i % 16) == 0 ? "\n           " : " ", 
				   c );
	warn("\n--------------------------------------------------------------------------------\n");
}

#define T(code) code; dump_sections(#code ";", __LINE__);

static void test_sections( void )
{
	Section *section_blank, *section_code, *section_data;
	int module_id;
	FILE *file;
	FILE *reloc = NULL;
	Byte *p;

	T( reset_codearea() );
	
	/* check "" section */
	T( section_blank = new_section("") );
	assert( section_blank == get_cur_section() );
	
	/* create module 0 - only bytes in "" */
	T( module_id = new_module_id() );
	assert( module_id == 0 );
	assert( get_cur_section() == section_blank );

	/* append no data */
	T( p = append_reserve( 0 ) );
	assert( p == NULL );

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
	assert( p != NULL );
	assert( p[0] == 0 );
	assert( p[1] == 0 );
	assert( p[2] == 0 );
	assert( p[3] == 0 );
	assert( p[4] == 0 );
	T( memcpy( p, "hello", 5 ) );

	assert( (file = fopen("test.bin", "wb")) != NULL );
	fwrite("\xF1\xF2\xF3", 1, 3, file );
	fclose( file );
	
	/* read whole file */
	assert( (file = fopen("test.bin", "rb")) != NULL );

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
	T( patch_byte( 0, 12 ) );
	T( patch_word( 1, 0x0A0B ) );
	T( patch_long( 3, 0x06070809 ) );
	T( patch_value( 7, 0x030405, 3 ) );

	/* patch whole file */
	fseek( file, 0, SEEK_SET );
	T( patch_file_contents( file, 10, -1 ) );

	/* patch part of file */
	fseek( file, 1, SEEK_SET );
	T( patch_file_contents( file, 13, -1 ) );

	/* patch part of file */
	fseek( file, 0, SEEK_SET );
	T( patch_file_contents( file, 15, 2 ) );

	/* patch expands buffer */
	fseek( file, 0, SEEK_SET );
	T( patch_file_contents( file, 21, -1 ) );

	T( next_PC() );

	fclose( file );
	remove("test.bin");

	/* create module 1 - only bytes in "code" */
	T( module_id = new_module_id() );
	assert( module_id == 1 );
	assert( get_cur_section() == section_blank );

	/* create section "code" */
	T( section_code = new_section("code") );
	assert( get_cur_section() == section_code );

	T( append_long(0x78563412) );
	T( next_PC() );

	T( append_long(0xF0DEBC9A) );
	T( next_PC() );

	/* create module 2 - only bytes in "data" */
	T( module_id = new_module_id() );
	assert( module_id == 2 );
	assert( get_cur_section() == section_blank );

	T( section_data = new_section("data") );
	assert( get_cur_section() == section_data );

	T( memcpy( append_reserve( 11 ), "hello world", 11 ) );
	T( next_PC() );
	
	/* create module 3 - bytes in all sections */
	T( module_id = new_module_id() );
	assert( module_id == 3 );
	assert( get_cur_section() == section_blank );

	T( new_section("data") );
	assert( get_cur_section() == section_data );
	T( append_byte(0xAA) );
	T( next_PC() );

	T( new_section("code") );
	assert( get_cur_section() == section_code );
	T( append_byte(0xAA) );
	T( next_PC() );

	T( new_section("") );
	assert( get_cur_section() == section_blank );
	T( append_byte(0xAA) );
	T( next_PC() );

	/* compute addresses */
	T( get_first_section(NULL)->origin = -1;  sections_alloc_addr() );
	T( get_first_section(NULL)->origin = 100; sections_alloc_addr() );

	/* write each module */
#define T_MODULE(n,size) \
	T( set_cur_module_id( n ) ); \
	assert( (file = fopen("test.bin", "wb")) != NULL ); \
	assert( size == fwrite_module_code( file ) ); \
	fclose( file ); \
	dump_file("module " #n );

	T_MODULE( 0, 24 );
	T_MODULE( 1,  8 );
	T_MODULE( 2, 11 );
	T_MODULE( 3,  3 );
#undef T_MODULE

	/* write whole code area */
	assert( (file = fopen("test.bin", "wb")) != NULL ); 
	fwrite_codearea( "test.bin", &file, &reloc ); 
	fclose( file );
	dump_file("code area ");

	/* test reordering of sections */
	T( reset_codearea() );
	
	/* compile */
	T( module_id = new_module_id() ); assert( module_id == 0 );
	T( new_section("code") ); T( new_section("data") );	T( new_section("bss") );
	T( new_section("bss") ); T( append_byte(3) ); T( next_PC() );
	assert( (file = fopen("test.bin", "wb")) != NULL ); 
	T( fwrite_module_code( file ) );
	fclose( file );
	dump_file("code area ");

	T( module_id = new_module_id() ); assert( module_id == 1 );
	T( new_section("code") ); T( new_section("data") );	T( new_section("bss") );
	T( new_section("data") ); T( append_byte(2) ); T( next_PC() );
	assert( (file = fopen("test.bin", "wb")) != NULL ); 
	T( fwrite_module_code( file ) );
	fclose( file );
	dump_file("code area ");

	T( module_id = new_module_id() ); assert( module_id == 2 );
	T( new_section("code") ); T( new_section("data") );	T( new_section("bss") );
	T( new_section("code") ); T( append_byte(1) ); T( next_PC() );
	assert( (file = fopen("test.bin", "wb")) != NULL ); 
	T( fwrite_module_code( file ) );
	fclose( file );
	dump_file("code area ");

	/* link */
	T( set_cur_module_id(0) ); T( new_section("bss") );  T( patch_byte(0, 3) );
	T( set_cur_module_id(1) ); T( new_section("data") ); T( patch_byte(0, 2) );
	T( set_cur_module_id(2) ); T( new_section("code") ); T( patch_byte(0, 1) );
	
	T( get_first_section(NULL)->origin = -1; sections_alloc_addr() );

	/* write bin file */
	assert( (file = fopen("test.bin", "wb")) != NULL ); 
	fwrite_codearea( "test.bin", &file, &reloc ); 
	fclose( file );
	dump_file("code area ");
}

int main( int argc, char *argv[] )
{
	test_sections();
	return 0;
}
