;
;	Game device library for the MSX
;       Stefano Bodrato - 3/12/2007
;
;	$Id: joystick.asm,v 1.2 2009-01-23 08:22:27 stefano Exp $
;

        XLIB    joystick
        LIB	msxbios

	INCLUDE "#msxbios.def"

.joystick
	;__FASTALL__ : joystick no. in HL
		
	ld	a,l

        dec	a
        jr      nz,no_cursor

        ld      a,$08
	
	;ld	ix,SNSMAT
	;call	msxbios

	in	a,($AA)
	and	$F0
	or	8		; keyboard row number
	out	($AA),a
	in	a,($A9)


;    RDUL---F	..got from MSX port
;    ---FUDLR 	..to be converted to

	cpl

	ld	l,a	; keep 'F'
	rla
	rr	e	; R
	rla
	rr	d	; D
	rla
	rr	c	; U
	rla
	rr	b	; L

	ld	a,l
	rl	c	; U
	rla
	rl	d	; D
	rla
	rl	b	; L
	rla
	rl	e	; R
	rla
	
	;; and	$1F	; commented out: let's keep extra fire buttons !

	ld	l,a
	ld	h,0
	ret



.no_cursor

	ld	e,a
        di

        ld      a,15		; set PSG register #15
        out     ($A0),a
        in      a,($A2)		; read value

	dec	e		; Joystick number
	jr	z,joystick_2

	and @11011111
	or  @01001100

	jr	joystick_1

.joystick_2

	and @10101111
	or  @00000011

.joystick_1

        ; we still have PSG register #15 set
        out     ($A1),a

        ld      a,14		; set PSG register #14
        out     ($A0),a
        in      a,($A2)		; read value

        ei

        cpl
        
        and	$1f

;    00fFRLDU	..got from MSX port
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

