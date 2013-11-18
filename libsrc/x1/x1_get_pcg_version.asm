;
;	Sharp X1 specific routines
;	Programmable Character Generator
;	Get the PCG version (1 or 2), depending on the X1 model (or chipset)
;	and on the mode DIP switch
;
;	$Id: x1_get_pcg_version.asm,v 1.2 2013-11-18 16:13:11 stefano Exp $
;

	XLIB	x1_get_pcg_version
	

x1_get_pcg_version:

		; Check the PCG type probing the KANJI VRAM
		xor	a
		ld	bc,37FFh
		out	(c),a
		inc	a
		ld	b,3Fh
		out	(c),a
		ld	b,37h
		in	a,(c)
		ld	e,a
		
		; Standard mode set via DIP switch ?
		ld	bc,1FF0h
		in	a,(c)
		and	1
		or	e
		
		ld	hl,1
		ret nz
		
		inc hl
		ret
