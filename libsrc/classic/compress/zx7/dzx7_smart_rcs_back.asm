
; void dzx7_smart_rcs_back(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC dzx7_smart_rcs_back

EXTERN asm_dzx7_smart_rcs_back

dzx7_smart_rcs_back:

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

   jp asm_dzx7_smart_rcs_back

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx7_smart_rcs_back
defc _dzx7_smart_rcs_back = dzx7_smart_rcs_back
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___dzx7_smart_rcs_back
defc ___dzx7_smart_rcs_back = dzx7_smart_rcs_back
ENDIF

