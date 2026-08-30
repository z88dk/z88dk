; int compare_dostm(struct dos_tm *a, struct dos_tm *b)

SECTION code_time

PUBLIC compare_dostm

EXTERN asm_compare_dostm

compare_dostm:

   ; A return address can't go through AF on these CPUs: the flags byte does not
   ; read back what was pushed, and on the VM1 pop af also switches the data bank.
   IF __CPU_INTEL__ | __CPU_GBZ80__
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   ELSE
   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   ENDIF
   
   jp asm_compare_dostm

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _compare_dostm
defc _compare_dostm = compare_dostm
ENDIF

