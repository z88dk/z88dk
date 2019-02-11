;
;	ZX IF1 & Microdrive functions
;	
;	int if1_find_sector_map (char *mdvmap);
;
;	Find the first free sector in the specified drive map
;
;	
;	$Id: if1_find_sector_map.asm,v 1.3 2016-07-01 22:08:20 dom Exp $
;

		SECTION code_clib
		PUBLIC 	if1_find_sector_map
		PUBLIC 	_if1_find_sector_map

if1_find_sector_map:
_if1_find_sector_map:
		pop	af
		pop	hl
		push	hl
		push	af

		ld	c,0
		ld	b,32

byte_loop:	ld	a,(hl)
		cp	255
		jr	z,close_loop

chk_bit:	rra
		jr	c,not_free
		ld	h,0
		ld	l,c		; here's the sector number !
		ret
not_free:	inc	c
		jr	chk_bit		; we KNOW that there is at least one zeroed bit !

close_loop:	ld	a,8
		add	c
		ld	c,a
		inc	hl
		djnz	byte_loop
		
		ld	hl,-1		; no free space
		ret
