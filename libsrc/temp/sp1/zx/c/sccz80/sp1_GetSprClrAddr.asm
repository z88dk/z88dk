; void sp1_GetSprClrAddr(struct sp1_ss *s, uchar **sprdest)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_GetSprClrAddr

EXTERN asm_sp1_GetSprClrAddr

sp1_GetSprClrAddr:

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
;   jp asm_sp1_GetSprClrAddr
   push ix
   call asm_sp1_GetSprClrAddr
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_GetSprClrAddr
defc _sp1_GetSprClrAddr = sp1_GetSprClrAddr
ENDIF

