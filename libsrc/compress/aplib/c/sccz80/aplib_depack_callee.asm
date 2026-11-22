
; void aplib_depack_callee(void *dst, void *src)

SECTION code_clib
SECTION code_compress_aplib

PUBLIC aplib_depack_callee

EXTERN asm_aplib_depack

aplib_depack_callee:

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
   
   jp asm_aplib_depack
 
; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _aplib_depack_callee
defc _aplib_depack_callee = aplib_depack_callee
ENDIF

