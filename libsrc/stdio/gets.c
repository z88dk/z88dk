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

char *gets(char *s) 
{
    if (fchkstd(stdin))
        return(fgets_cons(s,255));
    else
        return(fgets(s,255,stdin));
}
