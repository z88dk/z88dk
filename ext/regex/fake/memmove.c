#include <stdio.h>
#include <string.h>
#include <sys/types.h>

/*
 - memmove - fake ANSI C routine
 */
char *
memmove(dst, src, count)
char *dst;
char *src;
size_t count;
{
	register char *s;
	register char *d;
	register size_t n;

	if (dst > src)
		for (d = dst+count, s = src+count, n = count; n > 0; n--)
			*--d = *--s;
	else
		for (d = dst, s = src, n = count; n > 0; n--)
			*d++ = *s++;

	return(dst);
}
