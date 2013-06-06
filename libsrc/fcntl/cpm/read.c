/*
 *  Read from a file
 * 
 *  27/1/2002 - djm
 *
 *
 *  $Id: read.c,v 1.3 2013-06-06 08:58:32 stefano Exp $
 */

#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <cpm.h>


unsigned int read(int fd, void *buf, size_t len)
{   
    char    buffer[SECSIZE+2];
    unsigned char uid;
    struct fcb *fc;
    int    cnt,size,offset;

    if ( fd >= MAXFILE )
	return -1;

    fc = &_fcb[fd];

    switch ( fc->use ) {
#ifdef DEVICES
    case U_RDR:         /* Reader device */
		cnt = len;
		while( len ) {
			len--;
			if((*buf++ = (bdos(CPM_RRDR) & 0x7f)) == '\n')
				break;
		}
		return cnt - len;
		break;
    case U_CON:
	   if( len > SECSIZE)
	       len = SECSIZE;
	   buffer[0] = len;
	   bdos(CPM_RCOB, buffer);
	   cnt = buffer[1];
	   if(cnt < len) {
	       bdos(CPM_WCON, '\n');
	       buffer[cnt+2] = '\n';
	       cnt++;
	   }
	   memcpy(buf,&buffer[2], cnt);
	   return cnt;
       break;
#endif
    case U_READ:
    case U_RDWR:
		uid = getuid();
		cnt = len;
		while ( len ) {
			setuid(fc->uid);
			offset = fc->rwptr%SECSIZE;

			if ( ( size = SECSIZE - offset ) > len )
			size = len;
			_putoffset(fc->ranrec,fc->rwptr/SECSIZE);
			if ( size == SECSIZE ) {
			bdos(CPM_SDMA,buf);
			if ( bdos(CPM_RRAN,fc) )
				return -1;
			} else {
			bdos(CPM_SDMA,buffer);
			if ( bdos(CPM_RRAN,fc) ) {
				return -1;		  
			}
			memcpy(buf,buffer+offset,size);
			}
			buf += size;
			fc->rwptr += size;
			len -= size;
			setuid(uid);
		}
		setuid(uid);
		return cnt-len;
		break;
    default:
		return -1;
		break;
    }
}
		    

	    



