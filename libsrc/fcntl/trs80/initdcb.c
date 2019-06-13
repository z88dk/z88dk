/*
 *	Init the TRSDOS DCB (FCB)
 *	Stefano Bodrato - 2019
 *
 *	Internal use only
 *  At the moment this extra function is almost useless, the tested versions of TRSDOS accept \0 in place of CR as filename termination.
 *  By the way having a funtion to deal with filename formatting is a good idea to easily add extra formatting, filename conversion, etc..
 *
 *
 *	$Id: initdcb.c $
 */

#include <trsdos.h>

#include <string.h>
#include <malloc.h>


char _trs80_dcb_fname[33];


int initdcb(char *filespec, struct TRSDOS_FCB *fcb)
{
	int x;
	
	
	strcpy (_trs80_dcb_fname,filespec);
	
	for (x=0; x<strlen(_trs80_dcb_fname); x++) {
		_trs80_dcb_fname[x] = toupper(_trs80_dcb_fname[x]);
		if (_trs80_dcb_fname[x]==0) _trs80_dcb_fname[x]=13;
		//if (_trs80_dcb_fname[x]=='.') _trs80_dcb_fname[x]='/';
	}
	
	//_trs80_dcb_fname[strlen(_trs80_dcb_fname)]=13;
	return (trsdos_tst(DOS_FSPEC, _trs80_dcb_fname, fcb));

}

