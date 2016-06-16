;
;	Game device library for the MSX
;       Stefano Bodrato - 3/12/2007
;
;	$Id: joystick.asm,v 1.9 2016-06-16 20:23:51 dom Exp $
;

        SECTION code_clib
        PUBLIC    joystick
        PUBLIC    _joystick
        EXTERN	msxbios

IF FORmsx
        INCLUDE "msx.def"
ELSE
        INCLUDE "svi.def"
        INCLUDE "svibios.def"
        EXTERN	svi_kbdstick
ENDIF

.joystick
._joystick
	;__FASTCALL__ : joystick no. in HL
		
	ld	a,l

        dec	a
        jr      nz,no_cursor

IF FORmsx
        ;ld      a,$08
	;ld	ix,SNSMAT
	;call	msxbios

	in	a,(PPI_C)
	and	$f0

	or	8		; Keyboard row #8
	out	(PPI_COUT),a
	in	a,(PPI_B)

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

ELSE
	push	ix		;save callers
	ld	a,1
	ld	($fa19),a ;REPCNT
	
	ld	ix,CHSNS
	call	msxbios
	jr	z,noupdown

	ld	ix,CHGET
	call	msxbios
	
	sub	27
	ld	b,a
	xor	a
	scf
.bitr	rla
	djnz	bitr
	
	ld	b,a
	and	@01100
	ld	a,b
	jr	z,noupdown
	xor	@01100
.noupdown
	pop	ix		;restore callers
	
ENDIF
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

IF FORsvi
	dec	e		; Joystick number
	jr	nz,joystick_2

	and	$0F
	ld	d,a
	in      a,(PPI_A)
	and	$10		; Stick #1 Trigger
	or	d

	jr	joystick_1

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

.joystick_1
ENDIF

        ei

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

