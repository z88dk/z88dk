/*
 *      Classic stdio functions for Small C+
 *
 *      Stefano 04/10/2019
 *
 * --------
 * $Id: gets.c $
 */

#define ANSI_STDIO

#include <stdio.h>
#include <string.h>

char *gets(char *s) 
{
    char *ret;
    if (fchkstd(stdin))
        ret = fgets_cons(s,255);
    else
        ret = fgets(s,255,stdin);
    if ( ret ) {
        char *end = strchr(ret, '\n');
  
        if (end != NULL ) {
	    *end = 0;
        }
    }
    return ret;
}
