;
;	PC-8801 specific routines
;	by Stefano Bodrato, 2018
;
;	void pc88_locate(unsigned char x, unsigned char y);
;
;	Move the screen cursor to a given position
;
;	$Id: pc88_locate.asm $
;

        SECTION code_clib
	PUBLIC	pc88_locate
	PUBLIC	_pc88_locate
	

pc88_locate:
_pc88_locate:
	
	pop	bc
	pop	hl
	pop	de
	push de
	push hl
	push bc
	
;	ld	h,e
;	ld	l,d
;	call $429D

	LD A,E
	LD ($EF87),A		; TTYPOS X
	LD A,L
	LD ($EF86),A		; TTYPOS Y

	ret
