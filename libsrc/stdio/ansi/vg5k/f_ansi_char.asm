;
; 	ANSI Video handling for the Philips VG-5000
;
;	set it up with:
;	.__console_w	= max columns
;	.__console_h	= max rows
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;	Stefano Bodrato - 2014
;
;
;	$Id: f_ansi_char.asm,v 1.4 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_CHAR
	
	EXTERN	__console_y
	EXTERN	__console_x
	
	EXTERN	__vg5k_attr


.ansi_CHAR
	ld    d,a		; character
	
	ld    a,(__vg5k_attr)
	ld    e,a		; attribute
	
	ld    hl,(__console_x)	; l = x, h = y
	ld    a,h
	push  hl
	and   a
	jr    z,zrow
	add   7
.zrow
	ld    h,a
	push  de
	call  $92
	pop   de
	pop   hl
	
	push  de
	call  $a7		; video buffer access (keep a copy to scroll)
	pop   de
	
	ld   (hl),d
	inc  hl
	ld   (hl),e
	
	ld hl,_ef9345
	jp $AD			; hide cursor

_ef9345:
	defb 0x04,0x20,0x82,0x29,0x00

