;
;	Game device library for the Enterprise 64/128
;	Stefano Bodrato - Mar 2011
;
;	$Id: joystick.asm,v 1.4 2016-06-16 20:23:51 dom Exp $
;
; MOVE_RIGHT   1
; MOVE_LEFT    2
; MOVE_DOWN    4
; MOVE_UP      8
; MOVE_FIRE   16
; MOVE_FIRE1 MOVE_FIRE
; MOVE_FIRE2  32
; MOVE_FIRE3  64
; MOVE_FIRE4 128


        SECTION code_clib
        PUBLIC    joystick
        PUBLIC    _joystick

        INCLUDE "target/tvc/def/tvc.def"

.joystick
._joystick
	;__FASTALL__ : joystick no. in HL
    
    ; L is 1 or 2
    ; 
    
    ld a,(PORT03)
    and $f0 ; keep using the proper extension socket
    add a,$07
    add a,l
    OUT ($03),a ; select the keyboard row (including joy sense)
    ld c,0
    IN a,($58)  ; let's read back the row - 0 active
;  B7     B6    B5    B4    B3    B2   B1   B0
; ----   LEFT  RIGHT  ACC  FIRE  DOWN  UP  INS
    
    ld b,$02 ; setting b1 in case LEFT
    bit 6,a  ; left
    call z,set_joy_button
    
    ld b,$01 ; setting b0 in case RIGHT
    bit 5,a  ; right
    call z,set_joy_button
    
    ld b,$20 ; setting b5 in case
    bit 4,a  ; accelerator
    call z,set_joy_button
    
    ld b,$10 ; setting b4 in case
    bit 3,a  ; fire
    call z,set_joy_button
    
    ld b,$04 ; setting b2 in case
    bit 2,a  ; down
    call z,set_joy_button
    
    ld b,$08 ; setting b3 in case
    bit 1,a  ; up
    call z,set_joy_button
    
    ld a,(PORT03) ; setting back the keyboard row port
    out ($03),a

	ld	h,0
	ld	l,c
	ret

.set_joy_button
    ld h,a ; save A to H
    ld a,c ; return value is stored in C
    add b  ; adding B
    ld c,a ; storing back A to C
    ld a,h ; restore A from H
    ret
