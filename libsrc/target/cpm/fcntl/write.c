/*
 *  Write to a file
 *
 *  27/1/2002 - djm
 *
 *  May, 2020 - feilipu - added sequential write
 *
 *  $Id: write.c,v 1.5 2013-06-06 08:58:32 stefano Exp $
 */

#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <cpm.h>


ssize_t write(int fd, void *buf, size_t len)
{
    unsigned char buffer[SECSIZE+2];
    unsigned char uid;
    struct fcb *fc;
    size_t cnt,size,offset;

    if ( fd >= MAXFILE )
    return -1;

    fc = &_fcb[fd];
    cnt = len;
    offset = CPM_WCON;  /* Double use of variable */

    switch ( fc->use ) {
#ifdef DEVICES
    case U_PUN:
        while ( len-- ) {
            bdos(CPM_WPUN,*buf++);
        }
        return cnt;
        break;
    case U_LST:
        offset = CPM_WLST;
    case U_CON:
        while ( len-- ) {
            bdos(offset,*buf++);
        }
        return cnt;
        break;
#endif
    case U_WRITE:
    case U_RDWR:
        uid = getuid();
        setuid(fc->uid);
        while ( len ) {
            offset = fc->rwptr%SECSIZE;
            if ( (size = SECSIZE-offset) > len ) {
                size = len;
            }
            if ( size == SECSIZE ) {
                bdos(CPM_SDMA,buf);
                if ( bdos(CPM_WRIT,fc) ) {
                    setuid(uid);
                    return -1;   /* Not sure about this.. */
                }
            } else {  /* Not the required size, read in the extent */
                bdos(CPM_SDMA,buffer);
                _putoffset(fc->ranrec,fc->rwptr/SECSIZE);
                /* Blank out the buffer to indicate EOF */
                buffer[0] = 26;         /* ^Z */
                memcpy(buffer+1,buffer,SECSIZE-1);
                bdos(CPM_RRAN,fc);
                memcpy(buffer+offset,buf,size);
                if ( bdos(CPM_WRAN,fc) ) {
                    setuid(uid);
                    return -1;   /* Not sure about this.. */
                }
            }
            buf += size;
            fc->rwptr += size;
            len -= size;
        }
        setuid(uid);
        return cnt-len;
        break;
    default:
        return -1;
        break;
    }
}

