SECTION code_l_sccz80_far
PUBLIC  l_far_decptrs

EXTERN  __far_page

; Entry: hl = physical address
;       ebc = logical address
l_far_decptrs:
    push    af
    ld      a,255
    dec     hl
    dec     c
    cp      c
    jr      nz,done
    dec     b
    cp      b
    jr      nz,skiphigh
    dec     e
skiphigh:
    ; We end up repaging every 256 bytes which isn't optimal
    call    __far_page
done:
    pop    af
    ret
