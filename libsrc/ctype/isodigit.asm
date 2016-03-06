; isodigit

        SECTION code_clib

PUBLIC _isodigit
PUBLIC isodigit
EXTERN asm_isodigit

; FASTCALL

._isodigit
.isodigit

   ld a,l
   call asm_isodigit
   ld hl,0
   ret c
   inc l
   ret
