;
;	Game device library for the Amstrad CPC
;	Stefano Bodrato - May 2008
;
;	$Id: joystick.asm,v 1.5 2016-06-16 20:23:51 dom Exp $
;


        SECTION code_clib
        PUBLIC    joystick
        PUBLIC    _joystick

        INCLUDE "cpcfirm.def"

.joystick
._joystick
	;__FASTALL__ : joystick no. in HL
		
	ld	a,l

	cp	1	 	; Joystick 0
	jr	nz,j_no1

	ld      a,($BD65)
	cp      158		; CPC464 ?
	ld	hl,$b4f4
	jr	z,was_j0
	ld	hl,$b63e
	jr	was_j0
	
.j_no1
	cp	2	 	; Joystick 1
	jr	nz,j_no2

	ld      a,($BD65)
	cp      158		; CPC464 ?
	ld	hl,$b4f1
	jr	z,was_j0
	ld	hl,$b63b

.was_j0
	ld	a,(hl)
	ld      h,a
	rrca
	rrca
	rrca
	rrca	; keep fire1 and fire2
	rr	h	; up
	rla
	rr	h	; down
	rla
	rr	h	; left
	rla
	rr	h	; right
	rla
	jp	j_done
.j_no2
	cp	3	 ; QAOP-MN
	jr	nz,j_no3
	
        call    firmware
        defw    km_read_char
	jr	nc,j_no3
        push	af
        call    firmware
        defw    km_initialise	; clear buffer for next reading
        pop	af

	ld	e,0
	cp	'n'
	jr	nz,nof1
	set	5,e
.nof1	cp	'm'
	jr	nz,nof2
	set	4,e
.nof2	cp	'q'
	jr	nz,noup
	set	3,e
.noup	cp	'a'
	jr	nz,nodn
	set	2,e
.nodn	cp	'o'
	jr	nz,nolf
	set	1,e
.nolf	cp	'p'
	jr	nz,nort
	set	0,e
.nort
	ld	a,e
	jr	j_done
.j_no3
	xor	a
.j_done
	and	$3f
	ld	h,0
	ld	l,a
	ret
