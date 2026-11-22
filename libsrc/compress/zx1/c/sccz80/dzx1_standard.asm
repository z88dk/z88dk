
; void dzx1_standard(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx1

PUBLIC dzx1_standard

EXTERN asm_dzx1_standard

dzx1_standard:

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
   
   jp asm_dzx1_standard

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx1_standard
defc _dzx1_standard = dzx1_standard
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___dzx1_standard
defc ___dzx1_standard = dzx1_standard
ENDIF

