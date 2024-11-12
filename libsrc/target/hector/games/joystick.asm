;
;       Hector Games Library
;
; 	Joystick 1 on 0x3807
; 	Joystick 2 on 0x3807
;

    SECTION code_clib
    PUBLIC  joystick
    PUBLIC  _joystick

    EXTERN  joystick_sc
    EXTERN  keys_qaop
    EXTERN  keys_8246
    EXTERN  keys_vi

joystick:
_joystick:
	;__FASTALL__ : joystick no. in HL
    ld      a, l
    cp      3
    jr      nc, try_keyboard
    ; Read the hardware joystick here
    ex      af,af
    ld      a,($3807)
    ;bit 0 = j0 left
    ;bit 1 = j0 right
    ;bit 2 = j0 up
    ;bit 3 = j0 down
    ;bit 4 = j1 left
    ;bit 5 = j1 right
    ;bit 6 = j1 up
    ;bit 7 = j1 down
    ex      af,af
    cp      2
    ld      a,($3800)
    cpl
    jr      z,joystick2
joystick1:
    rlca        ;Take space
    rlca
    rlca
    and     16
    ld      c,a
    ex      af,af
    jr      normalise
joystick2:
    rlca        ;Take tab
    and     16
    ld      c,a
    ; Shift joystick one into place
    ex      af,af
    rrca
    rrca
    rrca
    rrca
normalise:
    ; No fire button mapped
    and     15
    ld      e,a
    ld      d,0
    ld      hl,joystick_table
    add     hl,bc
    ld      a,(hl)
    ld      l,a
    ld      h,0
    ret




try_keyboard:
    ld      hl, keys_qaop
    cp      3
    jp      z, joystick_sc
    ld      hl, keys_8246
    cp      4
    jp      z, joystick_sc
    ld      hl, keys_vi
    cp      5
    jp      z, joystick_sc
    ld      hl, 0
    ret


    SECTION data_clib

joystick_table:
    defb    @0000                       ;Nothing pressed
    defb    @0010			;LEFT
    defb    @0001			;RIGHT
    defb    @0011			;LEFT + RIGHT
    defb    @1000			;UP
    defb    @1010			;UP + LEFT
    defb    @1001			;UP + RIGHT
    defb    @1011			;UP + LEFT + RIGHT
    defb    @0100			;DOWN
    defb    @0110			;DOWN + LEFT
    defb    @0101			;DOWN + RIGHT
    defb    @0111			;DOWN + LEFT + RIGHT
    defb    @1100			;DOWN + UP
    defb    @1110			;DOWN + UP + LEFT
    defb    @1101			;DOWN + UP + RIGHT
    defb    @1111			;DOWN + UP + LEFT + RIGHT
