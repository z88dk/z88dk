;
;	System Call for REX6000
;
;	$Id: syscall2.asm,v 1.2 2001-06-23 19:44:53 dom Exp $
;

		XLIB	syscall2


.syscall2
	ld	ix,2
	add	ix,sp
	ld	l,(ix+0)	;par 2
	ld	h,(ix+1)
	ld	($c004),hl
	ld	l,(ix+2)	;par 1
	ld	h,(ix+3)
	ld	($c002),hl
	ld	l,(ix+4)	;call
	ld	h,(ix+5)
	ld	($c000),hl
	rst	$10
	ld	hl,($c00e)
	ret


