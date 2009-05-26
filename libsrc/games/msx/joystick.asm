;
;	Game device library for the MSX
;       Stefano Bodrato - 3/12/2007
;
;	$Id: joystick.asm,v 1.4 2009-05-26 20:38:11 stefano Exp $
;

        XLIB    joystick
        LIB	msxbios

IF FORmsx
        INCLUDE "#msx.def"
ELSE
        INCLUDE "#svi.def"
ENDIF

.joystick
	;__FASTCALL__ : joystick no. in HL
		
	ld	a,l

        dec	a
        jr      nz,no_cursor

        ld      a,$08
	
	;ld	ix,SNSMAT
	;call	msxbios

	in	a,(PPI_C)
	and	$F0
	or	8		; keyboard row number
	out	(PPI_C),a
	in	a,(PPI_B)


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

;;  Exclude Joystick selection on Spectravideo,
;;  reg #15 has other uses and would crash everything.

IF FORmsx
        ld      a,15		; set PSG register #15
        out     (PSG_ADDR),a
        in      a,(PSG_DATAIN)		; read value

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
        out     (PSG_DATA),a
ENDIF

        ld      a,14		; set PSG register #14
        out     (PSG_ADDR),a
        in      a,(PSG_DATAIN)		; read value

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

