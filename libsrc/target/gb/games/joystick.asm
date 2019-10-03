
    SECTION code_driver
    PUBLIC  joystick
    PUBLIC  _joystick

    EXTERN	asm_jpad

; int joystick(int device) __z88dk_fastcall;
joystick:
_joystick:
    call    asm_jpad
    ; a = controls
    ;;   0x80 - Start   0x08 - Down
    ;;   0x40 - Select  0x04 - Up
    ;;   0x20 - B       0x02 - Left
    ;;   0x10 - A       0x01 - Right
    ; We need to swap over Down and Up
    ld      l,a         ;Save original value
    and     @11110011   ;Mask out up/down
    bit     2,l
    jr      z,check_down
    set     3,a
check_down:
    bit     3,l
    jr      z,return
    set     2,a
return:
    ld      l,a
    ld      h,0
    ld      e,a		;And into de for sdcc compiles
    ld      d,h
    ret


