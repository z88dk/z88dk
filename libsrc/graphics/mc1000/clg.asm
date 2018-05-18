;
;	MC-1000 graphics library
;
;	$Id: clg.asm $
;

;-----------  GFX init  -------------

	SECTION	  code_clib

	PUBLIC	clg
	PUBLIC	_clg

	PUBLIC	ansi_cls
	PUBLIC	_ansi_cls
	

.clg
._clg

.ansi_cls
._ansi_cls

	ld	b,255
	ld	a,$9e
	out	($80),a

	ld	hl,$8000
.clg1
	ld	(hl),b
	inc	hl
	ld	a,h
	cp	$98
	jp	nz,clg1

	ld	a,$9f
	out	($80),a
	ld	($f5),a		; Instruct the BASIC about the current screen mode
					; so the ROM won't mess with the video page when called
	ld	hl,clgret
	ld	($f7),hl	; cursor flashing and positioning routine

.clgret
	ret
