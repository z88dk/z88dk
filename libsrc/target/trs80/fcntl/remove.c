/*
 *	Kill a file on TRS-80
 *	Stefano Bodrato - 2019
 *
 *	returns error status
 *
 *
 *	Access is either
 *
 *	O_RDONLY = 0
 *	O_WRONLY = 1    Starts afresh?!?!?
 *	O_APPEND = 256
 *
 *	$Id: remove.c $
 */

#include <fcntl.h>
#include <trsdos.h>

// stdio includes the declaration for 'remove'
#include <stdio.h>
#include <malloc.h>

// perhaps we could affort 32 static bytes, but malloc() is already used elsewere
//char _fcb_remove[32];

int remove(char *name)
{

struct TRSDOS_FCB *_fcb_remove;

_fcb_remove = malloc(sizeof(struct TRSDOS_FCB));
if (_fcb_remove == 0)
	return (-1);

/* Prepare FCB for file being removed */
//trsdos(DOS_FSPEC, name, _fcb_remove);
if (initdcb(name, _fcb_remove))
	return (-1);

/* open FCB without associated buffer: we're just going to kill the file ! */
if ( trsdos_tst(DOS_OPEN_EX, 0, _fcb_remove) )
	return (-1);

if ( trsdos_tst(DOS_KILL, 0, _fcb_remove) )
	return (-1);

return(0);

}

