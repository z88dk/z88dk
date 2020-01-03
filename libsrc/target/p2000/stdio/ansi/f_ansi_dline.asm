;
; 	ANSI Video handling for the P2000T
;
;	Stefano Bodrato - Apr. 2014
;
;
; 	Clean a text line
;
;   in: A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.3 2016-06-12 16:06:43 dom Exp $
;


        SECTION code_clib
	PUBLIC	ansi_del_line


.ansi_del_line
	push	af
	ld	a,4
	call $60C0
	
	pop af
	call $60C0

	ld	a,0
	call $60C0

	ld b,40
.dline	
	push bc
	ld a,' '
	call $60C0
	pop bc
	djnz dline

	ret
