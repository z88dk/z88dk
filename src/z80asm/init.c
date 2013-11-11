#include "memalloc.h"
#include "strpool.h"
#include "errors.h"
#include "options.h"
#include "scan.h"
#include "codearea.h"
#include <stdlib.h>

extern int init_main(int argc, char *argv[]);

static void init(void)
{
	init_memalloc();
	atexit(fini_memalloc);
	init_strpool();
	atexit(fini_strpool);
	init_errors();
	atexit(fini_errors);
	init_options();
	init_scan();
	atexit(fini_scan);
	init_codearea();
	atexit(fini_codearea);
}

int main(int argc, char *argv[])
{
	init();
    return init_main(argc, argv);
}
