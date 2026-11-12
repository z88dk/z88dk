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
    call    fat_ld32                ;load the caller cluster
    ld      (pack_sv),de
    ld      (pack_sv+2),bc
    call    get_fat                 ;next link in the chain
    pop     hl
    jr      NC,fat_next_fail        ;FAT read failed
    ld      a,(pack_sv)
    cp      e                       ;next vs caller +0
    jr      NZ,fat_next_store       ;not a self link
    ld      a,(pack_sv+1)
    cp      d                       ;next vs caller +1
    jr      NZ,fat_next_store       ;not a self link
    ld      a,(pack_sv+2)
    cp      c                       ;next vs caller +2
    jr      NZ,fat_next_store       ;not a self link
    ld      a,(pack_sv+3)
    cp      b                       ;next vs caller +3
    jr      Z,fat_next_fail         ;chain points at itself
fat_next_store:
    call    fat_st32                ;store the next cluster
    ld      hl,0
    ret
fat_next_fail:
    ld      hl,1
    ret
