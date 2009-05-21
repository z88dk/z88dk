;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato
;	MSX emulation layer
;
;	read keyboard line for cursor keys + space
;
;
;	$Id: svi_kbdstick.asm,v 1.1 2009-05-21 06:58:11 stefano Exp $
;

	XLIB	svi_kbdstick
	
IF FORmsx
        INCLUDE "#msx.def"
ELSE
        INCLUDE "#svi.def"
ENDIF


svi_kbdstick:
	di
	in	a,(PPI_C)
	and	$f0
	add	8
	out	(PPI_C),a
	in	a,(PPI_B)	; bits: RDULxxxF  Fire is the SPACE key
	ei
	ret

