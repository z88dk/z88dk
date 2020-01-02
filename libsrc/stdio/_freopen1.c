/*
 * freopen.c - open a stream
 *
 * djm 1/4/2000
 *
 * --------
 * $Id: freopen.c $
 */

#define ANSI_STDIO

#include <fcntl.h>
#include <stdio.h>

FILE *_freopen1(const char* name, int fd, const char* mode, FILE* fp)
{
    int access;
    int flags;
    switch (*(unsigned char*)mode++) {
    case 'r':
        access = O_RDONLY;
        flags = _IOREAD | _IOUSE | _IOTEXT;
        break;
    case 'w':
        access = O_WRONLY | O_TRUNC | O_CREAT;
        flags = _IOWRITE | _IOUSE | _IOTEXT;
        break;
    case 'a':
        access = O_APPEND | O_WRONLY | O_CREAT;
        flags = _IOWRITE | _IOUSE | _IOTEXT;
        break;
    default:
        return NULL;
    }

    if (*(unsigned char*)mode == '+') {
        mode++;
        if (access == O_RDONLY) {
            access = O_RDWR;
			flags = _IOREAD | _IOWRITE | _IOUSE | _IOTEXT;
        } else if (access & O_TRUNC) {  // 'w'
            access = O_RDWR | O_TRUNC | O_CREAT;
			flags = _IOREAD | _IOWRITE | _IOUSE | _IOTEXT;
        } else {
            access = O_RDWR | O_CREAT;
        }
    }
#ifdef __STDIO_BINARY
    if (*(unsigned char*)mode == 'b') {
        flags ^= _IOTEXT;
    }
#endif

    if (fd == -1) {
        fd = open(name, access, flags);
    }

    {
        FILE* fp2 = fp;
        if (fd == -1)
            return (FILE*)NULL;
        fp2->desc.fd = fd;
        fp2->ungetc = 0;
        fp2->flags = flags;
        return fp2;
    }
}

/* If fopen/freopen() is used, we need to close all files, so do it */
static void freopen1_cleanup_exit() __naked {
#asm
	SECTION	code_crt_exit
	EXTERN	closeall
	call	closeall
#endasm
}
