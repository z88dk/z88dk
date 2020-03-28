;
;	PC-8801 specific routines
;	by Stefano Bodrato, 2018
;
;	void pc88_clearkey();
;
;	Clears the keyboard buffer
;
;	$Id: pc88_clearkey.asm $
;

        SECTION code_clib
	PUBLIC	pc88_clearkey
	PUBLIC	_pc88_clearkey
	EXTERN     pc88bios
	
pc88_clearkey:
_pc88_clearkey:
	push	ix
	
	xor	a
	ld	($E6B8),a
	ld      ix,$69e1
	call	pc88bios

	pop	ix
	ret
