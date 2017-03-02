#ifndef __NET_STDIO_H__
#define __NET_STDIO_H__

#include <sys/compiler.h>


/*
 * Some hooks for the stdio style routines
 *
 * Do not include yourself - system file!!
 *
 * $Id: stdio.h,v 1.4 2010-09-19 00:24:08 dom Exp $
 */


extern int __LIB__ fgetc_net(void *s);
extern int __LIB__ fputc_net(void *s, int c);
extern int __LIB__ closenet(void *s);
extern int __LIB__ opennet(FILE *fp, char *name);
extern int __LIB__ fflush_net(void *s);


#endif

