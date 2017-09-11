#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>
#include <stdint.h>
#include <sys/stat.h>
#include <ctype.h>

#ifdef WIN32
#ifndef __MINGW__
#include "dirent.h"
#else
#include <dirent.h>
#endif
#ifndef strcasecmp
#define strcasecmp(a,b) stricmp(a,b)
#endif
#else
#include <dirent.h>
#endif

#define PATHSIZE 1024

// Version Information

#include "../config.h"

char *version = "v" Z88DK_VERSION;

// Prototypes

char *generate_path(int n, ...);
void exit_log(int code, char *fmt, ...);
void *must_malloc(size_t sz);
void *must_strdup(char *s);
char *get_basename(char *s);
void remove_extension(char *s);
char get_response(char *s);
int copy(char *dst, char *src);
int uninstall(char *name, char *s);
int install(char *name, char *dst, char *src);
void listlibs(char *name, char *src);

// ZCCCFG

char *ZCCCFG = "ZCCCFG";

// Paths to classic install directories
// Relative to ZCCCFG

enum
{
    CLASSIC_LIB = 0,
    CLASSIC_LIB_END,
    CLASSIC_HDR,
    CLASSIC_HDR_END,
    CLASSIC_SIZE
};

char *classic_paths[CLASSIC_SIZE] = {
    "/../clibs/lib/",           // CLASSIC_LIB
    0,
    "/../../include/lib/",      // CLASSIC_HDR
    0
};

// Paths to newlib install directories
// Relative to ZCCCFG

enum
{
    NEWLIB_LIB_SCCZ80 = 0,
    NEWLIB_LIB_SDCC_IX,
    NEWLIB_LIB_SDCC_IY,
    NEWLIB_LIB_END,
    NEWLIB_HDR_SCCZ80,
    NEWLIB_HDR_SDCC,
    NEWLIB_HDR_CLANG,
    NEWLIB_HDR_END,
    NEWLIB_HDR_PROTO,
    NEWLIB_HDR_MAKE,
    NEWLIB_SIZE
};

char *newlib_paths[NEWLIB_SIZE] = {
    "/../../libsrc/_DEVELOPMENT/lib/sccz80/lib/",     // NEWLIB_LIB_SCCZ80
    "/../../libsrc/_DEVELOPMENT/lib/sdcc_ix/lib/",    // NEWLIB_LIB_SDCC_IX
    "/../../libsrc/_DEVELOPMENT/lib/sdcc_iy/lib/",    // NEWLIB_LIB_SDCC_IY
    0,
    "/../../include/_DEVELOPMENT/sccz80/lib/",        // NEWLIB_HDR_SCCZ80
    "/../../include/_DEVELOPMENT/sdcc/lib/",          // NEWLIB_HDR_SDCC
    "/../../include/_DEVELOPMENT/clang/lib/",         // NEWLIB_HDR_CLANG
    0,
    "/../../include/_DEVELOPMENT/proto/lib/",         // NEWLIB_HDR_PROTO
    "/../../include/_DEVELOPMENT"                     // NEWLIB_HDR_MAKE
};

//

char *generate_path(int n, ...)
{
    char tmp[PATHSIZE];
    int  tmplen;

    va_list arg;
    va_start(arg, n);

    for (*tmp = 0; n; --n)
    {
        tmplen = strlen(tmp);
        snprintf(tmp + tmplen, sizeof(tmp) / sizeof(*tmp) - tmplen - 1, "%s", (char *)va_arg(arg, char*));
    }

    va_end(arg);

    return must_strdup(tmp);
}

// Exit done the easy way

static char *program_name = NULL;

void exit_log(int code, char *fmt, ...)
{
    va_list  ap;
    va_start(ap, fmt);

    if (fmt != NULL)
    {
        if (program_name) fprintf(stderr, "%s: ", program_name);
        vfprintf(stderr, fmt, ap);
    }

    va_end(ap);
    exit(code);
}

// Memory allocation

