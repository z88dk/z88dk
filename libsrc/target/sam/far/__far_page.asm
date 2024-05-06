SECTION code_l_sccz80_far
PUBLIC  __far_page
EXTERN  __far_end

EXTERN __sam_bank_mappings

INCLUDE "target/sam/def/sam.def"

EXTERN  THIS_FUNCTION_ONLY_WORKS_WITH_ALLRAM_SUBTYPE
defc    __subtype_protection=THIS_FUNCTION_ONLY_WORKS_WITH_ALLRAM_SUBTYPE


; This routine only addresses internal memory
;
;
; For external memory, we'll do something like this:
;
; Bit 7 = 1
; Bit 6->5 = external interface
; Bit 4->0 = 31 pages (shifted right, so we lose lsb, no hassle since we bank in pairs)
; 
; Internal (regular value of HMPR (bit 7 = 0)
;
;
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
    ; d is now which bank we should look at
    ld      a,b
    and     @01111111      ;Take mod 32768
    or      @10000000	;Map to 0x8000 page
    ld      h,a
    ld      l,c
    ; hl = offset within bank
    push    hl
    push    de
    ld      hl,__sam_bank_mappings 
    ld      e,d
    ld      d,0
    add     hl,de
    ld      a,(hl)
    out     (HMPR),a
    pop     de
    pop     hl
    ret

localfar:
    ex     af,af
    out    (HMPR),a
    ex     af,af
    ld     hl,bc
    ret
