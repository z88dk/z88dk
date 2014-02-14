
; int tolower(int c)

XLIB tolower

LIB asm_tolower

tolower:

   pop af
   pop hl
   
   push hl
   push af

   inc h
   dec h
   ret nz

   ld a,l
   call asm_tolower
   
   ld l,a
   ret
