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
        EXTERN    l_push_di
        EXTERN    l_pop_ei

        INCLUDE "target/tvc/def/tvc.def"

.joystick
._joystick
	;__FASTALL__ : joystick no. in HL
    
    ; L is 1 or 2
    ; 
    
    call l_push_di  ; let's not allow interrupt, port is written, read..
    ld   a,(PORT03)
    and  $c0        ; keep the proper expansion socket (upper 2 bits)
    add  a,$07
    add  a,l
    out  ($03),a    ; select the keyboard row (including joy sense)
    in   a,($58)    ; let's read back the columns in the row - 0 active
    ld   d,a        ; store in C
    ld   a,(PORT03) ; setting back the keyboard row port
    out  ($03),a
    call l_pop_ei   ; port is set back, interrupt is OK now.
    ld   a,d
    ld   c,0

    
;  B7     B6    B5    B4    B3    B2   B1   B0
; ----   LEFT  RIGHT  ACC  FIRE  DOWN  UP  INS
    
    ld   b,$02 ; setting b1 in case LEFT
    bit  6,a   ; left
    call z,set_joy_button
    
    ld   b,$01 ; setting b0 in case RIGHT
    bit  5,a   ; right
    call z,set_joy_button
    
    ld   b,$20 ; setting b5 in case
    bit  4,a   ; accelerator
    call z,set_joy_button
    
    ld   b,$10 ; setting b4 in case
    bit  3,a   ; fire
    call z,set_joy_button
    
    ld   b,$04 ; setting b2 in case
    bit  2,a   ; down
    call z,set_joy_button
    
    ld   b,$08 ; setting b3 in case
    bit  1,a   ; up
    call z,set_joy_button
    
    ld   h,0
    ld   l,c
    ret

.set_joy_button
    ld  a,c  ; return value is stored in C
    add b    ; adding B
    ld  c,a  ; storing back A to C
    ld  a,d  ; restore A from D
    ret
