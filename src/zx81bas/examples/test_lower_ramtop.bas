#ASM
		include "lower_ramtop.asm"
#ENDASM

		PRINT PEEK $4004+256*PEEK $4005
		POKE $4004, 0
		POKE $4005, $50
		PRINT USR &lower_ramtop
		PRINT PEEK $4004+256*PEEK $4005
