
; void dzx7_standard(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC dzx7_standard

EXTERN asm_dzx7_standard

dzx7_standard:

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
   
   jp asm_dzx7_standard

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx7_standard
defc _dzx7_standard = dzx7_standard
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___dzx7_standard
defc ___dzx7_standard = dzx7_standard
ENDIF

