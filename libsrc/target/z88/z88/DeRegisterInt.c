/*
 *	Deregister an interrupt
 *	This is on an application basis (sorry!)
 *
 *	Global is done on another basis...(so not
 *	covered here)
 *
 *	djm 9/2/2000
 */

#include <z88.h>

int DeRegisterInt(void)
{
#pragma asm
	INCLUDE	"packages.def"
; First of all check that package system is there
	call_pkg(pkg_ayt)	;preserves ix
	ld	hl,0	;Failure
	ret	c	;We failed
; Aha..we packages are there...good...
	ld	a,int_prc
	call_pkg(pkg_intd)	;preserves ix
	ld	hl,1
	ret	nc	;Success
	dec	hl
#pragma endasm
}


