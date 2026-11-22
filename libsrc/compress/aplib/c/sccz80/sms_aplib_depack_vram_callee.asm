
; void sms_aplib_depack_vram_callee(void *dst, void *src)

SECTION code_clib
SECTION code_compress_aplib

PUBLIC sms_aplib_depack_vram_callee

EXTERN asm_sms_aplib_depack_vram

sms_aplib_depack_vram_callee:

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
   
   jp asm_sms_aplib_depack_vram

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sms_aplib_depack_vram_callee
defc _sms_aplib_depack_vram_callee = sms_aplib_depack_vram_callee
ENDIF

