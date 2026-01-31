;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Jason Oakley 
;       vz_coarsescroll(addr startlocation, int height)
;       Performs a by-4-pixel scroll to the left of height rows 
;       Without wrap-around.
;*****************************************************

; ----- void __CALLEE__ vz_coarsescroll_callee(void *addr, char byte)

    SECTION code_clib
    PUBLIC  vz_coarsescroll_callee
    PUBLIC  _vz_coarsescroll_callee
    EXTERN  asm_vz_coarsescroll

vz_coarsescroll_callee:
_vz_coarsescroll_callee:

    pop     af
    pop     bc
    pop     hl
    push    af
    ld      a,c
    ld      b,a

   ;  c = byte
   ; hl = addr

asm_vz_coarsescroll:

    inc hl
    push bc
    push hl
    pop de
    dec de
    ld bc,$001f
    ldir
    dec hl
    ld a,$00
    ld (hl),a
    inc hl
    pop bc
    djnz asm_vz_coarsescroll
    ret