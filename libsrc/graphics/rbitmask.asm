
        SECTION code_clib
	PUBLIC	rightbitmask

;
;	$Id: rbitmask.asm,v 1.5 2016-04-13 21:09:09 dom Exp $
;

; ************************************************************************
;
; Get right bitmask for rigth side of byte to preserve during clear
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; IN:  A = bitposition
;
; OUT: A = bitmask at right side of bit	position of byte
;
;	Example:
;			IN:	A = 6
;			OUT:	A = @00111111	(bit	5 - 0 as mask)
;
;	registers changed after return:
;		..bcdehl/ixiy	same
;		af....../....	different
;

.rightbitmask			cp  0				; 7-bitpos
				ret	z			; no	bitmask to preserve...
				push	bc
				ld	b,a
				xor	a
.right_bitmask_loop		scf
				rla				; create right	bitmask
				djnz	right_bitmask_loop
				pop	bc
				ret
