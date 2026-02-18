;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Jason Oakley 
;       vz_smoothscroll_wrap_l(addr startlocation, int height)
;       Performs a by-1-pixel scroll to the left of height rows 
;       With wrap-around. startlocation is left-most byte onscreen.
;*****************************************************

; ----- void __CALLEE__ vz_smoothscroll_wrap_l_callee(void *addr, char byte)

    SECTION code_clib
    PUBLIC  vz_smoothscroll_wrap_l_callee
    PUBLIC  _vz_smoothscroll_wrap_l_callee
    EXTERN  asm_vz_smoothscroll_wrap_l

vz_smoothscroll_wrap_l_callee:
_vz_smoothscroll_wrap_l_callee:

    pop     af
    pop     bc
    pop     hl
    push    af

   ;  c = byte
   ; hl = addr

asm_vz_smoothscroll_wrap_l:
nextlineWL:
    xor a
    ld b,$20
doscrollWL:
    rl (hl)
    rla
    rl (hl)
    rra
    dec hl
    djnz doscrollWL
    ld de,$0020
    add hl,de
    ld d,a
    rl (hl)
    rla
    rl (hl)
    rra
    ld a,(hl)
    and d
    ld (hl),a
    ld de,$0020
    add hl,de
    dec c
    jr nz,nextlineWL
    ret