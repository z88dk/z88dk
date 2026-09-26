;------------------------------------------------------------------------------
; zx81bas
; Copyright (C) Paulo Custodio, 2023-2026
; License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
;------------------------------------------------------------------------------

		include "consts.inc"

; compute screen address
; in:
; B=row 0..23, C=col 0..31
; out:
; HL=screen address
; carry set if coords invalid

		public screen_addr
		
screen_addr:
; check coordinates
		ld 		a, c			; A=column
		cp 		32
		jr 		nc, pos_error
		
		ld 		a, b			; A=row
		cp 		24
		jr 		nc, pos_error

; save registers
		push 	de

; compute row
		ld 		l, b
		ld 		h, 0 			; HL=row
		ld 		de, hl			; DE=row
		add 	hl, hl 			; *2
		add 	hl, hl 			; *4
		add 	hl, hl 			; *8
		add 	hl, hl 			; *16
		add 	hl, hl 			; *32
		add 	hl,	de 			; *33
; compute column
		ld 		e, c			; DE=column; D=0 from above
		inc 	e 				; skip initial 0x76
		add 	hl, de 			; HL = screen offset
		ld 		de, (D_FILE)
		add 	hl, de 			; HL = screen address
		
; clean up
		pop 	de 
		and 	a 				; clear carry
		ret
		
pos_error:
		ld 		hl, 0
		scf						; signal error
		ret

row_offsets:
		defw	0*33
		defw	1*33
		defw	2*33
		defw	3*33
		defw	4*33
		defw	5*33
		defw	6*33
		defw	7*33
		defw	8*33
		defw	9*33
		defw	10*33
		defw	11*33
		defw	12*33
		defw	13*33
		defw	14*33
		defw	15*33
		defw	16*33
		defw	17*33
		defw	18*33
		defw	19*33
		defw	20*33
		defw	21*33
		defw	22*33
		defw	23*33
		