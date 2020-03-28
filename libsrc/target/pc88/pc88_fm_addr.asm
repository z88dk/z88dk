;
;	PC-8801 specific routines
;	by Stefano Bodrato, 2018
;
;	int pc88_fm_addr();
;
;	Look for a soundchip responding to the YM standard commands, extra HW is ignored
;
;	$Id: pc88_fm_addr.asm $
;

        SECTION code_clib
	PUBLIC	pc88_fm_addr
	PUBLIC	_pc88_fm_addr
	
pc88_fm_addr:
_pc88_fm_addr:
	
	ld	h,0
	
	ld	c,$44
	call testopl
	ret nc
	
	ld	c,$A8
	call testopl
	ret nc
	
;	ld	c,$46
;	call testopl
;	ret nc
;	
;	ld	c,$AC
;	call testopl
;	ret nc
	
	ld l,h
	ret
	

testopl:
	ld	l,c

	ld	a,$ff
	out	(c),a
	inc c
	in	a,(c)
	dec	c
	cp 1
	ret
