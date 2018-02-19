/*
 * freopen.c - open a stream
 *
 * djm 1/4/2000
 *
 * --------
 * $Id: freopen.c,v 1.3 2016-06-13 19:56:40 dom Exp $
 */

#define ANSI_STDIO

#include <fcntl.h>
#include <stdio.h>


FILE* freopen(const char* name, const char* mode, FILE* fp)
{
    return _freopen1(name, -1, mode, fp);
}

