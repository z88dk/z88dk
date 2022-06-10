// Routines for displaying source files

#include "ticks.h"
#include "backend.h"
#include <stdio.h>

typedef struct srcfile_s srcfile;


struct srcfile_s {
    char *filename;
    int         num_lines;
    char      **lines;
    srcfile *next;
};

static srcfile *files = NULL;


static srcfile *open_file(const char *filename)
{
    srcfile *srch = files;
    char     buf[4096];
    FILE    *fp;

    while ( srch != NULL ) {
        if ( strcmp(srch->filename, filename) == 0 ) {
            return srch;
        }
        srch = srch->next;
    }

    if ( ( fp = fopen(filename,"r") ) == NULL ) {
        return NULL;
    }

    srch = calloc(1,sizeof(*srch));
    srch->filename = strdup(filename);

    while ( fgets(buf, sizeof(buf),fp) != NULL ) {
        char *ptr;

        srch->num_lines++;
        srch->lines = realloc(srch->lines, srch->num_lines * sizeof(srch->lines[0]));

        if ( ( ptr = strchr(buf, '\n')) != NULL ) *ptr = 0;
        if ( ( ptr = strchr(buf, '\r')) != NULL ) *ptr = 0;
      
        srch->lines[srch->num_lines-1] = strdup(buf);
    }
    LL_APPEND(files, srch);

    return srch;
}


void srcfile_display(const char *filename, int start_line, int count, int highlight)
{
    srcfile *file;
    int      end_line;
    int      i;

    file = open_file(filename);

    if ( file == NULL ) return;
    if ( start_line < 1 ) start_line = 1;
    if ( start_line > file->num_lines) return;
    end_line = start_line + count;
    if ( end_line > file->num_lines) end_line = file->num_lines;


    for ( i = start_line; i <= end_line; i++ ) {
        if ( count > 1 ) {
            bk.console("%s% 5d: %s\n", i == highlight ? ">" : " ", i, file->lines[i-1]);
        } else {
            bk.console("        %s\n", file->lines[i-1]);
        }
    }
}