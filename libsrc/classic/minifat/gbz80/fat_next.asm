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

; Next cluster in a chain.
; HL points at a little-endian cluster. On success that dword
; becomes the next cluster and L is 0. An end mark is stored as
; 0x0FFFFFFF (FAT16 $FFF8-$FFFF and FAT32 >= $0FFFFFF8 both fold
; to that value). On a disk error the dword is left alone and L
; is 1. A chain that points at itself fails.
_fat_next:
    push    hl
    call    fat_ld32                ;cluster into BCDE
    push    de
    push    bc
    ex      de,hl
    call    fat_sthl
    defw    pack_sv
    pop     hl
    push    hl
    call    fat_sthl
    defw    pack_sv+2
    pop     bc
    pop     de
    call    get_fat                 ;NC: link unreadable or bad
    pop     hl
    jp      NC,fat_next_fail        ;leave the caller's dword
    ld      a,(pack_sv)
    cp      e                       ;next vs this, byte 0
    jp      NZ,fat_next_store       ;link moved
    ld      a,(pack_sv+1)
    cp      d                       ;next vs this, byte 1
    jp      NZ,fat_next_store       ;link moved
    ld      a,(pack_sv+2)
    cp      c                       ;next vs this, byte 2
    jp      NZ,fat_next_store       ;link moved
    ld      a,(pack_sv+3)
    cp      b                       ;next vs this, byte 3
    jp      Z,fat_next_fail         ;chain points at itself
fat_next_store:
    call    fat_st32                ;store the next cluster
    ld      hl,0
    ret
fat_next_fail:
    ld      hl,1
    ret
