/*
 *	Rename a file on Microdrive
 *
 *	Stefano Bodrato - Oct. 2004
 *
 *	$Id: rename.c,v 1.1 2005-02-18 08:35:53 stefano Exp $
 */

#include <fcntl.h>
#include <zxinterface1.h>


extern int if1_currentmdv;

int blkcount, currblock;
struct M_CHAN mybuf;


int rename(char *oldname, char *newname)
{
  // check if "newname" already exists
  if (if1_load_record (if1_currentmdv, newname, 0, mybuf) != -1 ) exit(-1);

  // load first file record and check for its existence
  if ((currblock = if1_load_record (if1_currentmdv, oldname, 0, mybuf)) == -1 )
    exit (-1);

  /* now rename every file record
     we skip the record no. 255 to avoid loops */
     
  for (blkcount=1; blkcount < 255; blkcount++)
    {
       if1_setname(newname,&mybuf->recname[0]);
       if (if1_write_sector (if1_currentmdv, currblock, mybuf) == -1) exit (-1);
       currblock = if1_load_record (if1_currentmdv, oldname, 0, mybuf);
       if (currblock == 0) return 0;
    }
}
