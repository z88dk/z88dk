

#include <string.h>
#include "dirname.h"

char *last_path_char(char *filename)
{
    char *p, *q;

    /* return pointer to last slash character in filename   */
    /* return NULL if no slash character found              */

    p = strrchr(filename, '/');
    q = strrchr(filename, '\\');
    if ((p == NULL) || ((q != NULL) && ((q - filename) > (p - filename))))
        p = q;

    return p;
}


char *zdirname(char *path) {
   char *ptr = last_path_char(path);
   if ( ptr != NULL ) { *ptr = 0; return path; }
   return ".";
}

char *zbasename(char *path) {
   char *ptr = last_path_char(path);
   if ( ptr != NULL ) { return ptr + 1; }
   return path;
}
