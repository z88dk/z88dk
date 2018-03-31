/*
 *	Library file snooper
 * 
 *	(C) 17/11/2002 Dominic Morris
 *
 *	Prints the contents of a z80asm library file including local symbols
 *	and dependencies of a particular library
 */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <getopt.h>
#include <assert.h>
#include <stdarg.h>
#include "die.h"

#define MAX_FP     0x7FFFFFFF
#define END(a, b)  ((a) >= 0 ? (a) : (b))

#define MIN_VERSION 1
#define MAX_VERSION 11

enum file_type { is_none, is_library, is_object };

int opt_showlocal, opt_showexpr, opt_dump_code;	/* options */
char file_signature[9];		/* set with last read signature */
int  file_version;			/* set with last file version, -1 if invalid */
char *last_name = NULL;		/* keep last name returned by xfread_name */

/*-----------------------------------------------------------------------------
*	File IO with fatal errors
*----------------------------------------------------------------------------*/


long xfread_value( FILE *fp, char *filename, size_t len )
{
	long value = 0;
	size_t i;
	int c;

	for ( i = 0; i < len; i++ )
	{
		c = fgetc( fp );
		if ( c < 0 )
			die("File %s: error reading %d bytes\n", filename, len );
		value |= (c & 0xFF) << (8 * i);
	}

	return value;
}

void free_last_name ( void ) 
{ 
	free( last_name ); 
}

/* NOTE: not reentrant */
char *xfread_name( FILE *fp, char *filename, size_t len_bytes )
{
	static size_t alloc_size = 0;
	size_t len;

	/* get length */
	len = xfread_value( fp, filename, len_bytes ) & 0xFFFF;

	/* first time */
	if ( alloc_size == 0 ) 
		atexit( free_last_name );

	/* reallocate string if needed */
	if ( alloc_size < len + 1 )
	{
		alloc_size = len + 1;
		last_name = realloc( last_name, alloc_size );
	}

	/* read bytes */
	xfread(last_name, sizeof(char), len, fp);
	last_name[len] = '\0';

	return last_name;
}

char *xfread_string( FILE *fp, char *filename )
{
	return xfread_name( fp, filename, 1 );
}

char *xfread_lstring( FILE *fp, char *filename )
{
	return xfread_name( fp, filename, 2 );
}

/*-----------------------------------------------------------------------------
*	Usage
*----------------------------------------------------------------------------*/
void usage(char *name)
{
	die("Usage %s [-h][-a][-l][-e][-c] library\n"
		"Display the contents of a z80asm library file\n"
		"\n"
		"-a\tShow all\n"
		"-l\tShow local symbols\n"
		"-e\tShow expression patches\n"
		"-c\tShow code dump\n"
		"-h\tDisplay this help\n",
		name );
}

/*-----------------------------------------------------------------------------
*	Read file signature
*----------------------------------------------------------------------------*/
enum file_type read_signature( FILE *fp, char *filename )
{
	enum file_type type = is_none;

	file_version = -1;
	memset( file_signature, 0, sizeof(file_signature) );

	/* read signature */
	xfread(file_signature, sizeof(char), 8, fp);
	if ( strncmp( file_signature, "Z80RMF", 6 ) == 0 )
		type = is_object;
	else if ( strncmp( file_signature, "Z80LMF", 6 ) == 0 )
		type = is_library;
	else
		die("File %s: not object nor library file\n", filename );
	
	/* read version */
	if ( sscanf( file_signature + 6, "%d", &file_version ) < 1 )
		die("File %s: not object nor library file\n", filename );

	if ( file_version < MIN_VERSION || file_version > MAX_VERSION )
		die("File %s: not object or library file version %d not supported\n", filename, file_version );

	printf("\nFile %s at $%04X: %s\n", filename, ftell( fp ) - 8, file_signature );

	return type;
}

/*-----------------------------------------------------------------------------
*	Dump object file
*----------------------------------------------------------------------------*/
void print_section_name( char *section_name )
{
	if ( section_name && *section_name )		/* not "" section */
		printf(" (section %s)", section_name );
}

