#ASM
		include "unplot.asm"

test_unplot:
		ld 		b, 20
row1:	ld 		c, 20
col1:	push 	bc
		call 	unplot
		pop		bc
		
		dec		c
		jr 		nz, col1
		
		djnz 	row1
		ret
#ENDASM
		FOR R=0 TO 21
		PRINT AT R,0;"% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % ";
		NEXT R

		LET T0=PEEK $4034+256*PEEK $4035
		RAND USR &test_unplot
		RAND USR &test_unplot
		LET T1=PEEK $4034+256*PEEK $4035
		PRINT (T0-T1)/50

