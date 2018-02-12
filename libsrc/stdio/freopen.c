/*
 * freopen.c - open a stream
 *
 * djm 1/4/2000
 *
 * --------
 * $Id: freopen.c,v 1.3 2016-06-13 19:56:40 dom Exp $
 */

#define ANSI_STDIO

#include        <stdio.h>
#include        <fcntl.h>

FILE *freopen(const char *name, const char *mode, FILE *fp)
{
    int    access;
    int    flags;
    int fd;
    FILE *fp2;
    switch (*(unsigned char *)mode++) {
        case 'r':
            access=O_RDONLY;
            flags=_IOREAD | _IOUSE| _IOTEXT;
            break;
        case 'w':
            access=O_WRONLY|O_TRUNC;
            flags = _IOWRITE | _IOUSE | _IOTEXT;
            break;
        case 'a':
            access=O_APPEND|O_WRONLY;
            flags = _IOWRITE | _IOUSE | _IOTEXT;
            break;
        default:
            return NULL;
    }

    if ( *(unsigned char *)mode++ == '+' ) {
        if (access == O_RDONLY ) {
            access=O_RDWR;
        } else if ( access & O_WRONLY ) {
            access=O_RDWR|O_TRUNC;
        }
    }
#ifdef __STDIO_BINARY
    if (*(unsigned char *)mode == 'b') {
        flags ^= _IOTEXT;
    }
#endif

    {

        // Others, pass int mode
        fd=open(name,access,flags);

        fp2=fp;
        if (fd == - 1 ) return (FILE *)NULL;
            fp2->desc.fd=fd;
            fp2->ungetc=0; 
            fp2->flags=flags;
        return fp2;
    }
}
