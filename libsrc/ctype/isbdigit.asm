; isbdigit

        SECTION code_clib

PUBLIC _isbdigit
PUBLIC isbdigit
EXTERN asm_isbdigit

; FASTCALL

._isbdigit
.isbdigit

   ld a,l
   call asm_isbdigit
   ld hl,0
   ret c
   inc l
   ret
