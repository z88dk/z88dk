

SECTION code_clib

INCLUDE "target/msx/def/msxdos2.def"

PUBLIC  getenv_r
PUBLIC  _getenv_r
PUBLIC  asm_getenv_r

EXTERN  MSXDOS
EXTERN  msxdos_error


; char *getenv_r(const char *name, char *buf, size_t len) __smallc;
getenv_r:
_getenv_r:
    pop af ;ret
    pop bc ;len
    pop de ;buf
    pop hl ;name
    push hl
    push de
    push bc
    push af
    ld b,c   ;length
; Entry:
; hl = name
; de = buffer
;  b = buffer length
asm_getenv_r:
    ld c,_GENV
    call MSXDOS
    ld  (msxdos_error),a
    ex  de,hl   ;de = buffer which is preserved
    and  a
    ret  z
    ld hl,0
    ret
