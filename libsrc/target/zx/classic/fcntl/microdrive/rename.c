/*
 *	Rename a file on Microdrive
 *
 *	Stefano Bodrato - Oct. 2004
 *
 *	$Id: rename.c $
 */

#include <stdio.h>
#include <arch/zx/zxinterface1.h>


int rename(char *oldname, char *newname)
{
int blkcount, currblock;
struct M_CHAN mybuf;

  // Exit if 'microdrive not present' or 'write protected'
  if (if1_mdv_status(if1_driveno(oldname))) return (-1);
  
  // check if "newname" already exists (we get the optional drive specifier from the first parameter)
  if (if1_load_record (if1_driveno(oldname), if1_filename(newname), 0, &mybuf) != -1 ) return (-1);


  // load first file record and check for its existence
  if ((currblock = if1_load_record (if1_driveno(oldname), if1_filename(oldname), 0, &mybuf)) == -1 )
    return (-1);


  /* now rename every file record
     we skip the record no. 255 to avoid loops */
     
  for (blkcount=1; blkcount < 255; blkcount++)
    {
	   if1_setname(if1_filename(newname),mybuf.recname);
	   if1_setname(if1_filename(newname),mybuf.name);
       if (if1_write_sector (if1_driveno(oldname), currblock, &mybuf) == -1) return (-1);

	   // TODO: test the validity of the EOF flag in non-text files (e.g. CODE blocks)
	   if ((mybuf.recflg && 1) != 0) return 0;

       currblock = if1_load_record (if1_driveno(oldname), if1_filename(oldname), blkcount, &mybuf);
       if (currblock == -1) return 0;
    }
    return (0);
}
