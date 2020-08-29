/*
 *	int stat(char *filename, struct stat *buf)
 *
 *	Return information about a file in CP/M
 *
 *	TODO: file date/time support for CP/M versions > 3.00 (MP/M II, etc)
 *
 *
 *	Stefano 2019
 *
 *
 * -----
 * $Id: stat.c $
 */


#include <sys/stat.h>
#include <cpm.h>
#include <stdio.h>
#include <fcntl.h>
#include <time.h>

time_t doepoch(int days, int hours, int minutes)
{
        return ((long)(days+2921)*86400L+(long)hours*3600L+(long)minutes*60L);
}


int stat(char *filename, struct stat *buf)
{

	int inode;

    struct fcb *fc;
    struct sfcb *sfc;

    //unsigned char uid,pad;

	/* We lend a free FCB slot, but we leave the fc->use flag reset (no space reservation) */
    if ( ( fc = getfcb() ) == NULL ) {
        return -1;
    }

	/* Test it is a real file, not a device */
    if ( setfcb(fc,filename) != 0 ) {
		clearfcb(fc);		// equals to fcb->use = 0;
        return -1;
    }
	
	/* Compute file size */
    if ( bdos(CPM_CFS,fc) != 0 ) {
		clearfcb(fc);
        return -1;
    }

	buf->st_mode=0100777;	/* regular file flag, rwxrwxrwx */
	
	/* File size and block size, approx. at 128 bytes boundary */
	buf->st_blksize = 128;		/* Size of a CP/M block */
	/* NOTE:  file sizes >= 8MB will make st_blocks overflow, but st_size will still work */
	buf->st_blocks = fc->ranrec[0] + 256 * fc->ranrec[1];
	buf->st_size = (unsigned long) buf->st_blocks * 128L;
	if (fc->ranrec[2]&1)
		buf->st_size += 8388608L;
	
	
	/* UID & GID stuff */
	buf->st_gid=0;
	buf->st_uid=fc->uid;
	
	/* Device stuff */
	buf->st_dev=1;
	buf->st_rdev=0;
	
	/* Inode - try to make unique.. */
	buf->st_ino=fc->ranrec[0]+filename[0];
	
	/* Links */
	buf->st_nlink=0;


	/* Date/Time */
	buf->st_ctime=buf->st_mtime=buf->st_atime=0L;
	if	(bdos(CPM_VERS,0) >= 0x30) {
		sfc=(void *)fc;
		if (bdos(102,sfc)!=0) { /* read file date stamps and password mode */
			buf->st_mtime=doepoch(sfc->date,sfc->hours,sfc->minutes);
			buf->st_ctime=buf->st_atime=doepoch(sfc->c_date,sfc->c_hours,sfc->c_minutes);
		}
	}

	clearfcb(fc);
	return 0;
}

