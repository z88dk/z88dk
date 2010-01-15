/*
 *	Read from a file
 *
 *	int fread(void *ptr, size_t size, size_t nmemb, FILE *fp)
 *
 *	Calls read() in fcntl to do the dirty work
 *
 *	Returns number of members readen
 *
 *	We have to take account of ungotten characters
 *
 *	djm 1/4/2000
 *
 * --------
 * $Id: fread.c,v 1.7 2010-01-15 07:12:05 stefano Exp $
 */

#define ANSI_STDIO

#include <stdio.h>

int fread(void *ptr, size_t size, size_t nmemb, FILE *fp)
{
	if ( (fp->flags&(_IOUSE|_IOREAD)==(_IOUSE|_IOREAD))  && 
			fchkstd(fp)== 0) {
		int	readen = size*nmemb;
		int     count  = 0;
#ifdef __STDIO_BINARY
		while ( count < readen ) {
		    int c = fgetc(fp);
		    if ( c == EOF ) {
			break;
		    }
		    *ptr++ = (unsigned char)c;
		    ++count;
		}
		return ( count / size );  /* Relies on 0 / x != EXCEPTION */
#else			
		if (readen) {
		    /* Pick up ungot character */
		    int c = fgetc(fp);
		    /* Horrible hack around here */
		    if ( c >= 0 ) {
			*ptr = (unsigned char )c;
			readen=read(fp->desc.fd,ptr+1,readen-1);
			++readen;
			/* Return number of members read */
			return (readen/size);
		    }
		}
#endif
	}
	return 0;
}


