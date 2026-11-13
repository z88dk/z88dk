;
; fat_free: free a cluster chain.
; A pointer argument is __z88dk_fastcall (HL).
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _fat_free

EXTERN  fat_ld32
EXTERN  remove_chain

; Free a whole chain.
; The walk stops at 0 or at a link that is not a real cluster.
; Call. HL points at the little-endian start cluster.
; Return. L = 0 and H = 0 when the chain is free. Carry is set.
; Return. L = 1 and H = 0 when the free fails. Carry is clear.
; Clobber. AF, BC, DE, HL.
_fat_free:
    call    fat_ld32                ;start cluster into BCDE
    call    remove_chain            ;free until 0 or a non-cluster
    ld      hl,0                    ;ld does not change flags
    ret     C                       ;chain is free
    inc     l                       ;L = 1. inc does not change carry.
    ret
