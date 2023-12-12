//-----------------------------------------------------------------------------
// show a stack dump on SIGSEGV in Linux
// need to compile with -ggdb and link with -rdynamic
// Copyright (C) Paulo Custodio, 2011-2023
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "stack_trace.h"
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#ifdef __linux__
#ifdef __GLIBC__
#define DO_STACKTRACE 
#include <execinfo.h>
#include <signal.h>
#include <unistd.h>
#endif
#endif

#define MAX_STACK_DEPTH 100

void dump_stack(void) {
#ifdef DO_STACKTRACE
    void *buffer[MAX_STACK_DEPTH] = {0};
	int nptrs = backtrace(buffer, MAX_STACK_DEPTH);
	fprintf(stderr, "backtrace() returned %d addresses:\n", nptrs);
   	backtrace_symbols_fd(buffer, nptrs, STDERR_FILENO);
#endif
}

#ifdef DO_STACKTRACE
static void signal_handler(int sig, siginfo_t *si, void *ignore) {
    fprintf(stderr, "Got SIGSEGV=%d at address: 0x%lx\n", sig, (long)si->si_addr);
    dump_stack();
    exit(EXIT_FAILURE);
}
#endif

void dump_stack_on_sigsegv(void) {
#ifdef DO_STACKTRACE
    static bool inited = false;
    if (!inited) {          // setup signal handler
        struct sigaction sa;
        sa.sa_flags = SA_SIGINFO;
        sigemptyset(&sa.sa_mask);
        sa.sa_sigaction = signal_handler;
        if (sigaction(SIGSEGV, &sa, NULL) == -1) {
            perror("sigaction");
            exit(EXIT_FAILURE);
        }
    }
    inited = true;
#endif
}
