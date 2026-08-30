; void tm_from_dostm(struct tm *,struct dos_tm *)

SECTION code_time

PUBLIC tm_from_dostm_callee

EXTERN asm_tm_from_dostm

tm_from_dostm_callee:

   ; A return address can't go through AF on these CPUs: the flags byte does not
   ; read back what was pushed, and on the VM1 pop af also switches the data bank.
   IF __CPU_INTEL__ | __CPU_GBZ80__
   pop bc
   pop hl
   pop de
   push bc
   ELSE
   pop af
   pop hl
   pop de
   push af
   ENDIF
   
   jp asm_tm_from_dostm

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tm_from_dostm_callee
defc _tm_from_dostm_callee = tm_from_dostm_callee
ENDIF

