;
; fat_clst2sect: store the first sector of a cluster.
; A pointer argument is __z88dk_fastcall (HL).
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _fat_clst2sect

EXTERN  clst2sect
EXTERN  fat_ld32
EXTERN  fat_st32

; First sector of a cluster.
; HL points at a little-endian cluster. On success that same
; dword is overwritten with the LBA, database + (cluster-2)*csize,
; and L is 0. On failure the dword is unchanged and L is 1.
; A cluster below 2, or at or past n_fatent, fails.
_fat_clst2sect:
    push    hl
    call    fat_ld32                ;load the cluster
    call    clst2sect               ;first sector of this cluster
    pop     hl
    jr      NC,fat_c2s_fail         ;cluster has no LBA
    call    fat_st32                ;store that LBA
    ld      hl,0
    ret
fat_c2s_fail:
    ld      hl,1
    ret
