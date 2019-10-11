/*
 *	Register an interrupt
 *	This is on an application basis (sorry!)
 *
 *	Global is done on another basis...
 *
 *	djm 9/2/2000
 */

#include <z88.h>

int RegisterInt(func,type,tick)
	void (*func)();
	int type;
	int tick;
{
#pragma asm
	INCLUDE	"packages.def"
; First of all check that package system is there
	call_pkg(pkg_ayt)		;preserves ix
	ld	hl,0	;Failure
	ret	c	;We failed
; Aha..we packages are there...good...
; So..set us up..
	ld	ix,0	;offset to func
	add	ix,sp
	ld	e,(ix+6)
	inc	hl
	ld	d,(ix+7)
	ld	(packintrout),de
	ld	c,(ix+2)	;tick
	ld	b,(ix+4)	;type
	ld	hl,introut
	ld	a,int_prc
	call_pkg(pkg_intr)		;preserves ix
	ld	hl,1
	ret	nc	;Success
	dec	hl
	ret
; Out interrupt routine..we preserve main registers
.introut
	push	hl
	push	de
	push	bc
	push	ix
	push	iy
	ld	hl,(packintrout)
	call	l_jphl
	pop	iy
	pop	ix
	pop	bc
	pop	de
	pop	hl
	ret
#pragma endasm
}


