
SECTION code_clib
PUBLIC  remove
PUBLIC  _remove

EXTERN   __agon_hl24

INCLUDE "target/agon/def/mos_api.inc"

;int remove(char *name)

.remove
._remove
    pop     de
    pop     hl      ;filename
    push    hl
    push    de
	push	ix
    call    __agon_hl24
    MOSCALL(mos_del)
    ld      hl,0
    pop     ix
    and     a
    ret     z
    dec     hl      ;=1
    ret

