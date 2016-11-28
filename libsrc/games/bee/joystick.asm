;
;	Game device library for the MicroBEE
;       Stefano Bodrato - 11/2016
;
;	$Id: joystick.asm,v 1.2 2016-11-28 07:33:11 stefano Exp $
;

	SECTION code_clib
        PUBLIC    joystick
        PUBLIC    _joystick



.joystick
._joystick
	;__FASTCALL__ : joystick no. in HL
		
	ld	a,l

	dec	a
	jp  z,arrows
	
	dec a
	jp  z,tc256
	
	dec	a
	ret      nz

; "Home Made" Joystick
	ld a,255
	out (1),a
	in a,(0)

	ld b,0
	
	xor 255
	rlca
	rrca
	rl b	;fire
	
	rra
	rl b
	rra
	rl b
	rra
	rl b
	rra
	rl b
.nofr

	ld	h,0
	ld	l,b
	
	ret

	
; MOVE_RIGHT 1
; MOVE_LEFT  2
; MOVE_DOWN  4
; MOVE_UP    8
; MOVE_FIRE  16
; MOVE_FIRE1 MOVE_FIRE
; MOVE_FIRE2 32
; MOVE_FIRE3 64
; MOVE_FIRE4 128

.arrows
	LD      B,A			; zero
	LD      A,37h           ; Space key (fire)
	CALL    isKeyDown
	JR      NZ,nofire
	SET     4,B
.nofire
    LD      A,3eh           ; Right arrow
	CALL    isKeyDown
	JR      NZ,noright
	SET     0,B
.noright
    LD      A,3bh           ; Left arrow
	CALL    isKeyDown
	JR      NZ,noleft
	SET     1,B
.noleft
    LD      A,3ah           ; Down arrow
	CALL    isKeyDown
	JR      NZ,nodown
	SET     2,B
.nodown
    LD      A,38h           ; Up arrow
	CALL    isKeyDown
	JR      NZ,noup
	SET     3,B
.noup

	ld	h,0
	ld	l,b
	
	ret


	
        ; --- START PROC isKeyDown ---
isKeyDown:  PUSH    BC
        LD      C,A
        LD      B,A
        LD      A,12h
        OUT     (0Ch),A
        LD      A,B
        RRCA
        RRCA
        RRCA
        RRCA
        AND     03h
        OUT     (0Dh),A
        LD      A,13h
        OUT     (0Ch),A
        LD      A,B
        RLCA
        RLCA
        RLCA
        RLCA
        OUT     (0Dh),A
        LD      A,01h
        OUT     (0Bh),A
        LD      A,10h
        OUT     (0Ch),A
        IN      A,(0Dh)
        LD      A,1Fh
        OUT     (0Ch),A
        OUT     (0Dh),A
L095D:  IN      A,(0Ch)
        BIT     7,A
        JR      Z,L095D
        IN      A,(0Ch)
        CPL
        BIT     6,A
        LD      A,00h
        OUT     (0Bh),A
        LD      A,C
        POP     BC
        RET


.tc256
	LD      B,A		; zero
	LD      C,37h           ; Space key (fire)
	LD		A,15
	PUSH	BC
	RST		28h
	POP		BC
	JR      NZ,tc_nofire
	SET     4,B
.tc_nofire
    LD      C,3eh           ; Right arrow
	LD		A,15
	PUSH	BC
	RST		28h
	POP		BC
	JR      NZ,tc_noright
	SET     0,B
.tc_noright
    LD      C,3bh           ; Left arrow
	LD		A,15
	PUSH	BC
	RST		28h
	POP		BC
	JR      NZ,tc_noleft
	SET     1,B
.tc_noleft
    LD      C,3ah           ; Down arrow
	LD		A,15
	PUSH	BC
	RST		28h
	POP		BC
	JR      NZ,tc_nodown
	SET     2,B
.tc_nodown
    LD      C,38h           ; Up arrow
	LD		A,15
	PUSH	BC
	RST		28h
	POP		BC
	JR      NZ,tc_noup
	SET     3,B
.tc_noup

	ld	h,0
	ld	l,b
	
	ret
