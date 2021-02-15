;
;	PC-8801 specific routines
;	by Stefano Bodrato, 2018
;
;	void pc88_breakoff();
;
;	Disable BREAK
;	At the moment only the results of  pc88_break() are affected:  ROM services will still react to BREAK
;
;	$Id: pc88_breakoff.asm $
;

        SECTION code_clib
	PUBLIC	pc88_breakoff
	PUBLIC	_pc88_breakoff
	
	EXTERN	__brksave

pc88_breakoff:
_pc88_breakoff:
	ld	a,1
	ld	(__brksave),a
	ret
