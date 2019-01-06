;
;	Game device library for the SVI
;       Stefano Bodrato - 3/12/2007
;
;	$Id: joystick.asm,v 1.9 2016-06-16 20:23:51 dom Exp $
;

        SECTION code_clib
        PUBLIC  joystick
        PUBLIC  _joystick
	EXTERN	joystick_inkey

	INCLUDE	"target/svi/def/svi.def"


.joystick
._joystick
	;__FASTCALL__ : joystick no. in HL
		
	ld	a,l
	cp	3
	jr	nc,try_keyboard_joystick

        ld      a,14		; set PSG register #14
        out     (PSG_ADDR),a
        in      a,(PSG_DATAIN)		; read value

	dec	l		; Joystick number
	jr	nz,joystick_2

	and	$0F
	ld	d,a
	in      a,(PPI_A)
	and	$10		; Stick #1 Trigger
	or	d

	jr	continue

.joystick_2
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

.continue
        cpl
        and	$1f

;    00fFRLDU	..got from MSX/SVI port
;    --fFUDLR 	..to be converted to

	ld	l,a
	and	@00110000
	ld	d,a	; keep 'Fire buttons'
	
	xor	a
	ld	h,a
	rr	l
	rla
	rr	l
	rla
	rr	l
	rla
	rr	l
	rla
	
	or	d
	ld	l,a
	
	ret

try_keyboard_joystick:
	sub	2	
	jp	joystick_inkey
