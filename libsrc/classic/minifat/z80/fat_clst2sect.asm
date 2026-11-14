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

; Store the first sector of a cluster.
; The sector is database + (cluster - 2) * csize.
; A cluster below 2, or at or past n_fatent, has no sector.
; Call. HL points at a little-endian cluster.
; Return. L = 0 and H = 0 when the sector is stored.
; Return. Carry stays set because fat_st32 does not change flags.
; Return. The later ld does not change flags.
; Return. L = 1 and H = 0 when the cluster has no sector. Carry is clear.
; Writes. On success the dword becomes the sector number.
; Return. The dword stays unchanged on failure.
; Clobber. AF, BC, DE, HL.
_fat_clst2sect:
    push    hl
    call    fat_ld32                ;cluster into BCDE
    call    clst2sect               ;sector in BCDE when carry is set
    pop     hl
    jr      NC,fat_c2s_fail         ;cluster below 2 or past n_fatent
    call    fat_st32                ;store that sector
    ld      hl,0                    ;L = 0. ld does not change flags.
    ret
fat_c2s_fail:
    ld      hl,1                    ;L = 1. Carry stays clear.
    ret
