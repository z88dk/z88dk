/*
 *      80cc — preprocessor subprocess wrapper.
 *
 */

#include "ccdefs.h"

#ifdef _WIN32
#include <io.h>
#define POPEN  _popen
#define PCLOSE _pclose
#else
#include <unistd.h>
#define POPEN  popen
#define PCLOSE pclose
#endif


/* Args to forward to the preprocessor. Each entry is a single
   token like `-Ipath`, `-Dname=val`, `-Uname`. We keep them
   pre-shell-quoted in the order seen on the command line. */
static char  **cpp_args;
static int     cpp_argc;
static int     cpp_argcap;

void cpp_add_arg(const char *arg)
{
    if (cpp_argc + 1 >= cpp_argcap) {
        cpp_argcap = cpp_argcap ? cpp_argcap * 2 : 16;
        cpp_args = realloc(cpp_args, cpp_argcap * sizeof(char *));
    }
    cpp_args[cpp_argc++] = strdup(arg);
}


/* Shell-quote `s` into a buffer. We only need to handle paths and
   macro values, which may contain spaces, `=`, parens, etc. Single-
   quote wrap is sufficient on POSIX; for embedded single quotes,
   escape as `'\''`. On Windows _popen uses cmd.exe — quoting is
   different (`"...\""`) but for 80cc's typical usage (paths
   without special chars) this is good enough as a first pass. */
static void shell_quote(const char *s, UT_string *out)
{
    utstring_printf(out, "'");
    for (const char *p = s; *p; ++p) {
        if (*p == '\'') utstring_printf(out, "'\\''");
        else            utstring_printf(out, "%c", *p);
    }
    utstring_printf(out, "'");
}


/* Open the preprocessor subprocess and return a FILE* to read the
   preprocessed source from. Returns NULL and prints to stderr on
   failure. Caller must call cpp_close() (not fclose) to reap. */
FILE *cpp_open(const char *cpp_exe, const char *input_file)
{
    UT_string *cmd;
    utstring_new(cmd);
    utstring_printf (cmd, "%s", cpp_exe);

    for (int i = 0; i < cpp_argc; i++) {
        utstring_printf(cmd, " ");
        shell_quote(cpp_args[i], cmd);
    }
    utstring_printf(cmd, " ");
    shell_quote(input_file, cmd);

    if (c_verbose)
        fprintf(stderr, "80cc: %s\n", utstring_body(cmd));

    FILE *p = POPEN(utstring_body(cmd), "r");
    if (p == NULL)
        fprintf(stderr, "80cc: failed to spawn preprocessor: %s\n",
                utstring_body(cmd));
    utstring_free(cmd);
    return p;
}


/* Reap the subprocess. Returns its exit status (0 = success).
   On non-zero, the caller should bail out — ucpp's stderr has
   already gone to the user's terminal. */
int cpp_close(FILE *fp)
{
    int status = PCLOSE(fp);
    /* On POSIX pclose returns the wait(2)-style status; normalise. */
#ifndef _WIN32
    if (status == -1)        return -1;
    if (WIFEXITED(status))   return WEXITSTATUS(status);
    if (WIFSIGNALED(status)) return 128 + WTERMSIG(status);
#endif
    return status;
}
