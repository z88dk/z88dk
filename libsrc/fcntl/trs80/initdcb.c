/*
 *	Init the TRSDOS DCB (FCB)
 *	Stefano Bodrato - 2019
 *
 *	Internal use only
 *  The tested versions of TRSDOS/NEWDOS accept \0 in place of CR as filename termination,
 *  but we change it according to some of the existing docs.
 *
 *	$Id: initdcb.c $
 */

#include <trsdos.h>

#include <ctype.h>
#include <string.h>
#include <malloc.h>


char _trs80_dcb_fname[33];


int initdcb(char *filespec, struct TRSDOS_FCB *fcb)
{
	int x;
	
	
	strcpy (_trs80_dcb_fname,filespec);
	
	for (x=0; x<33; x++) {
		_trs80_dcb_fname[x] = toupper(_trs80_dcb_fname[x]);
		if (_trs80_dcb_fname[x]==0) _trs80_dcb_fname[x]=13;
		//if (_trs80_dcb_fname[x]=='.') _trs80_dcb_fname[x]='/';
	}
	
	//_trs80_dcb_fname[strlen(_trs80_dcb_fname)]=13;
	return (trsdos_tst(DOS_FSPEC, _trs80_dcb_fname, fcb));

}

