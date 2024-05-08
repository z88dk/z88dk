

SECTION code_l_sccz80_far
PUBLIC __far_start_mixed
PUBLIC __far_end_mixed

INCLUDE "target/sam/def/sam.def"

EXTERN  THIS_FUNCTION_ONLY_WORKS_WITH_ALLRAM_SUBTYPE
defc    __subtype_protection=THIS_FUNCTION_ONLY_WORKS_WITH_ALLRAM_SUBTYPE

; We blend internal and external memoryv into a single 8 bit value
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



; Get the initial banking setting
;
; Exit: a = current bank (or entry value for __far_end)
; Uses; f
__far_start_mixed:
    ld     a,(__sam_last_banking)
    ret

; Restore banking setting
; Entry: a = bank to page in
; Uses: f
__far_end_mixed:
    ld      (__sam_last_banking),a
    bit     7,a
    jr      z,end_internal
    push    bc
    ld      c,a
    rlca
    and     %11111110
    ; Set the external banks used
    out     (LEPR),a
    inc     a
    out     (HEPR),a
    ; And indicate that we want to use external memory
    in      a,(HMPR)
    set     7,a
    out     (HMPR),a
    ld      a,c
    pop     bc
    ret
end_internal:
    out     (HMPR),a
    ret

    SECTION bss_driver
    ; BSS driver to ensure it ends up in low memory
__sam_last_banking:	defb   0

    SECTION code_crt_init

    in      a,(HMPR)
    ld      (__sam_last_banking),a