void dump_names( FILE *fp, char *filename, long fpos_start, long fpos_end )
{
	int scope, type;
	long value, line_nr;
	char *name, *section_name, *def_filename;

	if ( file_version >= 5 )				/* signal end by zero type */
		fpos_end = MAX_FP;

	printf("  Names:\n");
	fseek( fp, fpos_start, SEEK_SET );
	while ( ftell( fp ) < fpos_end )
	{
		name = NULL;
		section_name = NULL;
		def_filename = NULL;

		scope = xfread_byte(fp);
		if ( scope == 0 )
			break;							/* end marker */

		type  = xfread_byte(fp);
		
		if ( file_version >= 5 )
			section_name = strdup( xfread_string( fp, filename ) );

		value = xfread_dword(fp);
		name = strdup(xfread_string(fp, filename));

		if (file_version >= 9) {			// add definition location
			def_filename = strdup(xfread_string(fp, filename));
			line_nr = xfread_dword(fp);
		}

		if ( opt_showlocal || scope != 'L' )
		{
			printf("    %c %c $%04X %s", scope, type, (int)value, name );
			if (file_version >= 5) {
				print_section_name(section_name);
			}
			if (file_version >= 9) {
				printf(" %s:%d", def_filename, (int)line_nr);
			}
			printf("\n");
		}

		free(name);
		free(section_name);
		free(def_filename);
	}
}

void dump_externs( FILE *fp, char *filename, long fpos_start, long fpos_end )
{
	char *name;

	printf("  External names:\n");
	fseek( fp, fpos_start, SEEK_SET );
	while ( ftell( fp ) < fpos_end )
	{
		name = xfread_string( fp, filename );
		printf("    U         %s\n", name );
	}
}

void dump_exprs( FILE *fp, char *filename, long fpos_start, long fpos_end )
{
	int type, asmpc, patch_ptr, end_marker;
	char *source_file, *last_source_file, *section_name, *target_name;
	long line_number;

	last_source_file = strdup("");

	if ( file_version >= 4 )				/* signal end by zero type */
		fpos_end = MAX_FP;

	printf("  Expressions:\n");
	fseek( fp, fpos_start, SEEK_SET );
	while ( ftell( fp ) < fpos_end )
	{
		type = xfread_byte(fp);
		if ( type == 0 )
			break;							/* end marker */

		printf("    E %c%c", 
			   type, 
			   type == '=' ? ' ' :
			   type == 'L' ? 'l' : 
			   type == 'C' ? 'w' :
			   type == 'B' ? 'W' : 'b' );
		if ( file_version >= 4 )
		{
			source_file = xfread_lstring( fp, filename );
			if ( *source_file )
			{
				free( last_source_file );
				last_source_file = strdup( source_file );
			}

			line_number = xfread_dword(fp);
			printf(" (%s:%ld)", last_source_file, line_number );
		}

		if ( file_version >= 5 )
		{
			section_name = strdup( xfread_string( fp, filename ) );
		}

		if ( file_version >= 3 )
		{
			asmpc = xfread_word(fp);
			printf(" $%04X", asmpc);
		}

		patch_ptr = xfread_word(fp);
		printf(" $%04X", patch_ptr);

		printf(": ");
		if ( file_version >= 6 )
		{
			target_name = xfread_string( fp, filename );
			if ( *target_name )
				printf("%s := ", target_name );
		}

		if ( file_version >= 4 )
			printf("%s", xfread_lstring( fp, filename ) );
		else
			printf("%s", xfread_string( fp, filename ) );

		if ( file_version >= 5 )
		{
			print_section_name( section_name );
			free( section_name );
		}

		printf("\n");

		if ( file_version < 4 )
		{
			end_marker = xfread_byte(fp);
			if ( end_marker != 0 )
				die("File %s: missing expression end marker\n", filename );
		}
	}

	free( last_source_file );
}

void dump_bytes( FILE *fp, char *filename, int size )
{
	int addr = 0, byte;

	while ( size-- > 0 )
	{
		if ( (addr % 16) == 0 )
		{
			if ( addr != 0 )
				printf("\n");
			printf("    C $%04X:", addr);
		}

		byte = xfread_byte(fp);
		printf(" %02X", byte );

		addr++;
	}

	if ( addr != 0 )
		printf("\n");
}

