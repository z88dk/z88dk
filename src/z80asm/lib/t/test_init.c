/*
Unit test for init.h

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/t/test_init.c,v 1.1 2014-07-05 12:26:28 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "init.h"
#include <assert.h>

DEFINE_init()
{
	const char *function = __FUNCTION__;
	init();			/* mistake, caught by setting initialized before running code */
	init();			/* mistake, caught by setting initialized before running code */

	warn("%s\n", function);
}

DEFINE_fini()
{
	const char *function = __FUNCTION__;
	init();			/* mistake, caught by setting initialized before running code */
	init();			/* mistake, caught by setting initialized before running code */

	warn("%s\n", function);
}

void func1(void)
{
	const char *function = __FUNCTION__;
	init();
	init();

	warn("%s\n", function);
}
	
void func2(void)
{
	const char *function = __FUNCTION__;
	init();
	init();

	warn("%s\n", function);
}
	
int main()
{
	warn("%s started\n", __FUNCTION__);
	func1();
	func2();
	func1();
	func2();
	warn("%s finished\n", __FUNCTION__);
	return 0;
}
