SECTION code_l_sccz80
PUBLIC  __msx_incptr

EXTERN  __msx_virt2log_page

; Entry: hl = physical address
;       ebc = logical address
__msx_incptr:
    inc     hl
    inc     c
    ret     nz
    inc     b
    jr      nz,skiphigh
    inc     e
skiphigh:
    ; We end up repaging every 256 bytes which isn't optimal§
    push    af
    call    __msx_virt2log_page
    pop    af
    ret
