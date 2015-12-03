
; int isbdigit_fastcall(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isbdigit_fastcall

EXTERN asm_isbdigit, error_znc

_isbdigit_fastcall:

   inc h
   dec h
   jp nz, error_znc

   ld a,l
   call asm_isbdigit
   
   ld l,h
   ret nz
   
   inc l
   ret
