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
#include <ctype.h>
#include <stdarg.h>

#if defined(_WIN32) || defined(WIN32)
#define strcasecmp(a,b) stricmp(a,b)
#endif

static void read_list_file(char *filename);
static void usage(void);
static void outp_filter(FILE *file, char *fmt, ...);

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
            outp_filter(outp, "%s/%s\n", prefix, files[i]);
        }
    } else if ( makefile ) {
        int i;
        for ( i = 0; i < num_files; i++ ) {
            outp_filter(outp, "%s/%s.asm ", newlibpath,files[i]);
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

// <HACK>
// MinGW inserts c:/MinGW/msys/1.0 before every path, causing the makefiles that consume
// our output to fail
// This function replaces c:/MinGW/msys/1.0/home/paulo/git/z88dk-msys/libsrc/_DEVELOPMENT/
//                     by                  /home/paulo/git/z88dk-msys/libsrc/_DEVELOPMENT/
static int substr_iseq(char *s1, int n, char *s2)
{
	char *s1_temp = strdup(s1);
	s1_temp[n] = '\0';
	int ret = strcasecmp(s1_temp, s2) == 0;
	free(s1_temp);
	return ret;
}

static char *remove_mingw_prefix(char *str)
{
	if (strlen(str) > 17 &&
		isalpha(str[0]) &&
		str[1] == ':' &&
		(str[2] == '/' || str[2] == '\\') &&
		substr_iseq(str+3, 5, "MinGW") &&
		(str[8] == '/' || str[8] == '\\') &&
		substr_iseq(str+9, 4, "msys") &&
		(str[13] == '/' || str[13] == '\\') &&
		substr_iseq(str+14, 3, "1.0") &&
		(str[17] == '/' || str[17] == '\\'))
		return str+17;
	else
		return str;
}

static char *remove_double_slash(char *path)	// modifies in place
{
	char *p = path;

	while ((p = strstr(p, "//")) != NULL) {
		memmove(p, p+1, strlen(p+1)+1);			// eat second slash, copy also '\0'
	}
	return path;
}

static void outp_filter(FILE *file, char *fmt, ...)
{
    char buf[FILENAME_MAX+1];

	va_list args;
	va_start(args, fmt);
	vsprintf(buf, fmt, args);
	va_end (args);

	fprintf(file, "%s", remove_double_slash(remove_mingw_prefix(buf)));
}
// </HACK>
