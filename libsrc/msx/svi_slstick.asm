;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato
;	MSX emulation layer
;
;	read from joystick port
;
;
;	$Id: svi_slstick.asm,v 1.1 2009-05-21 06:58:11 stefano Exp $
;

	XLIB	svi_slstick
	LIB	msx_readpsg
	

IF FORmsx
        INCLUDE "#msx.def"
ELSE
        INCLUDE "#svi.def"
ENDIF


	
svi_slstick:
	ld	b,a
	di
	ld	l,$0f	; port B
	call	msx_readpsg
	djnz	stick1
	and	$df
	or	$4c
	jr	stick2
stick1:	and	$af
	or	3
stick2:	out	(PSG_DATA),a
	ld	l,$0e	; port A
	call	msx_readpsg
	ei
	ret
