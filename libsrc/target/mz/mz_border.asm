; 03.2022 stefano

; void __FASTCALL__ mz_border(uchar colour)

SECTION code_clib
PUBLIC mz_border
PUBLIC _mz_border


mz_border:
_mz_border:
   LD     BC,$6CF
   OUT    (C),L
   RET
