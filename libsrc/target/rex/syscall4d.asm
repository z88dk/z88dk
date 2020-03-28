;
;	System Call for REX6000
;
;
;	simply rewritten the function with Damjan's algorithm
;	Daniel
;
;	$Id: syscall4d.asm,v 1.4 2015-01-19 01:33:06 pauloscustodio Exp $

		PUBLIC	syscall4d


.syscall4d
	ld	ix,2
	add	ix,sp
	ld	l,(ix+0)	;par 4
	ld	h,(ix+1)
	ld	($c00a),hl
	ld	l,(ix+2)
	ld	h,(ix+3)
	ld	($c006),hl	;par 3
	ld      a,h
        ld      hl,0
        in      a,(1)           ; load mem page of addin code
        ld      l,a
	ld	($c008),hl
	ld	l,(ix+4)	;par 2
	ld	h,(ix+5)
	ld	($c004),hl
	ld	l,(ix+6)	;par 1
	ld	h,(ix+7)
	ld	($c002),hl
	ld	l,(ix+8)	;call
	ld	h,(ix+9)
	ld	($c000),hl
	rst	$10
	ld	hl,($c00e)
	ret


