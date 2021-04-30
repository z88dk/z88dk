
SECTION code_clib
PUBLIC sam_set_fatpix
PUBLIC _sam_set_fatpix
EXTERN __sam_MODE3_fatpix

; void sam_set_fatpix(int enable);
sam_set_fatpix:
_sam_set_fatpix:
    pop     bc
    pop     hl
    push    hl
    push    bc
    ld      a,l
    ld      (__sam_MODE3_fatpix),a
    ret
