
; int ispunct(int c)

SECTION code_ctype

PUBLIC _ispunct

EXTERN asm_ispunct, error_zc

_ispunct:

   pop af
   pop hl
   
   push hl
   push af

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_ispunct
   
   ld l,h
   ret c
   
   inc l
   ret
