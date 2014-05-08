
; int isbdigit(int c)

PUBLIC _isbdigit

EXTERN asm_isbdigit, error_znc

_isbdigit:

   pop af
   pop hl
   
   push hl
   push af

   inc h
   dec h
   jp nz, error_znc

   ld a,l
   call asm_isbdigit
   
   ld l,h
   ret nz
   
   inc l
   ret
