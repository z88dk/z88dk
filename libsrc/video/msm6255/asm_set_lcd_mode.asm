

		SECTION		code_clib

		PUBLIC		asm_set_lcd_mode

		INCLUDE		"msm6255.inc"


;	Set the mode of LCD controller
	
;	0000000x -> GRAPHICS (1), TEXT (0)
;	00000xx0 -> 4bit parallel (01) / serial (00) / serial EVEN-ODD (10) -> Bondwell 2 is EVEN-ODD
;	0000x000 -> Display ON/OFF
;	000x0000 -> TEXT Cursor blinking	(e.g. 3D)
;	00x00000 -> TEXT Cursor ON/OFF
;	0x000000 -> TEXT Blinking time


	; Useful modes on Bondwell 2
	; 0x75	;DISPLAY OFF
	; 0x7D	;DISPLAY ON (TEXT CSR. ON, useless on BW2)


;
; Uses: af, l, bc (on some targets)
;

asm_set_lcd_mode:

	xor a
IF address_w > 256
	ld	bc,address_w
	out	(c),a
ELSE
	out	(address_w),a
ENDIF

IF register_w > 256
	ld	bc,register_w
	out	(c),l
ELSE
	ld	a,l	
	out	(register_w),a
ENDIF
	ret

