SECTION   code_clib
PUBLIC    rename
PUBLIC    _rename
PUBLIC    ___rename

EXTERN  __agon_hl24
EXTERN  __agon_de24

INCLUDE "target/agon/def/mos_api.inc"

;int rename(char *s1,char *s2)
;on stack:
;return address,s2,s1
;s1=orig filename, s2=dest filename

.rename
._rename
.___rename
    push	ix
    ld      ix,4
    add     hl,sp
    defb    $dd, $17, $00       ;ld de,(ix+0)
    call    __agon_de24
    defb    $dd, $27, $02       ;ld hl,(ix+2)
    call    __agon_hl24
    MOSCALL(mos_ren);
    pop     ix
    ld      hl,0
    and     a
    ret     z
    dec     hl
    ret
