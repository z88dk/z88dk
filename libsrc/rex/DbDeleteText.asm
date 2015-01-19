;
;	Database Call for REX6000
;
;	DbDeleteText
;
;	$Id: DbDeleteText.asm,v 1.3 2015-01-19 01:33:06 pauloscustodio Exp $

		PUBLIC	DbDeleteText


.DbDeleteText
	ld	ix,2
	add	ix,sp
	
	ld	hl,$0000
	push	hl
	ld	hl,$0003
	push	hl
	ld	hl,$0000
	push	hl
	add	hl,sp
	ld	($c00a),hl
	ld	l,(ix+0)
	ld	h,(ix+1)
	ld	($c008),hl
	ld	l,(ix+2)
	ld	h,(ix+3)
	ld	($c006),hl
	ld	l,(ix+4)
	ld	h,(ix+5)
	ld	($c004),hl
	ld	l,(ix+6)
	ld	h,(ix+7)
	ld	($c002),hl
	ld	hl,$00ea
	ld	($c000),hl
	rst	$10
	ld	hl,($c00e)
	pop	af
	pop	af
	pop	af
	ret


