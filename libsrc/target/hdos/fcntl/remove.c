/*
 *   FCNTL library for the Heath / Zenith HDOS
 *   Remove a file from the system
 *
 *   Stefano Bodrato - 2026
 *
 *   $Id: remove.c $
 */

#include <arch/hdos.h>
#include <fcntl.h>
#include <stdio.h>


int remove(char *name)
{

    if (hdos_delete (name))
		return 13;  // EACCES

    return 0;

}
