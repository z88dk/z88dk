#ASM
		include "plot.asm"

test_plot:
		ld 		b, 20
row1:	ld 		c, 20
col1:	push 	bc
		call 	plot
		pop		bc
		
		dec		c
		jr 		nz, col1
		
		djnz 	row1
		ret
#ENDASM
		LET T0=PEEK $4034+256*PEEK $4035
		RAND USR &test_plot
		RAND USR &test_plot
		LET T1=PEEK $4034+256*PEEK $4035
		PRINT (T0-T1)/50

