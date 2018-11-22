;
;	PC-8801 specific routines
;	by Stefano Bodrato, 2018
;
;	int pc88_v2mode();
;
;	The result is:
;	- 0 (false) if the DIP switches are in V1 mode
;	- 1 (true) if the DIP switches are in V2 mode
;
;	Clears the keyboard buffer
;
;	$Id: pc88_v2mode.asm $
;

        SECTION code_clib
	PUBLIC	pc88_v2mode
	PUBLIC	_pc88_v2mode
	
pc88_v2mode:
_pc88_v2mode:
	in a,($31)
	cpl
	rlca
	and 1
	ld	h,0
	ld	l,a
	ret
