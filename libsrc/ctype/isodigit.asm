; isodigit

XLIB isodigit
LIB asm_isodigit

; FASTCALL

.isodigit

   ld a,l
   call asm_isodigit
   ld hl,0
   ret c
   inc l
   ret
