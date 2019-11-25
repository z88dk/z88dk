/*
 *	int stat(char *filename, struct stat *buf)
 *
 *	Return information about a file
 *
 *	Stefano 2019
 *
 *
 * -----
 * $Id: stat.c $
 */


#include <sys/stat.h>
#include <flos.h>
#include <string.h>



int stat(char *filename, struct stat *buf)
{
	int inode=10000;	
	
    if ( dir_move_first() )
        return -1;

	while (strcmp(dir_get_entry_name(), filename)) {
		inode++;
		if ( dir_move_next() != 0 )
			return -1;
	}
		
	buf->st_ctime=buf->st_mtime=buf->st_atime=0L;
	
	if (!dir_get_entry_type())
		buf->st_mode=0100777;	/* regular file flag, rwxrwxrwx */
	else
		buf->st_mode=0040777;	/* directory, rwxrwxrwx */
	
	/* File size and block size */
	buf->st_blksize = 512;
	buf->st_size = dir_get_entry_size();
	buf->st_blocks = (buf->st_size + 511L)/512L;
	
	/* UID & GID stuff */
	buf->st_gid=0;
	buf->st_uid=0;
	
	/* Device stuff */
	buf->st_dev=1;
	buf->st_rdev=0;
	
	/* Inode - try to make unique.. */
	//buf->st_ino=get_first_file_cluster(filename);
	buf->st_ino=inode;
	
	/* Links */
	buf->st_nlink=0;

	return 0;
}
