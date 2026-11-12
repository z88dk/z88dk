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

; Allocate one cluster by the next-free scan (create_chain).
; HL points at the little-endian cluster to link after. 0 starts
; a new chain. On success the new cluster number replaces that
; dword and L is 0. On failure the dword is unchanged and L is 1.
; The new cluster is marked end-of-chain, then linked from the
; previous one. This is not a search for a hole, so several calls
; can fragment the file. If the second FAT copy cannot be written
; the call still succeeds: the first FAT already holds the link.
_fat_alloc:
    push    hl
    call    fat_ld32                ;cluster to extend
    call    create_chain            ;NC: no free cluster
    pop     hl
    jp      NC,fat_alloc_fail       ;leave the caller's dword
    call    fat_st32                ;store the new cluster
    ld      hl,0
    ret
fat_alloc_fail:
    ld      hl,1
    ret
