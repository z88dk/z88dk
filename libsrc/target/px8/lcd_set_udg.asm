
;
;	PX-8 routines
;	by Stefano Bodrato, 2019
;
;	Define User Defined Graphics character, valid codes:  E0h..FFh
;
;	$Id: lcd_set_udg.asm $
;
;
;


	SECTION	code_clib
	PUBLIC	lcd_set_udg
	PUBLIC	_lcd_set_udg

	EXTERN subcpu_call
	
lcd_set_udg:
_lcd_set_udg:

	pop	af
	pop	hl
	pop de		; font
	push de		; character code
	push hl		; font data for character
	push af
	
	ld	a,e
	ld	(charcode),a
	ld	de,data
	ld	bc,8
	ldir
	
	ld	hl,packet_wr
	jp	subcpu_call


; master packet for write operation
packet_wr:
	defw	sndpkt
	defw	10		; packet sz (=7 when writing)
	defw	data	; packet addr expected back from the slave CPU
	defw	1		; size of the expected packet being received (just the return code)

	
sndpkt:
	defb	$30		; slave CPU command to define UDG character
charcode:
	defb	0
data:
	defs	8
