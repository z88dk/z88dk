/*
 *  Open a file
 * 
 *  27/1/2002 - djm
 *
 *  We don't bother filling up the explicitname (yet...)
 *
 *  $Id: open_z88.c,v 1.1 2002-01-27 21:28:48 dom Exp $
 */

#include <cpm.h>
#include <stdio.h>
#include <fcntl.h>

int open_z88(far char *nam, int mode, mode_t flags, char *outbuf, size_t extlen)
{
    struct fcb *fc;
    unsigned char uid,pad;
    int   fd;
    char *name = nam;

    if ( ++mode > U_RDWR )
	mode = U_RDWR;

    if ( ( fc = getfcb() ) == NULL )
	return -1;

    if ( setfcb(fc,name) == 0 ) {  /* We had a real file, not a device */
	if ( mode == U_READ && bdos(CPM_VERS,0) >= 0x30 ) 
	    fc->name[5] |= 0x80;    /* read only mode */
	uid = getuid();
	setuid(fc->uid);

	if ( bdos(CPM_OPN,fc) == -1 ) {
	    clearfcb(fc);
	    setuid(uid);
	    if ( mode > U_READ ) {  /* If returned error and writer then create */
		fd = creat(name,0);
		if ( fd == -1 )
		    return -1;
		fc = _fcb[fd];
		fc->use = mode;
		return fd;
	    }
	}
	setuid(uid);
	fc->use = mode;
    }
    fd =  (fc - &_fcb[0]);
    return fd;
}
	
