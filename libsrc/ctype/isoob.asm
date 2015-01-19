; int isoob(int)
; 08.2009 aralbrec

PUBLIC isoob
EXTERN asm_isoob

; FASTCALL

.isoob

   ld a,l
   call asm_isoob
   ld hl,0
   ret nz
   inc l
   ret
