;
; Z88 Runtime library
;
; Moved from z88_crt0.asm to library function
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_div

EXTERN l_divs_16_16x16

; signed division
; hl = de/hl, de = de%hl

defc l_div = l_divs_16_16x16 - 1
