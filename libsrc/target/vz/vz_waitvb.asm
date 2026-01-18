;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Jason Oakley
;       Wait for Vertical Blank 
;
;*****************************************************

; ----- void __FASTCALL__ vz_waitvb(void)

    SECTION code_clib
    PUBLIC  vz_waitvb
    PUBLIC  _vz_waitvb

vz_waitvb:
_vz_waitvb:

vbloop: 
    ld a, ($6800)
    rla
    jr nc,vbloop
vbloop2:
    ld a, ($6800)
    rla
    jr c,vbloop2    
vbloop3: 
    ld a, ($6800)
    rla
    jr nc,vbloop3   
    ret
