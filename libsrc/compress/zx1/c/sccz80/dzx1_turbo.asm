
; void dzx1_turbo(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx1

PUBLIC dzx1_turbo

EXTERN asm_dzx1_turbo

dzx1_turbo:

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
   
   jp asm_dzx1_turbo

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx1_turbo
defc _dzx1_turbo = dzx1_turbo
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___dzx1_turbo
defc ___dzx1_turbo = dzx1_turbo
ENDIF

