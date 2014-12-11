
; int toupper(int c)

SECTION code_ctype

PUBLIC _toupper

EXTERN asm_toupper

_toupper:

   pop af
   pop hl
   
   push hl
   push af

   inc h
   dec h
   ret nz

   ld a,l
   call asm_toupper
   
   ld l,a
   ret
