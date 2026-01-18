;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Jason Oakley 
;       vz_smoothscroll(addr startlocation, int height)
;       Performs a by-1-pixel scroll to the left of height rows 
;       Without wrap-around.
;*****************************************************

; ----- void __CALLEE__ vz_smoothscroll_callee(void *addr, char byte)

    SECTION code_clib
    PUBLIC  vz_smoothscroll_callee
    PUBLIC  _vz_smoothscroll_callee
    EXTERN  asm_vz_smoothscroll

vz_smoothscroll_callee:
_vz_smoothscroll_callee:

    pop     af
    pop     bc
    pop     hl
    push    af

   ;  c = byte
   ; hl = addr

asm_vz_smoothscroll:
nextline:    
    xor a
    ld b,$20
doscroll:
    rl (hl)
    rla
    rl (hl)
    rra
    dec hl
    djnz doscroll
    ld de,$0040
    add hl,de
    dec c
    jr nz,nextline
    ret