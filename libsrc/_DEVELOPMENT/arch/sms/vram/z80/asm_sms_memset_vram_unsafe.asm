; ========================================================================
; 
; void *sms_memset_vram_unsafe(void *dst, unsigned char c, unsigned int n)
;
; memset VRAM unsafe; VRAM addresses are assumed to be stable.
;
; ========================================================================

; unsafe version has not been written yet

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_memset_vram_unsafe

EXTERN asm_sms_memset_vram

defc asm_sms_memset_vram_unsafe = asm_sms_memset_vram

   ; memset vram
   ;
   ; enter : de = void *dst in vram
   ;          a = unsigned char c
   ;         bc = unsigned int n > 0
   ;
   ; exit  : hl = void *dst, &byte after last written in vram
   ;
   ; uses  : af, bc, de, hl
