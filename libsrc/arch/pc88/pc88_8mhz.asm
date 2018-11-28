;
;	PC-8801 specific routines
;	by Stefano Bodrato, 2018
;
;	int pc88_8mhz();
;
;	The result is:
;	- 0 (false) if the CPU is set at 4mhz
;	- 1 (true) if the DIP switches are in V2 mode
;
;	Clears the keyboard buffer
;
;	$Id: pc88_8mhz.asm $
;

        SECTION code_clib
	PUBLIC	pc88_8mhz
	PUBLIC	_pc88_8mhz
	
pc88_8mhz:
_pc88_8mhz:
    in	a,($6E)                 ;bit7:0=8MHz 1=4MHz (FH??)
	ld	hl,0
    rlca
	ret	c
	inc	hl
	ret
