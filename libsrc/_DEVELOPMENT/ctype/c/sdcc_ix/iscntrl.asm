
; int iscntrl(int c)

SECTION code_ctype

PUBLIC _iscntrl

EXTERN asm_iscntrl, error_znc

_iscntrl:

   pop af
   pop hl
   
   push hl
   push af

   inc h
   dec h
   jp nz, error_znc

   ld a,l
   call asm_iscntrl
   
   ld l,h
   ret nc
   
   inc l
   ret
