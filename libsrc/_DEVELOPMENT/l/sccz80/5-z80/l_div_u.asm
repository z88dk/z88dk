;
; Z88 Runtime library
;
; Moved from z88_crt0.asm to library function
;
; This is the unsigned routine...disregards signs and just does it..

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_div_u

EXTERN l_divu_16_16x16

; unsigned division
; hl = de/hl, de = de%hl

defc l_div_u = l_divu_16_16x16 - 1
