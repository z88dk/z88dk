;
; fat_clusters: round a byte length up to whole clusters.
; A pointer argument is __z88dk_fastcall (HL).
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _fat_clusters

EXTERN  _cpm_fat_vol
EXTERN  fat_ld32
EXTERN  fat_st32

; Round *HL bytes up to whole clusters. csize is 2^n.
; Out: that count, or 0 if csize is 0, bytes is 0, or the sum wraps.
; Shift is 9+log2(csize) and at most 16, so the mask fits in 16 bits.
_fat_clusters:
    push    hl
    ld      a,(_cpm_fat_vol+1)
    or      a
    jp      Z,fc_z1                 ;csize is 0
    ld      b,9
fc_log:
    rrca                            ;walk the one bit of csize
    jp      C,fc_have               ;that bit is the shift count
    inc     b
    jp      fc_log
fc_have:
    ld      c,b                     ;C = shift
    ld      hl,0
fc_mask:
    add     hl,hl                   ;mask = (mask<<1) + 1
    inc     hl                      ;(1<<shift)-1
    dec     b
    jp      NZ,fc_mask              ;mask bits left
    push    hl                      ;mask
    push    bc                      ;shift in C
    ld      hl,4
    add     hl,sp                   ;saved pointer
    ld      a,(hl+)
    ld      h,(hl)
    ld      l,a
    call    fat_ld32                ;BCDE = bytes
    ld      a,b
    or      c
    or      d
    or      e
    jp      Z,fc_z3                 ;file size is 0
    ld      hl,2
    add     hl,sp                   ;mask
    ld      a,e
    add     a,(hl+)                 ;bytes + (cluster-1) mask
    ld      e,a
    ld      a,d
    adc     a,(hl)
    ld      d,a
    ld      a,c
    adc     a,0
    ld      c,a
    ld      a,b
    adc     a,0
    ld      b,a
    jp      C,fc_z3                 ;round-up wrapped
fc_shr:
    or      a                       ;clear C; count >>= 1 via rra
    ld      a,b
    rra
    ld      b,a
    ld      a,c
    rra
    ld      c,a
    ld      a,d
    rra
    ld      d,a
    ld      a,e
    rra
    ld      e,a
    ld      hl,0
    add     hl,sp
    dec     (hl)                    ;shift--
    jp      NZ,fc_shr               ;shifts left
    pop     hl
    pop     hl
    pop     hl
    jp      fat_st32
fc_z3:
    ld      bc,0
    ld      de,0
    pop     hl
    pop     hl
    pop     hl
    jp      fat_st32
fc_z1:
    ld      bc,0
    ld      de,0
    pop     hl
    jp      fat_st32