void dump_code( FILE *fp, char *filename, long fpos_start )
{
	int code_size;
	int org, align;
	char *section_name; 

	fseek( fp, fpos_start, SEEK_SET );

	if ( file_version >= 5 )
	{
		while (1)
		{
			code_size = xfread_dword(fp);
			if ( code_size < 0 )
				break;
			section_name = xfread_string( fp, filename );

			if ( file_version >= 8 )
				org = (int) xfread_dword(fp);
			else 
				org = -1;

			if (file_version >= 10)
				align = (int)xfread_dword(fp);
			else
				align = -1;

			printf("  Code: %d bytes", code_size );
			if (org >= 0) {
				printf(", ORG $%04X", org );
			}
			else if (org == -2) {
				printf(", section split");
			}
			else {
			}

			if (align > 1)
				printf(", ALIGN %d", align);

			print_section_name( section_name );
			printf("\n");

			dump_bytes( fp, filename, code_size );
		}
	}
	else
	{
		code_size = xfread_word(fp);
		if ( code_size == 0 )
			code_size = 0x10000;
		if ( code_size > 0 )
		{
			printf("  Code: %d bytes\n", code_size );
			dump_bytes( fp, filename, code_size );
		}
	}
}

void dump_object( FILE *fp, char *filename )
{
	long fpos0 = ftell(fp) - 8;		/* before signature */
	int org = -1;
	long fpos_modname, fpos_exprs, fpos_names, fpos_externs, fpos_code;

	if ( file_version >= 8 )
		; /* no object ORG - ORG is now per section */
	else if ( file_version >= 5 )
		org		= (int) xfread_dword(fp);
	else
		org		= xfread_word(fp);

	fpos_modname = xfread_dword(fp);
	fpos_exprs = xfread_dword(fp);
	fpos_names = xfread_dword(fp);
	fpos_externs = xfread_dword(fp);
	fpos_code = xfread_dword(fp);

	/* module name */
	fseek( fp, fpos0 + fpos_modname, SEEK_SET );
	printf("  Name: %s\n", xfread_string( fp, filename ) );
	
	/* org */
	if ( org >= 0 )
		printf("  Org:  $%04X\n", org );

	/* names */
	if ( fpos_names >= 0 ) 
		dump_names( fp, filename, 
					fpos0 + fpos_names, 
					fpos0 + END( fpos_externs, fpos_modname ) );

	/* extern */
	if ( fpos_externs >= 0 ) 
		dump_externs( fp, filename, 
					 fpos0 + fpos_externs, 
					 fpos0 + fpos_modname );

	/* expressions */
	if ( fpos_exprs >= 0 && opt_showexpr ) 
		dump_exprs( fp, filename, 
				   fpos0 + fpos_exprs, 
				   fpos0 + END( fpos_names, END( fpos_externs, fpos_modname ) ) );

	/* code */
	if ( fpos_code >= 0 && opt_dump_code ) 
		dump_code( fp, filename, fpos0 + fpos_code );
}

/*-----------------------------------------------------------------------------
*	Dump library file
*----------------------------------------------------------------------------*/
void dump_library( FILE *fp, char *filename )
{
	long lib_start = ftell(fp) - 8;		/* before signature */
	long next_ptr = lib_start + 8;
	long obj_start, obj_len;
	enum file_type type;

	do
	{
		fseek( fp, next_ptr, SEEK_SET );	/* next block */
		obj_start = next_ptr + 8;

		next_ptr = xfread_dword(fp);
		obj_len = xfread_dword(fp);

		type = read_signature( fp, filename );
		if ( type != is_object )
			die("File %s: contains non-object file\n", filename );

		if ( obj_len == 0 )
			printf("  Deleted...\n");

		dump_object( fp, filename );

	} while ( next_ptr >= 0 );
}

/*-----------------------------------------------------------------------------
*	Main
*----------------------------------------------------------------------------*/
int main(int argc, char *argv[])
{
	char	*filename;
	FILE	*fp;
	int		flags = 0;
	int 	opt;

	while ((opt = getopt(argc,argv,"hleca")) != -1 ) 
	{
		switch (opt ) 
		{
		case 'l':
			opt_showlocal = 1;
			break;
		case 'e':
			opt_showexpr = 1;
			break;
		case 'c':
			opt_dump_code = 1;
			break;
		case 'a':
			opt_showlocal = opt_showexpr = opt_dump_code = 1;
			break;
		default:
			usage(argv[0]);
		}
	}

	if ( optind == argc ) 
		usage(argv[0]);

	while ( optind < argc ) 
	{
		filename = argv[optind++];
		fp = xfopen( filename, "rb" );
		switch ( read_signature( fp, filename ) )
		{
		case is_library:
			dump_library( fp, filename );
			break;

		case is_object:
			dump_object( fp, filename );
			break;

		default:
			assert(0);
		}
		fclose( fp );
	}
	return 0;
}
