; ========================================================================
; 
; void *sms_memsetw_vram_unsafe(void *dst, unsigned int c, unsigned int n)
;
; memset VRAM word at a time unsafe; VRAM addresses are assumed to be stable.
;
; ========================================================================

; unsafe version has not been written yet

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_memsetw_vram_unsafe

EXTERN asm_sms_memsetw_vram

defc asm_sms_memsetw_vram_unsafe = asm_sms_memsetw_vram

   ; memset vram by word
   ;
   ; enter : de = void *dst in vram
   ;         hl = unsigned int c
   ;         bc = unsigned int n > 0
   ;
   ; exit  : hl = void *dst, &byte after last written in vram
   ;         de = unsigned int c
   ;         bc = 0
   ;
   ; uses  : af, bc, de, hl
