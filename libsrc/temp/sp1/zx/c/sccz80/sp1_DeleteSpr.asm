
; void __FASTCALL__ sp1_DeleteSpr(struct sp1_ss *s)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_DeleteSpr

EXTERN asm_sp1_DeleteSpr

sp1_DeleteSpr:

   push ix
   call asm_sp1_DeleteSpr
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_DeleteSpr
PUBLIC _sp1_DeleteSpr_fastcall
defc _sp1_DeleteSpr = sp1_DeleteSpr
defc _sp1_DeleteSpr_fastcall = sp1_DeleteSpr
ENDIF
