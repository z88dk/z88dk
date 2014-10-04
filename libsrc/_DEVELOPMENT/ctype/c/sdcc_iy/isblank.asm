
; int isblank(int c)

SECTION seg_code_ctype

PUBLIC _isblank

EXTERN asm_isblank, error_znc

_isblank:

   pop af
   pop hl
   
   push hl
   push af

   inc h
   dec h
   jp nz, error_znc

   ld a,l
   call asm_isblank
   
   ld l,h
   ret nz
   
   inc l
   ret
