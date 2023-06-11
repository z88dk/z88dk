SECTION  code_clib
PUBLIC   mkdir
PUBLIC   _mkdir
EXTERN  __agon_hl24
INCLUDE "target/agon/def/mos_api.inc"

;int mkdir(char *path, mode_t mode)


.mkdir	
._mkdir
    pop	    bc
    pop	    de
    pop	    hl
    push	hl
    push	de
    push	bc
    push	ix	;save callers
    call    __agon_hl24
    MOSCALL(mos_mkdir)
    pop     ix
    ld      hl,0
    and     a
    ret     z
    dec	hl	;-1
    ret

