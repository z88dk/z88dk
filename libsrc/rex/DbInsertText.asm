;
;	Database Call for REX6000
;
;	DbInsertText
;
;	$Id: DbInsertText.asm,v 1.2 2002-04-17 21:30:25 dom Exp $

		XLIB	DbInsertText


.DbInsertText
	ld	ix,2
	add	ix,sp
	
	ld	l,(ix+0)
	ld	h,(ix+1)
	push	hl
	ld	hl,$0002
	push	hl
	ld	hl,$0000
	push	hl
	add	hl,sp
	ld	($c00a),hl
	ld	l,(ix+2)
	ld	h,(ix+3)
	ld	($c008),hl
	ld	l,(ix+4)
	ld	h,(ix+5)
	ld	($c006),hl
	ld	l,(ix+6)
	ld	h,(ix+7)
	ld	($c004),hl
	ld	l,(ix+8)
	ld	h,(ix+9)
	ld	($c002),hl
	ld	hl,$00ea
	ld	($c000),hl
	rst	$10
	ld	hl,($c00e)
	pop	af
	pop	af
	pop	af
	ret


