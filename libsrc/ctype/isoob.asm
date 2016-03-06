; int isoob(int)
; 08.2009 aralbrec

        SECTION code_clib

PUBLIC _isoob
PUBLIC isoob
EXTERN asm_isoob

; FASTCALL

._isoob
.isoob

   ld a,l
   call asm_isoob
   ld hl,0
   ret nz
   inc l
   ret
