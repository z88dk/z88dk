#ifndef _NET_STDIO_H
#define _NET_STDIO_H

/*
 * Some hooks for the stdio style routines
 *
 * Do not include yourself - system file!!
 *
 * $Id: stdio.h,v 1.2 2001-04-20 16:04:25 dom Exp $
 */


extern int __LIB__ fgetc_net(void *s);
extern int __LIB__ fputc_net(void *s, int c);
extern int __LIB__ closenet(void *s);
extern int __LIB__ opennet(FILE *fp, char *name,char *exp, size_t len);
extern int __LIB__ fflush_net(void *s);


#endif

