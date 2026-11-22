
; void aplib_depack(void *dst, void *src)

SECTION code_clib
SECTION code_compress_aplib

PUBLIC aplib_depack

EXTERN asm_aplib_depack

aplib_depack:

   ; A return address can't go through AF on these CPUs: the flags byte does not
   ; read back what was pushed, and on the VM1 pop af also switches the data bank.
   IF __CPU_INTEL__ | __CPU_GBZ80__
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   ELSE
   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   ENDIF
   
   jp asm_aplib_depack
 
; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _aplib_depack
defc _aplib_depack = aplib_depack
ENDIF

