
; int toupper(int c)

XLIB toupper

LIB asm_toupper

toupper:

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
