;
;	System Call for REX6000
;
;	$Id: syscall4d.asm,v 1.1 2001-07-24 07:26:52 dmarion Exp $
;

		XLIB	syscall4d


.syscall4d
	ld	ix,2
	add	ix,sp
	ld	l,(ix+0)	;par 5
	ld	h,(ix+1)
	ld	($c00a),hl
	ld	l,(ix+2)	;par 4
	ld	h,(ix+3)
	ld	($c008),hl
	ld	l,(ix+4)	;par 3
	ld	h,(ix+5)
	ld	($c006),hl
	ld	l,(ix+6)	;par 2
	ld	h,(ix+7)
	ld	($c004),hl
	ld	l,(ix+8)	;par 1
	ld	h,(ix+9)
	ld	($c002),hl
	ld	l,(ix+10)	;call
	ld	h,(ix+11)
	ld	($c000),hl
	rst	$10
	ld	hl,($c00e)
	ret


