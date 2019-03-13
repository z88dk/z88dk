;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato
;	MSX emulation layer
;
;	read from joystick port
;
;
;	$Id: svi_slstick.asm,v 1.6 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	svi_slstick
	EXTERN	get_psg
	

IF FORmsx
        INCLUDE "target/msx/def/msx.def"
ELSE
        INCLUDE "target/svi/def/svi.def"
ENDIF


	
svi_slstick:
	ld	b,a
	di

; Spectravideo uses register #15 in a different way (memory banks, etc..)

IF FORmsx
	ld	l,$0f	; port B
	call	get_psg
	djnz	stick1
	and	$df
	or	$4c
	jr	stick2
stick1:	and	$af
	or	3
stick2:	out	(PSG_DATA),a

	ld	l,$0e	; port A
	call	get_psg

ELSE

	ld	l,$0e	; port A
	call	get_psg
	djnz	stick1

	; SVI - Stick 2
	rra
	rra
	rra
	rra
	and	$0F
	ld	d,a
	in      a,(PPI_A)
	rra
	and	$10		; Stick #2 Trigger
	or	d		
	jr	stick2

stick1:
	; SVI - Stick 1
	and	$0F
	ld	d,a
	in      a,(PPI_A)
	and	$10		; Stick #1 Trigger
	or	d

stick2:

ENDIF

	ei
	ret

