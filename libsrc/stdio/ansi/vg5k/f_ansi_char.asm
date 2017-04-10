;
; 	ANSI Video handling for the Philips VG-5000
;
;	set it up with:
;	.text_cols	= max columns
;	.text_rows	= max rows
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;	Stefano Bodrato - 2014
;
;
;	$Id: f_ansi_char.asm,v 1.4 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_CHAR
	
	PUBLIC	text_cols
	PUBLIC	text_rows

	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN
	
	EXTERN	vg5k_attr

.text_cols   defb 40
.text_rows   defb 25


.ansi_CHAR
	ld	ix,$47FA

	ld    d,a
	
	ld    a,(vg5k_attr)
	ld    e,a		; white on black
	
	ld    a,(ansi_COLUMN)
	ld    l,a
	ld    a,(ansi_ROW)	
	ld    h,a
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
	
	ld   a,d
	ld   (hl),a
	inc  hl
	ld   a,e
	ld   (hl),a
	ret
