SECTION code_l_sccz80_far
PUBLIC  __far_page
EXTERN  __far_end

INCLUDE "target/aquarius/def/aqplus.def"

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
    or      @11000000	   ;Map to 0xc000 page
    ld      h,a
    ld      l,c
    ; hl = offset within bank
    ld      a,d
    add     AQPLUS_FIRST_BANK	;0x01xxxx starts at AQPLUS_FIRST_BANK
    out     (PORT_BANK3),a
    ret

localfar:
    ex     af,af
    out    (PORT_BANK3),a
    ex     af,af
    ld     hl,bc
    ret
