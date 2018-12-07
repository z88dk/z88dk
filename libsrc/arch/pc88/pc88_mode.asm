;
;	PC-8801 specific routines
;	by Stefano Bodrato, 2018
;
;	int pc88_mode();
;
;	The result is:
;	- 0 V1(S)
;	- 1 V1(H)
;	- 2 V2 mode
;
;	$Id: pc88_mode.asm $
;

        SECTION code_clib
	PUBLIC	pc88_mode
	PUBLIC	_pc88_mode
	
pc88_mode:
_pc88_mode:
    in a,($31)		;bit76: 10=V1S 11=V1H 01=V2
    rlca
    rlca
	and 3
	dec a
	ld hl,2
	ret z
    dec a
	ld	l,a
	ret

