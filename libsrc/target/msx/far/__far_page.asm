SECTION code_l_sccz80_far
PUBLIC  __far_page

EXTERN  PUT_P2
EXTERN  __far_map_bank

; Entry: ebc = logical address
;         a' = local memory page
; Exit:   hl = physical address to access (bank paged in)
;        ebc = logical address
;
; Corrupts: d,a
__far_page:
    ld      a,e        ;With e=0 it refers to local memory
    and     a
    jr      z,localfar
    ld      d,e
    dec     d
    ld      a,b
    rla
    rl      d
    rla
    rl      d
    ; e is now which bank we should look at
    ld      a,b
    and     @00111111      ;Take mod 16384
    or      @10000000	;Map to 0x8000 page
    ld      h,a
    ld      l,c
    jp      __far_map_bank

localfar:
    ex     af,af
    ld     d,a
    call   PUT_P2
    ld     a,d
    ex     af,af
    ld     hl,bc
    ret
