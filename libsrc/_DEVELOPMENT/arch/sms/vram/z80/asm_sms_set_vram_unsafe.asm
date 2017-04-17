; ========================================================================
; 
; void *sms_set_vram_unsafe(unsigned char c, unsigned int n)
;
; set VRAM unsafe; VRAM addresses are assumed to be stable.
;
; ========================================================================

; unsafe version has not been written yet

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_set_vram_unsafe

EXTERN asm_sms_set_vram

defc asm_sms_set_vram_unsafe = asm_sms_set_vram

   ; set vram
   ;
   ; enter :  a = unsigned char c
   ;         bc = unsigned int n > 0
   ;
   ;         VRAM DESTINATION ADDRESS ALREADY SET!
   ;
   ; exit  : bc = 0
   ;
   ; uses  : f, bc, hl