void *must_malloc(size_t sz)
{
    void *ret;

    if ((ret = malloc(sz)) == NULL)
        exit_log(1, "Out of Memory\n");

    return ret;
}

void *must_strdup(char *s)
{
    void *ret;

    if ((ret = strdup(s)) == NULL)
        exit_log(1, "Out of Memory\n");

    return ret;
}

// Options

char *target = NULL;        // "+zx", etc
int   delete = 0;           // "-r" "--remove" = remove library
int   force = 0;            // "-f" = delete, overwrite without confirmation
char  libnames[PATHSIZE];   // space separate list of library names

char  name[PATHSIZE];
char  basename[PATHSIZE];
char  src[PATHSIZE];
char  dst[PATHSIZE];

// Filenames

char *get_basename(char *s)
{
    char *tmp;

    tmp = s + strlen(s);

    while (tmp-- != s)
        if ((*tmp == '/') || (*tmp == '\\'))
            return tmp + 1;

    return s;
}

void remove_extension(char *s)
{
    char *tmp;

    tmp = s + strlen(s);

    while (tmp-- != s)
    {
        if (*tmp == '.')
        {
            *tmp = 0;
            break;
        }
        else if ((*tmp == '/') || (*tmp == '\\'))
            break;
    }
}

// Interactive

char get_response(char *s)
{
    char r;
    int i;

    do
    {
        i = scanf(" %c%*[^\n]", &r);
    } while ((i == 0) || (strchr(s, r) == NULL));

    return r;
}

//

int copy(char *dst, char *src)
{
    FILE *in, *out;
    int c;

    if ((in = fopen(src, "rb")) == NULL)
        return 1;

    if ((out = fopen(dst, "wb")) == NULL)
    {
        fclose(in);
        return 1;
    }

    while ((c = fgetc(in)) != EOF)
        fputc(c, out);

    fclose(in);
    fclose(out);

    return 0;
}

int uninstall(char *name, char *s)
{
    struct stat st;
    char yes;

    if ((stat(s, &st) == 0) && (S_IFREG == (st.st_mode & S_IFMT)))
    {
        yes = 'Y';

        if (!force)
        {
            printf(delete ? "....remove? (y/n) " : "..overwrite? (y/n) ");
            fflush(stdout);
            yes = toupper(get_response("YyNn"));
        }

        if (yes == 'Y')
        {
            if (remove(s) == 0)
                printf("....removed %s\n", name);
            else
            {
                printf("....failed to remove %s\n", name);
                return 1;
            }
        }
        else
            return 1;
    }

    return 0;
}

int install(char *name, char *dst, char *src)
{
    struct stat st;

    if ((stat(src, &st) == 0) && (S_IFREG == (st.st_mode & S_IFMT)))
        printf("..%s found\n", name);
    else
        return 1;

    if (uninstall(name, dst))
        return 1;

    if (copy(dst, src))
    {
        printf("....failed to install %s\n", name);
        return 1;
    }

    printf("....installed %s\n", name);
    return 0;
}

void listlibs(char *name, char *src)
{
    DIR *in;
    struct dirent *entry;
    struct stat st;
    char fname[PATHSIZE];

    src[strlen(src) - 1] = 0;   // get rid of trailing '/'

    if ((in = opendir(src)) == NULL)
        return;

    while ((entry = readdir(in)) != NULL)
    {
        snprintf(fname, sizeof(fname), "%s/%s", src, entry->d_name);

        if ((strcasecmp(entry->d_name, "README") != 0) && (stat(fname, &st) == 0) && (S_IFREG == (st.st_mode & S_IFMT)))
            printf("..%s \"%s\" %u bytes\n", name, entry->d_name, (unsigned int)st.st_size);
    }

    closedir(in);
}

