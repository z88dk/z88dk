SECTION code_l_sccz80_far
PUBLIC  __far_page

EXTERN  PUT_P2
EXTERN  __msx_bank_mappings

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
    ; hl = offset within bank
    push    hl
    push    de
    ld      hl,__msx_bank_mappings + 1
    ld      e,d
    ld      d,0
    add     hl,de
    ld      a,(hl)
    call    PUT_P2
    pop     de
    pop     hl
    ret

localfar:
    ex     af,af
    ld     d,a
    call   PUT_P2
    ld     a,d
    ex     af,af
    ld     hl,bc
    ret
