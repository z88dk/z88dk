
; int isblank_fastcall(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isblank_fastcall

EXTERN asm_isblank, error_znc

_isblank_fastcall:

   inc h
   dec h
   jp nz, error_znc

   ld a,l
   call asm_isblank
   
   ld l,h
   ret nz
   
   inc l
   ret
