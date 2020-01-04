; Game device library for the CCE MC-1000.
; Emerson José Silveira da Costa - 2013-03-11.
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
    ld    b,@11111101    ; Keyboard line selector.
    ; Keyboard line data: --FRLDU-.
    ld    c,@00100000    ; Fire key position.
    jr    j_p

.j_p2
    ; Player 2's joystick.
    ld    b,@11111110    ; Keyboard line selector.
    ; Keyboard line data: ---RLDUF.
    ld    c,@00000001    ; Fire key position.

.j_p
    di
    ld    a,14    ; Select AY-3-8910's IOA register.
    out    ($20),a
    ld    a,b    ; Select keyboard line via IOA.
    out    ($60),a
    ld    a,15    ; Select AY-3-8910's IOB register.
    out    ($20),a
    in    a,($40)    ; Get keyboard line data via IOB.
    ei
    cpl    ; In original data bits 0 represent keypress. Invert.
    ld    b,a
    ; Transfer fire to bit 0.
    and   c    ; Fire pressed?
    jr    z,j_nofire
    set    0,b
    jr    j_reverse
.j_nofire
    res    0,b
.j_reverse
    ; Register B now contains ---RLDUF.
    ; Transfer to A in reverse order: ---FUDLR.
    xor    a
    rr    b
    rla
    rr    b
    rla
    rr    b
    rla
    rr    b
    rla
    rr    b
    rla
    jr    j_done

.j_nop
    xor    a
.j_done
    ld    l,a
    ld    h,0
    ret