int main(int argc, char **argv)
{
    void *tmp;
    int i, numlibs;

    program_name = argv[0];

    // Message

    printf("\nZ88DK-LIB %s\nThird Party Library Installer\n\n", version);

    // Fetch ZCCCFG

    if ((ZCCCFG = getenv(ZCCCFG)) == NULL)
        exit_log(1, "ZCCCFG is not defined, can't locate Z88DK install\n");

    ZCCCFG = must_strdup(ZCCCFG);

    // Parse command line

    libnames[0] = 0;
    numlibs = 0;

    for (i = 1; i < argc; ++i)
    {
        if (argv[i][0] == '+')
        {
            if (target != NULL)
                exit_log(1, "Can only install libraries for one target at a time\n");

            target = must_strdup(argv[i] + 1);

            if (*target == 0)
                exit_log(1, "Nonsensical target %s\n", argv[i]);
        }
        else if (strcasecmp(argv[i], "-f") == 0)
            force = 1;
        else if ((strcasecmp(argv[i], "-r") == 0) || (strcasecmp(argv[i], "--remove") == 0))
            delete = 1;
        else if (argv[i][0] == '-')
            exit_log(1, "Unrecognized option %s\n", argv[i]);
        else
        {
            int len = strlen(libnames);
            snprintf(libnames + len, sizeof(libnames) / sizeof(*libnames) - len, "%s ", argv[i]);
            ++numlibs;
        }
    }

    // Output help text on error

    if ((argc == 1) || (target == NULL))
    {
        printf("Usage:\n\n"
            "  %s +target [flags] libname1 libname2 ...\n"
            "  +target      : select target\n"
            "  -f           : overwrite or delete files without confirmation\n"
            "  -r, --remove : remove listed libraries from z88dk instead of adding\n\n"
            "  %s +target\n"
            "  list installed libraries for target\n\n", program_name, program_name);
        exit(0);
    }

    printf("Target: %s\n", target);

    // Generate paths

    for (i = 0; i < CLASSIC_SIZE; ++i)
        if (classic_paths[i])
            classic_paths[i] = generate_path(4, ZCCCFG, classic_paths[i], target, "/");

    for (i = 0; i < NEWLIB_HDR_MAKE; ++i)
        if (newlib_paths[i])
            newlib_paths[i] = generate_path(4, ZCCCFG, newlib_paths[i], target, "/");

    // Shell command to make newlib headers

#ifdef WIN32
    newlib_paths[NEWLIB_HDR_MAKE] = generate_path(4, "cd ", ZCCCFG, newlib_paths[NEWLIB_HDR_MAKE], " && Winmake 1> nul");
#else
    newlib_paths[NEWLIB_HDR_MAKE] = generate_path(4, "cd ", ZCCCFG, newlib_paths[NEWLIB_HDR_MAKE], " && make > /dev/null");
#endif

    //

    if (numlibs == 0)
    {
        // list installed libraries

        printf("\nInstalled Libraries:\n\n");

        // classic header

        snprintf(src, sizeof(src), "%s", classic_paths[CLASSIC_HDR]);
        listlibs("classic hdr", src);

        // classic library

        snprintf(src, sizeof(src), "%s", classic_paths[CLASSIC_LIB]);
        listlibs("classic lib", src);

        // newlib header

        snprintf(src, sizeof(src), "%s", newlib_paths[NEWLIB_HDR_SCCZ80]);
        listlibs("newlib hdr sccz80", src);

        snprintf(src, sizeof(src), "%s", newlib_paths[NEWLIB_HDR_SDCC]);
        listlibs("newlib hdr sdcc", src);

        snprintf(src, sizeof(src), "%s", newlib_paths[NEWLIB_HDR_CLANG]);
        listlibs("newlib hdr clang", src);

        // newlib library

        snprintf(src, sizeof(src), "%s", newlib_paths[NEWLIB_LIB_SCCZ80]);
        listlibs("newlib lib sccz80", src);

        snprintf(src, sizeof(src), "%s", newlib_paths[NEWLIB_LIB_SDCC_IX]);
        listlibs("newlib lib sdcc_ix", src);

        snprintf(src, sizeof(src), "%s", newlib_paths[NEWLIB_LIB_SDCC_IY]);
        listlibs("newlib lib sdcc_iy", src);
    }
    else
    {
        // install or remove libraries

        int generate_newlib = 0;

        for (tmp = strtok(libnames, " "); tmp != NULL; tmp = strtok(NULL, " "))
        {
            strcpy(name, tmp);
            remove_extension(name);
            strcpy(basename, get_basename(name));

            if (*basename == 0)
                printf("\nInvalid library name: %s\n", name);
            else
            {
                int change_made = 0;
                int newlib = 0;

                printf("\nLibrary name: %s\n", basename);

                // classic header

                snprintf(src, sizeof(src), "%s/%s/include/classic/%s%s", name, target, basename, ".h");
                snprintf(dst, sizeof(dst), "%s%s%s", classic_paths[CLASSIC_HDR], basename, ".h");

                if (delete)
                    change_made += !uninstall("classic hdr", dst);
                else
                    change_made += !install("classic hdr", dst, src);

                // classic library

                snprintf(src, sizeof(src), "%s/%s/lib/classic/%s%s", name, target, basename, ".lib");
                snprintf(dst, sizeof(dst), "%s%s%s", classic_paths[CLASSIC_LIB], basename, ".lib");

                if (delete)
                    change_made += !uninstall("classic lib", dst);
                else
                    change_made += !install("classic lib", dst, src);

                // newlib headers

                snprintf(src, sizeof(src), "%s/%s/include/newlib/%s%s", name, target, basename, ".h");
                snprintf(dst, sizeof(dst), "%s%s%s", newlib_paths[NEWLIB_HDR_PROTO], basename, ".h");

                if (delete)
                    change_made += !uninstall("newlib hdr prototype", dst);
                else
                    newlib += !install("newlib hdr prototype", dst, src);

                if (delete || newlib)
                {
                    snprintf(dst, sizeof(dst), "%s%s%s", newlib_paths[NEWLIB_HDR_SCCZ80], basename, ".h");
                    uninstall("newlib hdr sccz80", dst);

                    snprintf(dst, sizeof(dst), "%s%s%s", newlib_paths[NEWLIB_HDR_SDCC], basename, ".h");
                    uninstall("newlib hdr sdcc", dst);

                    snprintf(dst, sizeof(dst), "%s%s%s", newlib_paths[NEWLIB_HDR_CLANG], basename, ".h");
                    uninstall("newlib hdr clang", dst);
                }

                generate_newlib += newlib;

                // newlib libraries

                snprintf(src, sizeof(src), "%s/%s/lib/newlib/sccz80/%s%s", name, target, basename, ".lib");
                snprintf(dst, sizeof(dst), "%s%s%s", newlib_paths[NEWLIB_LIB_SCCZ80], basename, ".lib");

                if (delete)
                    change_made += !uninstall("newlib lib sccz80", dst);
                else
                    change_made += !install("newlib lib sccz80", dst, src);

                snprintf(src, sizeof(src), "%s/%s/lib/newlib/sdcc_ix/%s%s", name, target, basename, ".lib");
                snprintf(dst, sizeof(dst), "%s%s%s", newlib_paths[NEWLIB_LIB_SDCC_IX], basename, ".lib");

                if (delete)
                    change_made += !uninstall("newlib lib sdcc_ix", dst);
                else
                    change_made += !install("newlib lib sdcc_ix", dst, src);

                snprintf(src, sizeof(src), "%s/%s/lib/newlib/sdcc_iy/%s%s", name, target, basename, ".lib");
                snprintf(dst, sizeof(dst), "%s%s%s", newlib_paths[NEWLIB_LIB_SDCC_IY], basename, ".lib");

                if (delete)
                    change_made += !uninstall("newlib lib sdcc_iy", dst);
                else
                    change_made += !install("newlib lib sdcc_iy", dst, src);

                if (!change_made && !newlib)
                    printf("..not found\n");
            }
        }

        if (generate_newlib)
        {
            printf("\nGenerating newlib headers..(wait)..");
            fflush(stdout);

            system(newlib_paths[NEWLIB_HDR_MAKE]);

            printf("(done)\n\n");
        }
    }

    return 0;
}
