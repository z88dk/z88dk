
	SECTION  code_clib
	PUBLIC	leftbitmask

;
;	$Id: lbitmask.asm,v 1.4 2016-04-13 21:09:09 dom Exp $
;

; ************************************************************************
;
; Get left bitmask for left side of byte
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; IN: A =	bitposition
;
; OUT: A = bitmask at left side of	bit position of byte
;
;	Example:
;			IN:	A = 3
;			OUT:	A = @11110000	(bit	7 - 4 as mask)
;
;	registers	chnaged after return:
;		..bcdehl/ixiy	same
;		af....../....	different
;
.leftbitmask		xor	7			; 7-bitpos
				ret	z			; no	bitmask to preserve...
				push	bc
				ld	b,a
				xor	a
.left_bitmask_loop	scf
				rra				; create left bitmask
				djnz	left_bitmask_loop
				pop	bc
				ret
