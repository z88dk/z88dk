#ASM
		include "get_pixel.asm"

test_get_pixel:
		ld 		hl, 0
		ld 		b, 20
row1:	ld 		c, 20
col1:	push 	bc
		push 	hl
		call 	get_pixel	; A=0/1
		pop 	hl
		pop		bc
		
		and     a
		jr 		z, cont
		inc  	hl
cont:
		dec		c
		jr 		nz, col1
		
		djnz 	row1
		
		ld 		bc, hl
		ret

#ENDASM
		FOR R=1 TO 4
		FOR C=1 TO 4
		PRINT AT R,C;"% "
		NEXT C
		NEXT R
		
		LET T0=PEEK $4034+256*PEEK $4035
		LET C=USR &test_get_pixel
		LET C=USR &test_get_pixel
		LET T1=PEEK $4034+256*PEEK $4035
		PRINT (T0-T1)/50,C

