;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Jason Oakley
;       Set address of byte array sprite data
;*****************************************************

; ----- int vz_setspritedata(&addr)

    SECTION code_clib
    PUBLIC  vz_setspritedata
    PUBLIC  _vz_setspritedata
    EXTERN  vz_spritedata

vz_setspritedata:
_vz_setspritedata:
    ld (vz_spritedata),hl
    ret
    
    SECTION bss_clib
vz_spritedata:
    defb    $00
    defb    $00
