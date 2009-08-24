; int isoob(int)
; 08.2009 aralbrec

XLIB isoob
LIB asm_isoob

; FASTCALL

.isoob

   ld a,l
   call asm_isoob
   ld hl,0
   ret nz
   inc l
   ret
