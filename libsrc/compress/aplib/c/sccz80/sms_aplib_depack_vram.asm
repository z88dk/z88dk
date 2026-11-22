
; void sms_aplib_depack_vram(void *dst, void *src)

SECTION code_clib
SECTION code_compress_aplib

PUBLIC sms_aplib_depack_vram

EXTERN asm_sms_aplib_depack_vram

sms_aplib_depack_vram:

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
   
   jp asm_sms_aplib_depack_vram

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sms_aplib_depack_vram
defc _sms_aplib_depack_vram = sms_aplib_depack_vram
ENDIF

