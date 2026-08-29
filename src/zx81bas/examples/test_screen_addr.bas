#ASM
		include "consts.inc"
		extern screen_addr
		
pos_col:	defb 0
pos_row:	defb 0
	
test_screen_addr:
		ld		bc, (pos_col)
		call	screen_addr
		ret		c			; error
		ld		(hl), CH_INV_SPACE
		ret
#ENDASM
		FOR R=23 TO 0 STEP -2
			POKE &pos_row, R
			FOR C=31 TO 0 STEP -3
				POKE &pos_col, C
				RAND USR &test_screen_addr
			NEXT C
		NEXT R
