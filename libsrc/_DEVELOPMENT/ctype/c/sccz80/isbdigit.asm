
; int isbdigit(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC isbdigit

EXTERN asm_isbdigit, error_znc

isbdigit:

   inc h
   dec h
   jp nz, error_znc

   ld a,l
   call asm_isbdigit
   
   ld l,h
   ret nz
   
   inc l
   ret
