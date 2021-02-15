;
;	PC-8801 specific routines
;	by Stefano Bodrato, 2018
;
;	void pc88_breakon();
;
;	Restore disabled BREAK
;	At the moment only the results of  pc88_break() are affected:  ROM services will still react to BREAK
;
;	$Id: pc88_breakon.asm $
;

        SECTION code_clib
	PUBLIC	pc88_breakon
	PUBLIC	_pc88_breakon

	EXTERN	__brksave

pc88_breakon:
_pc88_breakon:
	xor a
	ld	(__brksave),a
	ret
