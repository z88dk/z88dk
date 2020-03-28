;
;	Database Call for REX6000
;
;	DbReadText
;
;	$Id: DbReadText.asm,v 1.4 2017-01-03 00:11:31 aralbrec Exp $

		PUBLIC	DbReadText
      PUBLIC   _DbReadText


.DbReadText
._DbReadText
	ld	ix,2
	add	ix,sp
	
	ld	l,(ix+0)
	ld	h,(ix+1)
	push	hl
	ld	hl,$0001
	push	hl
	ld	l,(ix+2)
	ld	h,(ix+3)
	push	hl
	ld	hl,$0000
	add	hl,sp
	ld	($c00a),hl
	ld	l,(ix+4)
	ld	h,(ix+5)
	ld	($c008),hl
	ld	l,(ix+6)
	ld	h,(ix+7)
	ld	($c006),hl
	ld	l,(ix+8)
	ld	h,(ix+9)
	ld	($c004),hl
	ld	l,(ix+10)
	ld	h,(ix+11)
	ld	($c002),hl
	ld	hl,$00ea
	ld	($c000),hl
	rst	$10
	ld	hl,($c00e)
	pop	af
	pop	af
	pop	af
	ret


