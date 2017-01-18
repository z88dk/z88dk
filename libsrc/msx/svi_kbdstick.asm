;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato
;	MSX emulation layer
;
;	read keyboard line for cursor keys + space
;
;
;	$Id: svi_kbdstick.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC svi_kbdstick
	PUBLIC _svi_kbdstick
	
IF FORmsx
        INCLUDE "msx.def"
ELSE
        INCLUDE "svi.def"
ENDIF


svi_kbdstick:
_svi_kbdstick:
	di
	in	a,(PPI_C)
	and	$f0
	add	8
	out	(PPI_C),a
	in	a,(PPI_B)	; bits: RDULxxxF  Fire is the SPACE key
	ei
	ret

