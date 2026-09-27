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
        flags = _IOREAD | _IOTEXT;
        break;
    case 'w':
        access = O_WRONLY | O_TRUNC | O_CREAT;
        flags = _IOWRITE  | _IOTEXT;
        break;
    case 'a':
        access = O_APPEND | O_WRONLY | O_CREAT;
        flags = _IOWRITE  | _IOTEXT;
        break;
    default:
        return NULL;
    }

    /* Scan remaining mode characters for '+' (update) and 'b' (binary) in any
     * order. Apply '+' before 'b' so binary flags are not clobbered. */
    {
        const unsigned char *m = (const unsigned char *)mode;
        unsigned char c;
        int plus = 0, binary = 0;
        while ((c = *m++) != 0) {
            if (c == '+')      plus = 1;
            else if (c == 'b') binary = 1;
        }
        if (plus) {
            if (access == O_RDONLY) {
                access = O_RDWR;
                flags = _IOREAD | _IOWRITE | _IOTEXT;
            } else if (access & O_TRUNC) {  // 'w'
                access = O_RDWR | O_TRUNC | O_CREAT;
                flags = _IOREAD | _IOWRITE | _IOTEXT;
            } else {
                access = O_RDWR | O_CREAT;
            }
        }
        if (binary) {
#ifdef __STDIO_BINARY
            flags ^= _IOTEXT;
#endif
        }
    }

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
