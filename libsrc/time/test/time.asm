;
;
;	$Id: time.asm,v 1.1 2016-05-12 21:47:13 dom Exp $
;

		SECTION code_clib
		PUBLIC	time
		PUBLIC	_time

		INCLUDE	"test_cmds.def"

.time
._time
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	hl	;save store
	ld	a,CMD_GETTIME
	rst	8
	pop	bc
	ld	a,b
	or	c
	ret	z
	ld	a,l	;swap bc + hl
	ld	l,c
	ld	c,a
	ld	a,h
	ld	h,b
	ld	b,a
	ld	(hl),c
	inc	hl
	ld	(hl),b
	inc	hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
	ld	l,c
	ld	h,b
	ret

