/*
 *  Set the FCB parameters to the supplied name pt 1
 *  This bit deals with userarea, device and filename
 *
 *  27/1/2002 - djm
 *
 *  $Id: parsefcb.c,v 1.1 2002-01-27 21:28:48 dom Exp $
 */


#include <cpm.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>


void parsefcb(struct fcb *fc, unsigned char *name)
{
    unsigned char *ptr;
    unsigned char c;

    fc->drive = 0;         /* Default drive */
    fc->uid   = getuid();  /* Set the userid */

    ptr = name;

    while ( isdigit(*ptr) )  /* Find the end of the user number */
	ptr++;

    if ( name != ptr && *ptr == ':' ) {  /* uid has to end in colon */
	fc->uid = atoi(name);
	name = ++ptr;
    }

    if ( *name && name[1] == ':' ) {    /* Found a drive specifier */
	fc->drive = toupper(*name) - 'A' + 1; 
	name += 2;                      /* Skip over drive letter & colon */
    }

    /* Now copy the name */
    ptr = fc->name;
    
    /* Copy the name across upto the '.' or a '*' */
    while ( *name != '.' && *name != '*' && *name > ' ' &&
	    ptr < &fc->name[8] )
	*ptr++ = toupper(*name++);

    /* Now fill up to the first 8, with either a ? or space */
    if ( *name == '*' )
	c = '?';
    else
	c = ' ';
    while ( ptr < &fc->name[8] ) {
	*ptr++ = c;
    }

    /* Loop till we get to the extension */
    while ( *name && *name++ != '.' )
	continue;

    /* Now fill in the extension */
    while ( *name > ' ' && *name != '*' &&
	    ptr < &fc->ext[8] )
	*ptr++ = toupper(*name++);

    /* Now fill up the extension, with either a ? or space */
    if ( *name == '*' )
	c = '?';
    else
	c = ' ';
    while ( ptr < &fc->ext[3] )
	*ptr++ = c;


    fc->extent = fc->next_record = 0;
}

