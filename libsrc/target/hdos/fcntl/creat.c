/*
 *  Create a file
 * 
 *  27/1/2002 - djm
 *  HDOS version: Stefano, 2026
 *
 *  Based on Hitech C library (as usual)
 *  in C creat() is expected to be equivalent to:
 *      open("file.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
 *
 *  $Id: creat.c $
 */

#include <arch/hdos.h>
#include <stdio.h>
#include <fcntl.h>


int creat(char *nam, mode_t mode)
{
    struct fcb *fc;
    char       *name;

    name = nam;

    if ( ( fc = getfcb() ) == NULL )
        return -1;

    if ( setfcb(fc,name) == 0 ) {
        remove(name);
        if ( hdos_open_wr(name, fc->ch) ) {
            fc->use = 0;
            return -1;
        }
        fc->use = U_WRITE;
    }
    return (int)fc;
}


