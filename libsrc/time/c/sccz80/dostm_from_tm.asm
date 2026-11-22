; void dostm_from_tm(struct dos_tm *,struct tm *)

SECTION code_time

PUBLIC dostm_from_tm

EXTERN asm_dostm_from_tm

dostm_from_tm:

   ; A return address can't go through AF on these CPUs: the flags byte does not
   ; read back what was pushed, and on the VM1 pop af also switches the data bank.
   IF __CPU_INTEL__ | __CPU_GBZ80__
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   ELSE
   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   ENDIF
   
   jp asm_dostm_from_tm

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dostm_from_tm
defc _dostm_from_tm = dostm_from_tm
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___dostm_from_tm
defc ___dostm_from_tm = dostm_from_tm
ENDIF


