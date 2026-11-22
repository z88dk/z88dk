/*
 *  CP/M Directory browsing
 * 
 *  Stefano, 5 Jun 2013
 *  07/2019: Workaround to stabilize dir_move_next when file operations happen.
 *  08/2019: Dealing with the bdos() function in a correct way
 *
 *
 *  $Id: dir_move_next.c $
 */

#include <cpm.h>

extern int dir_current_pos;


int dir_move_next()
{
    int entry_count;
    int current_entry;

    // Save the next position
    current_entry = dir_current_pos;

    // Reset directory reading and get back to where we need to be
    dir_move_first();

    for (entry_count=0; entry_count<current_entry; entry_count++)
        bdos(CPM_FNXT,&fc_dir);

    // Save the next position for next time
    dir_current_pos = current_entry+1;

    // And see if there is a file here
    fc_dirpos = bdos(CPM_FNXT,&fc_dir);

    return (fc_dirpos==-1?0x24:0);    // Not knowing what to pass for non-zero, let's simulate FLOS error code $24 (= Reached end of directory)
}
