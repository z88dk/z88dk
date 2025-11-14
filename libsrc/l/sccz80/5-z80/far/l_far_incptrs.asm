SECTION code_l_sccz80_far
PUBLIC  l_far_incptrs

EXTERN  __far_page

; Entry: hl = physical address
;       ebc = logical address
l_far_incptrs:
    inc     hl
    inc     c
    ret     nz
    inc     b
    jr      nz,skiphigh
    inc     e
skiphigh:
    ; We end up repaging every 256 bytes which isn't optimal
    push    af
    call    __far_page
    pop    af
    ret
