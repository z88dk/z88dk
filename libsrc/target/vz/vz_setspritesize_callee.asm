;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Jason Oakley 
;       vz_setspritesize(int width, int height)
;       Required before drawing sprites.
;*****************************************************

; ----- void __CALLEE__ vz_setspritesize(char byte, char byte)

    SECTION code_clib
    PUBLIC  vz_setspritesize_callee
    PUBLIC  _vz_setspritesize_callee
    EXTERN  vz_setspritesize
    EXTERN  vz_sprite_width
    EXTERN  vz_sprite_height
    EXTERN  vz_sprite_datasize

vz_setspritesize_callee:
_vz_setspritesize_callee:

    pop     af
    pop     bc
    pop     de
    push    af

   ;  c = height byte
   ;  e = width byte

asm_vz_setspritesize:
    ld  a,e
    ld hl,vz_sprite_width
    ld (hl),a
    ld a,c
    ld hl,vz_sprite_height
    ld (hl),a
; Multiply de * c (a)
Mult12R:
    ld hl,0
Mult12R_Loop:
    srl a
    jr nc,Mult12R_NoAdd
    add hl,de
Mult12R_NoAdd:
    sla e
    rl d
    or a
    jp nz,Mult12R_Loop
    ld (vz_sprite_datasize),hl
    ret    

vz_sprite_width:
    defb    $00
vz_sprite_height:
    defb    $00
vz_sprite_datasize:
    defb    $00
    defb    $00