// Handle parsing debug information from C files
// In this case it's adb information as per sdcc


#include "ticks.h"
#include <ctype.h>
#include <stdio.h>


typedef struct cfile_s cfile;

typedef struct {
    int             line;
    int             address;
    cfile          *file;
    int             level;
    int             scope_block;
    UT_hash_handle  hh;
} cline;

struct cfile_s {
    char          *file;
    cline         *lines;
    UT_hash_handle hh;
};



// F:G$main$0_0$0({2}DF,SI:S),C,0,0,0,0,0
typedef struct {
    char   *name;
    int     scope;
    int     level;
    size_t  size;
    char   *proto; // String in 
} FunctionRecord;



static cfile   *cfiles = NULL;

static cline    *clines[65536] = {0};


// Crude dehexer....
static int dehex(char c)
{
    if ( isdigit(c) ) {
        return c - '0';
    } 
    return toupper(c) - 'A' + 10;
}

/* Add debug information, in this case it's encoded */
void debug_add_info_encoded(char *encoded)
{
    char *ptr = encoded;
    char *drop = encoded;

    while ( *ptr ) {
        if (*ptr == '_') {
            int c = 0;

            c = dehex(ptr[1]) << 4;
            c += dehex(ptr[2]);
            *drop++ = c;
            ptr += 3;
        } else {
            *drop++ = *ptr++;
        }
    }
    *drop = 0;
    if ( encoded[1] != ':')
        return;
    switch ( encoded[0] ) {
    case 'F': // Function
        // F:G$main$0_0$0({2}DF,SI:S),C,0,0,0,0,0
        break;
    case 'M': // Module
        // M:world
        break;
    case 'S': // Symbol
        if ( encoded[2] == 'G') {
            // Global symbol
            // S:G$yy$0_0$0({2}SI:S),E,0,0
            //     ^^          ^^ 
        } else if ( encoded[2] == 'L') {
            // File local symbol
            // S:Lworld.main$x$1_0$3({2}SI:S),B,1,4
            //               ^          ^^        ^
        }
        break;


    }
  //  printf("Decoded cdb: <%s>\n",encoded);

}


void debug_add_cline(const char *filename, int lineno, int level, int scope_block, const char *address)
{                  
    cfile *cf;
    cline *cl;
    HASH_FIND_STR(cfiles, filename, cf);
    if ( cf == NULL ) {
        cf = calloc(1,sizeof(*cf));
        cf->file = strdup(filename);
        cf->lines = NULL;
        HASH_ADD_KEYPTR(hh, cfiles, cf->file, strlen(cf->file), cf);
    }

    cl = calloc(1,sizeof(*cl));
    cl->line = lineno;
    cl->file = cf;
    cl->address = strtol(address + 1, NULL, 16);
    cl->level = level;
    cl->scope_block = scope_block;
    HASH_ADD_INT(cf->lines, line, cl);
    clines[cl->address] = cl;  // TODO Banking
}

int debug_find_source_location(int address, const char **filename, int *lineno)
{
    while ( clines[address] == NULL && address > 0 ) {
        address--;
    }
    if ( clines[address] == NULL) return -1;
    *filename = clines[address]->file->file;
    *lineno = clines[address]->line;

    return 0;
}

int debug_resolve_source(char *name)
{
    char *ptr;

    if ( ( ptr = strrchr(name, ':') ) != NULL ) {
        char filename[FILENAME_MAX+1];
        int  line;
        cfile *cf;

        snprintf(filename, sizeof(filename),"%.*s", (int)(ptr - name), name);
        line = atoi(ptr+1);

        HASH_FIND_STR(cfiles, filename, cf);

        if ( cf != NULL ) {
            cline *cl;

            HASH_FIND_INT(cf->lines, &line, cl);

            if ( cl != NULL ) {
                return cl->address;
            }
        }
    }
    return -1;
}
