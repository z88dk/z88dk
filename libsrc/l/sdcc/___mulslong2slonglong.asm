;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;

SECTION code_clib
SECTION code_l_sdcc

PUBLIC ___mulslong2slonglong

EXTERN l0_sdcc_mul_32_32_64

___mulslong2slonglong:

   ; signed 32 x 32 -> 64
   ;
   ; Same stack frame as ___mululong2ulonglong.
   ; Bit 0 of b asks for a sign extend of both factors.

   ld b,1
   jp l0_sdcc_mul_32_32_64
