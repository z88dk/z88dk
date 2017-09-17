/* Tool for manipulating list files.
 *
 * Used by classic to convert newlib lst files to a usable format
 *
 * Classic compiles to obj/${TYPE}/{path} where {path} matches is stripped of _DEVELOPMENT
 */


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>


static void read_list_file(char *filename);
static void usage(void);

static char *newlibpath = NULL;


static int    num_files = 0;
static char **files = NULL;

static char  *prefix = "obj/${TYPE}";

/* 
 * -i input
 * -o output
 * -p path to newlib route
 * -c convert newlib to classic
 * -t convert to makefile targets
 */
int main(int argc, char **argv)
{
    char *input = NULL;
    char *output = NULL;
    int   convert = 0;
    int   makefile = 0;
    int   opt;
    FILE *inp;
    FILE *outp = stdout;

    while ((opt = getopt(argc, argv,"ctx:p:i:o:")) != -1 ) {
        switch ( opt ) {
            case 'c':
                convert = 1;
                break;
            case 't':
                makefile = 1;
                break;
            case 'i':
                input = optarg;
                break;
            case 'p':
                newlibpath = optarg;
                break;
            case 'x':
                prefix = optarg;
                break;
            case 'o':
                output = optarg;
                break;
            default:
                usage();
                break;
        }
    }

    if ( input == NULL || newlibpath == NULL ) {
        usage();
    }

    if ( output && ( outp = fopen(output,"w") ) == NULL ) {
        fprintf(stderr,"Cannot open outputfile <%s>\n",output);
        exit(1);
    }


    read_list_file(input);

    if ( convert ) {
        int i;
        // Convert to correct path
        for ( i = 0; i < num_files; i++ ) {
            fprintf(outp, "%s/%s\n", prefix, files[i]);
        }
    } else if ( makefile ) {
        int i;
        for ( i = 0; i < num_files; i++ ) {
            fprintf(outp, "%s/%s.asm ", newlibpath,files[i]);
        }
    }
    if ( outp != stdout ) {
        fclose(stdout);
    }
}

static void usage(void)
{
    exit(1);
}

static void read_list_file(char *filename)
{
    char      filen[FILENAME_MAX+1];
    char      buf[FILENAME_MAX+1];
    FILE     *fp;

    snprintf(filen, sizeof(filen),"%s%s", strncmp(filename, newlibpath, strlen(newlibpath)) == 0 ? "" : newlibpath, filename);

    if ( (fp = fopen(filen,"r")) == NULL ) {
        fprintf(stderr, "Cannot open file <%s>\n",filen);
        return;
    }

    while ( fgets(buf, sizeof(buf),fp) != NULL ) {
        if ( buf[0] == '@' ) {
            char  *p;
            if (((p = strtok(buf + 1, " \r\n\t")) == NULL) || !(*p) )
                continue;
            read_list_file(p);
        } else {
            int  i = num_files++;
            char  *p;
            if (((p = strtok(buf, " \r\n\t")) == NULL) || !(*p) )
                continue;
            files = realloc(files, num_files * sizeof(files[0]));
            files[i] = strdup(p);
        }
    }
}