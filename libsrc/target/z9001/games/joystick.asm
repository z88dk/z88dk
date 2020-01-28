; Game device library for the Robotron Z9001
; Stefano Bodrato, Sept. 2016
;
; ---FUDLR  Stick bit pattern (nc, nc, nc, fire, up, down, left, right)
;

    SECTION code_clib
    PUBLIC    joystick
    PUBLIC    _joystick

.joystick
._joystick

    ; __FASTCALL__ : joystick no. in HL.
    ; 1 = Player 1's joystick.
    ; 2 = Player 2's joystick.

    ld    a,l
    cp    1
    jr    z,j_p1
    cp    2
    jr    z,j_p2
    jr    j_nop


.j_p1
    ; Player 1's joystick.
	ld	a,($13)
	jr	jpp
	

.j_p2
    ; Player 2's joystick.
	ld	a,($14)
	jr	jpp
	

.jpp
;  ---FUDLR -> ---FUDRL

	rra
	rr e
	rra
	rr b
	rl e	; L
	rla
	rl b	; R
	rla
	
	jr    j_done
	
.j_nop
    xor   a
.j_done
    ld    l,a
    ld    h,0
    ret
