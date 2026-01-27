;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Jason Oakley 
;       vz_coursescroll(addr startlocation, int height)
;       Performs a by-4-pixel scroll to the left of height rows 
;       Without wrap-around.
;*****************************************************

; ----- void __CALLEE__ vz_coursescroll_callee(void *addr, char byte)

    SECTION code_clib
    PUBLIC  vz_coursescroll_callee
    PUBLIC  _vz_coursescroll_callee
    EXTERN  asm_vz_coursescroll

vz_coursescroll_callee:
_vz_coursescroll_callee:

    pop     af
    pop     bc
    pop     hl
    push    af
    ld      a,c
    ld      b,a

   ;  c = byte
   ; hl = addr

asm_vz_coursescroll:
cscroll: 
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
    djnz cscroll