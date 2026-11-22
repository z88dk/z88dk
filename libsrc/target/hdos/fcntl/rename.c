/*
 *   FCNTL library for the Heath / Zenith HDOS
 *   Rename a file - HDOS version
 *
 *   Stefano Bodrato - 2026
 *
 *   $Id: rename.c $
 */

#include <arch/hdos.h>
#include <fcntl.h>
#include <stdio.h>

int rename(char *old, char *new)
{

    if (hdos_open_rd (new,5)== 0) {
        hdos_close (5);
        return 17;  //EEXIST
    }

    if (hdos_rename (old,new))
        return 13;  // EACCES

    return 0;
}
