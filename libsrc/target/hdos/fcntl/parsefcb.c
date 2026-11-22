/*
 *  Set the FCB parameters to the supplied name pt 1
 *  This bit deals with userarea, device and filename
 *
 *  27/1/2002 - djm
 *  HDOS version: Stefano, 2026
 *
 *  $Id: parsefcb.c $
 */


#include <arch/hdos.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>


void parsefcb(struct fcb *fc, char *name)
{
    char *ptr;
    char c;

    //fc->drive = 0;         /* Default drive */
    //fc->uid   = getuid();  /* Set the userid */
	
	hdos_decode(name, fc->top);

    //fc->extent = fc->current_record = 0;
}
