/*
 *	Rename a file on Microdrive
 *
 *	Stefano Bodrato - Oct. 2004
 *
 *	$Id: rename.c,v 1.3 2005-03-01 17:50:37 stefano Exp $
 */

#include <stdio.h>
#include <zxinterface1.h>


int rename(char *oldname, char *newname)
{
int blkcount, currblock;
struct M_CHAN mybuf;

  // check if "newname" already exists
  if (if1_load_record (1, newname, 0, mybuf) != -1 ) return (-1);

  // load first file record and check for its existence
  if ((currblock = if1_load_record (1, oldname, 0, mybuf)) == -1 )
    return (-1);

  /* now rename every file record
     we skip the record no. 255 to avoid loops */
     
  for (blkcount=1; blkcount < 255; blkcount++)
    {
       if1_setname(newname,&mybuf->recname[0]);
       if (if1_write_sector (1, currblock, mybuf) == -1) return (-1);
       currblock = if1_load_record (1, oldname, blkcount, mybuf);
       if (currblock == -1) return 0;
    }
    return (0);
}
