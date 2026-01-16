
; int iscntrl_fastcall(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _iscntrl_fastcall

EXTERN asm_iscntrl, error_znc

_iscntrl_fastcall:

   inc h
   dec h
   jp nz, error_znc

   ld a,l
   call asm_iscntrl
   
   ld l,h
   ret nc
   
   inc l
   ret
