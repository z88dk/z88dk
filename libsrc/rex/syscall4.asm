;
;	System Call for REX6000
;
;

		XLIB	syscall4


.syscall4
	ld	ix,2
	add	ix,sp
	ld	l,(ix+0)	;par 4
	ld	h,(ix+1)
	ld	($c008),hl
	ld	l,(ix+2)	;par 3
	ld	h,(ix+3)
	ld	($c006),hl
	ld	l,(ix+4)	;par 2
	ld	h,(ix+5)
	ld	($c005),hl
	ld	l,(ix+6)	;par 1
	ld	h,(ix+7)
	ld	($c002),hl
	ld	l,(ix+8)	;call
	ld	h,(ix+9)
	ld	($c000),hl
	rst	$10
	ld	hl,($c00e)
	ret


