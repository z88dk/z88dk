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

; Round a byte length up to whole clusters.
; csize is 2^n.
; The shift is 9 + log2(csize) and at most 16.
; The mask fits in 16 bits.
; Call. HL points at a little-endian byte length.
; Return. No status. The count is stored through the pointer.
; Return. The count is 0 when csize is 0, the length is 0, or the sum wraps.
; Writes. The rounded count replaces the byte length.
; Clobber. AF, BC, DE, HL.
_fat_clusters:
    push    hl
    ld      a,(_cpm_fat_vol+1)              ; csize
    or      a
    jr      Z,fc_z1                         ; csize is 0
    ld      b,9                             ; a sector is 2^9 bytes
fc_log:
    rrca
    jr      C,fc_have                       ; that bit is the shift count
    inc     b
    jr      fc_log
fc_have:
    ld      c,b                             ; C holds the shift
    ld      hl,0
fc_mask:
    add     hl,hl
    inc     hl                              ; (1 << shift) - 1
    dec     b
    jr      NZ,fc_mask                      ; mask bits left
    push    hl                              ; mask
    push    bc                              ; shift in C
    ld      hl,4
    add     hl,sp                           ; saved pointer
    ld      a,(hl+)
    ld      h,(hl)
    ld      l,a
    call    fat_ld32                        ; BCDE = byte length
    ld      a,b
    or      c
    or      d
    or      e
    jr      Z,fc_z3                         ; file size is 0
    ld      hl,2
    add     hl,sp                           ; mask
    ld      a,e
    add     a,(hl+)                         ; length + mask
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
    jr      C,fc_z3                         ; round-up wrapped
fc_shr:
    or      a                               ; clear carry before the shift
    ld      a,b
    rra                                     ; length >> 1
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
    add     hl,sp                           ; shift count on the stack
    dec     (hl)                            ; one less shift
    jr      NZ,fc_shr                       ; shifts left
    pop     hl
    pop     hl
    pop     hl
    jp      fat_st32                        ; store the count
fc_z3:
    ld      bc,0
    ld      de,0
    pop     hl
    pop     hl
    pop     hl
    jp      fat_st32                        ; store 0
fc_z1:
    ld      bc,0
    ld      de,0
    pop     hl
    jp      fat_st32                        ; store 0
