/*
 *      sccz80 — preprocessor subprocess wrapper.
 *
 *      Same contract as 80cc: popen z88dk-ucpp unless --c1mode.
 *      popen goes through the shell. _popen on Windows is cmd.exe;
 *      a path that itself contains a quote is not quoted for cmd.
 */

#include "ccdefs.h"

#ifdef _WIN32
/* _popen and _pclose are in stdio.h. <io.h> declares eof() on MinGW,
   and sccz80 already has extern int eof. */
#define POPEN  _popen
#define PCLOSE _pclose
#else
#include <sys/wait.h>
#include <unistd.h>
#define POPEN  popen
#define PCLOSE pclose
#endif

/* Args forwarded to the preprocessor, one token each (`-Ipath`,
   `-Dname=val`, `-Uname`), in command-line order. */
static char **cpp_args;
static int    cpp_argc;
static int    cpp_argcap;

void cpp_add_arg(const char *arg)
{
    if (cpp_argc + 1 >= cpp_argcap) {
        cpp_argcap = cpp_argcap ? cpp_argcap * 2 : 16;
        cpp_args = realloc(cpp_args, cpp_argcap * sizeof(char *));
    }
    cpp_args[cpp_argc++] = strdup(arg);
}

/* Wrap s for the shell. Double quotes keep spaces. Inside them,
   ", \, $ and ` are escaped for /bin/sh. */
static void shell_quote(const char *s, UT_string *out)
{
    utstring_printf(out, "\"");
    for (const char *p = s; *p; ++p) {
        if (*p == '"' || *p == '\\' || *p == '$' || *p == '`')
            utstring_printf(out, "\\%c", *p);
        else
            utstring_printf(out, "%c", *p);
    }
    utstring_printf(out, "\"");
}

/* Read preprocessed source from the preprocessor. NULL on failure
   to spawn. Caller reaps with cpp_close(), not fclose. */
FILE *cpp_open(const char *cpp_exe, const char *input_file)
{
    UT_string *cmd;
    utstring_new(cmd);
    utstring_printf(cmd, "%s", cpp_exe);

    for (int i = 0; i < cpp_argc; i++) {
        utstring_printf(cmd, " ");
        shell_quote(cpp_args[i], cmd);
    }
    utstring_printf(cmd, " ");
    shell_quote(input_file, cmd);

    if (c_verbose)
        fprintf(stderr, "sccz80: %s\n", utstring_body(cmd));

    FILE *p = POPEN(utstring_body(cmd), "r");
    if (p == NULL)
        fprintf(stderr, "sccz80: failed to spawn preprocessor: %s\n",
                utstring_body(cmd));
    utstring_free(cmd);
    return p;
}

/* Reap the subprocess. 0 is success. ucpp's own diagnostics have
   already been written to the terminal. */
int cpp_close(FILE *fp)
{
    int status = PCLOSE(fp);
#ifndef _WIN32
#ifndef __MINT__
    if (status == -1)
        return -1;
    if (WIFEXITED(status))
        return WEXITSTATUS(status);
    if (WIFSIGNALED(status))
        return 128 + WTERMSIG(status);
#endif
#endif
    return status;
}
