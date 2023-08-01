//-----------------------------------------------------------------------------
// z80asm restart
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
// Repository: https://github.com/z88dk/z88dk
//-----------------------------------------------------------------------------

#include "fileutil.h"
#include "if.h"
#include "libfile.h"
#include "modlink.h"
#include "utlist.h"
#include "zobjfile.h"
#include "z80asm.h"
#include "z80asm_cpu.h"

char Z80libhdr[] = "Z80LMF" OBJ_VERSION;

/*-----------------------------------------------------------------------------
*	define a library file name from the command line
*----------------------------------------------------------------------------*/
static const char *search_libfile(const char *filename )
{
	if ( filename != NULL && *filename != '\0' )	/* not empty */
		return get_lib_filename( filename );		/* add '.lib' extension */
	else
	{
		error_not_lib_file(filename);
        return NULL;
	}
}

/*-----------------------------------------------------------------------------
*	make library from source files; convert each source to object file name 
*----------------------------------------------------------------------------*/
static bool add_object_modules(FILE* lib_file) {
    ByteArray* obj_file_data;
    const char* obj_filename;
    size_t	 fptr, obj_size;

    for (size_t i = 0; i < option_files_size(); i++)
    {
        fptr = ftell(lib_file);

        /* read object file */
        obj_filename = get_o_filename(option_file(i));
        obj_file_data = read_obj_file_data(obj_filename);
        if (obj_file_data == NULL)
            return false;

        /* write file pointer of next file, or -1 if last */
        obj_size = ByteArray_size(obj_file_data);
        xfwrite_dword(fptr + 4 + 4 + obj_size, lib_file);

        /* write module size */
        xfwrite_dword(obj_size, lib_file);

        /* write module */
        xfwrite_bytes((char*)ByteArray_item(obj_file_data, 0), obj_size, lib_file);
    }
    return true;
}

void make_library(const char *lib_filename)
{
	FILE	*lib_file;

	lib_filename = search_libfile(lib_filename);
	if ( lib_filename == NULL )
		return;					/* ERROR */

	if (option_verbose())
		printf("Creating library '%s'\n", path_canon(lib_filename));

	/* write library header */
	lib_file = xfopen( lib_filename, "wb" );	
	xfwrite_cstr(Z80libhdr, lib_file);

    if (option_lib_for_all_cpus()) {
        /* assemble for each cpu-ixiy combination and append to library */
        for (const int* cpu = cpu_ids(); *cpu > 0; cpu++) {
            set_cpu_option(*cpu);
            for (int ixiy = 0; ixiy < 2; ixiy++) {
                set_swap_ixiy_option(ixiy == 1);

                for (size_t i = 0; i < option_files_size(); i++)
                    assemble_file(option_file(i));

                if (get_num_errors()) {
                    xfclose(lib_file);			/* error */
                    remove(lib_filename);
                    return;
                }

                if (!add_object_modules(lib_file)) {
                    xfclose(lib_file);			/* error */
                    remove(lib_filename);
                    return;
                }
            }
        }
    }
    else {
        /* already assembled in main(), write each object file */
        if (!add_object_modules(lib_file)) {
            xfclose(lib_file);			/* error */
            remove(lib_filename);
            return;
        }
    }

    // write end marker
    xfwrite_dword(-1, lib_file);        // next = -1 - last module
    xfwrite_dword(0, lib_file);         // size = 0  - deleted

	/* close and write lib file */
	xfclose( lib_file );
}

bool check_library_file(const char *src_filename)
{
	return check_obj_lib_file(
        true,
		get_lib_filename(src_filename),
		Z80libhdr,
        error_file_not_found,
        error_file_open,
		error_not_lib_file,
		error_lib_file_version,
        error_cpu_incompatible,
        error_ixiy_incompatible);
}
