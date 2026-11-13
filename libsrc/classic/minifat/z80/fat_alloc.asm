;
; fat_alloc: allocate one cluster and store its number.
; A pointer argument is __z88dk_fastcall (HL).
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _fat_alloc

EXTERN  create_chain
EXTERN  fat_ld32
EXTERN  fat_st32

; Allocate one cluster and store its number.
; A value of 0 starts a new chain.
; The new cluster is the next free cluster. Repeated calls can fragment the file.
; The new cluster is marked end-of-chain. The previous cluster then links to it.
; A failed second FAT copy still returns the new cluster.
; Call. HL points at the little-endian cluster to link after.
; Return. L = 0 and H = 0 when the new cluster is stored.
; Return. Carry stays set because fat_st32 does not change flags.
; Return. The later ld does not change flags.
; Return. L = 1 and H = 0 when the allocate fails. Carry is clear.
; Writes. On success the dword becomes the new cluster.
; Return. The dword stays unchanged on failure.
; Clobber. AF, BC, DE, HL.
_fat_alloc:
    push    hl
    call    fat_ld32                ;cluster to link after
    call    create_chain            ;new cluster in BCDE on carry
    pop     hl
    jr      NC,fat_alloc_fail       ;no cluster. Leave the dword.
    call    fat_st32                ;store the new cluster
    ld      hl,0                    ;L = 0. ld does not change flags.
    ret
fat_alloc_fail:
    ld      hl,1                    ;L = 1. Carry stays clear.
    ret
