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
; HL points at the little-endian start cluster. The walk stops at
; 0 or at a link that is not a real cluster (end mark, bad mark,
; or a number past n_fatent). L=0 and carry set on success.
_fat_free:
    call    fat_ld32                ;load the start cluster
    call    remove_chain            ;free this chain
    ld      hl,0
    ret     C                       ;chain is free
    inc     l
    ret
