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
#include "z80asm_defs.h"
#include "xmalloc.h"

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
*   add only object files for the same CPU-IXIY combination
*----------------------------------------------------------------------------*/
static bool add_object_modules(FILE* lib_fp, strtable_t* st) {
    char* obj_file_data = NULL;

    for (size_t i = 0; i < option_files_size(); i++) {
        size_t fptr = ftell(lib_fp);

        // read object file blob
        const char* obj_filename = get_o_filename(option_file(i));

        int obj_size = file_size(obj_filename);
        if (obj_size < 0) {
            error_file_open(obj_filename);
            xfree(obj_file_data);
            return false;
        }

        FILE* obj_fp = fopen(obj_filename, "rb");
        if (!obj_fp) {
            error_file_open(obj_filename);
            xfree(obj_file_data);
            return false;
        }

        // check if object file is for same CPU-IXIY as defined currently
        // include if same cpu-ixiy and -m*; without -m* include always
        file_t* file = file_new();
        file_read(file, obj_filename);

        bool include = true;
        if (option_lib_for_all_cpus()) {
            if (file->objs->cpu_id == option_cpu() && file->objs->swap_ixiy == option_swap_ixiy())
                include = true;
            else
                include = false;
        }
        if (include) {
            if (option_verbose())
                printf("Adding %s to library\n", obj_filename);

            obj_file_data = xrealloc(obj_file_data, obj_size);
            xfread_bytes(obj_file_data, obj_size, obj_fp);

            // write file pointer of next file
            xfwrite_dword((int)(fptr + 2 * sizeof(int32_t) + obj_size), lib_fp);

            // write module size
            xfwrite_dword(obj_size, lib_fp);

            // write object blob
            xfwrite_bytes(obj_file_data, obj_size, lib_fp);

            // lookup defined symbols in object file
            objfile_get_defined_symbols(file->objs, st);
        }
        else {
            if (option_verbose())
                printf("Skipping %s - different CPU-IXIY combination\n", obj_filename);
        }

        fclose(obj_fp);
        file_free(file);
    }

    xfree(obj_file_data);
    return true;
}

void make_library(const char *lib_filename) {
	lib_filename = search_libfile(lib_filename);
	if ( lib_filename == NULL )
		return;					            // ERROR

    strtable_t* st = strtable_new();          // list of all defined symbols

    // #2254 - write temp file
    UT_string* temp_filename;
    utstring_new(temp_filename);
    utstring_printf(temp_filename, "%s~", lib_filename);

    if (option_verbose())
		printf("Creating library '%s'\n", path_canon(lib_filename));

	// write library header
    FILE* fp = xfopen(utstring_body(temp_filename), "wb");
	xfwrite_cstr(libfile_header(), fp);

    long st_ptr = ftell(fp);
    xfwrite_dword(-1, fp);              // placeholder for string table address

    if (option_lib_for_all_cpus()) {
        // libraries have no_swap and swap object files
        // libraries built with -IXIY-soft have only soft-swap object files
        swap_ixiy_t current_swap_ixiy = option_swap_ixiy();
        swap_ixiy_t first_ixiy, last_ixiy;
        if (current_swap_ixiy == IXIY_SOFT_SWAP) {
            first_ixiy = last_ixiy = IXIY_SOFT_SWAP;
        }
        else {
            first_ixiy = IXIY_NO_SWAP;
            last_ixiy = IXIY_SWAP;
        }

        // assemble or include object for each cpu-ixiy combination and append to library
        for (const int* cpu = cpu_ids(); *cpu > 0; cpu++) {
            set_cpu_option(*cpu);

            for (swap_ixiy_t ixiy = first_ixiy; ixiy <= last_ixiy; ixiy++) {
                set_swap_ixiy_option(ixiy);

                for (size_t i = 0; i < option_files_size(); i++) {
                    const char* filename = option_file(i);
                    bool got_asm = strcmp(filename + strlen(filename) - strlen(EXT_O), EXT_O) != 0;
                    if (got_asm)
                        assemble_file(option_file(i));

                    if (get_num_errors()) {
                        xfclose(fp);			/* error */
                        remove(utstring_body(temp_filename));
                        goto cleanup_and_return;
                    }
                }

                if (!add_object_modules(fp, st)) {
                    xfclose(fp);			/* error */
                    remove(utstring_body(temp_filename));
                    goto cleanup_and_return;
                }

                if (option_verbose())
                    printf("\n");
            }
        }
    }
    else {
        /* already assembled in main(), write each object file */
        if (!add_object_modules(fp, st)) {
            xfclose(fp);			/* error */
            remove(utstring_body(temp_filename));
            goto cleanup_and_return;
        }
    }

    // write end marker
    xfwrite_dword(-1, fp);        // next = -1 - last module
    xfwrite_dword(0, fp);         // size = 0  - deleted

    // write string table
    long st_pos = ftell(fp);
    strtable_fwrite(st, fp);
    long fpos = ftell(fp);
    fseek(fp, st_ptr, SEEK_SET);
    xfwrite_dword(st_pos, fp);
    fseek(fp, fpos, SEEK_SET);

	/* close and write lib file */
    xfclose(fp);

    // #2254 - rename temp file
    remove(lib_filename);
    int rv = rename(utstring_body(temp_filename), lib_filename);
    if (rv != 0)
        error_file_rename(utstring_body(temp_filename));

cleanup_and_return:
    strtable_free(st);
    utstring_free(temp_filename);
}

bool check_library_file(const char *src_filename)
{
	return check_obj_lib_file(
        true,
		get_lib_filename(src_filename),
        libfile_header(),
        error_file_not_found,
        error_file_open,
		error_not_lib_file,
		error_lib_file_version,
        error_cpu_incompatible,
        error_ixiy_incompatible);
}
