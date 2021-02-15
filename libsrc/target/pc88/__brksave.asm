
	SECTION data_clib

	PUBLIC	__brksave

__brksave:	defb	1	;; Keeping the BREAK enable flag, used by pc88_break, etc..
