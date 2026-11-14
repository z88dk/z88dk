;
; fat_next: store the next cluster of a chain.
; A pointer argument is __z88dk_fastcall (HL).
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _fat_next

EXTERN  fat_ld32
EXTERN  fat_st32
EXTERN  fat_sthl
EXTERN  get_fat
EXTERN  pack_sv

; Store the next cluster of a chain.
; An end mark is stored as $0FFFFFFF.
; FAT16 end marks are $FFF8 to $FFFF.
; FAT32 end marks from $0FFFFFF8 fold to the same value.
; A chain that points at itself fails.
; Call. HL points at a little-endian cluster.
; Return. L = 0 and H = 0 when the next cluster is stored.
; Return. Carry follows the last unequal cp. fat_st32 does not change flags.
; Return. The later ld does not change flags.
; Return. L = 1 and H = 0 on a disk error or a self link. Carry is clear.
; Writes. On success the dword becomes the next cluster.
; Return. The dword stays unchanged on failure.
; Clobber. AF, BC, DE, HL.
_fat_next:
    push    hl
    call    fat_ld32                        ; cluster into BCDE
    push    de
    push    bc
    push    de
    ld      de,hl
    pop     hl
    call    fat_sthl
    defw    pack_sv
    pop     hl
    push    hl
    call    fat_sthl
    defw    pack_sv+2
    pop     bc
    pop     de
    call    get_fat                         ; next link. Carry clear means an error.
    pop     hl
    jr      NC,fat_next_fail                ; disk error. Leave the dword.
    ld      a,(pack_sv)
    cp      e                               ; caller byte 0 vs next
    jr      NZ,fat_next_store               ; not a self link
    ld      a,(pack_sv+1)
    cp      d                               ; caller byte 1 vs next
    jr      NZ,fat_next_store               ; not a self link
    ld      a,(pack_sv+2)
    cp      c                               ; caller byte 2 vs next
    jr      NZ,fat_next_store               ; not a self link
    ld      a,(pack_sv+3)
    cp      b                               ; caller byte 3 vs next
    jr      Z,fat_next_fail                 ; chain points at itself
fat_next_store:
    call    fat_st32                        ; store the next cluster
    ld      hl,0                            ; L = 0. ld does not change flags.
    ret
fat_next_fail:
    ld      hl,1                            ; L = 1. Carry stays clear.
    ret
