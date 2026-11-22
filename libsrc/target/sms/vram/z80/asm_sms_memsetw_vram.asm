; ========================================================================
; 
; void *sms_memsetw_vram(void *dst, unsigned int c, unsigned int n)
;
; memset VRAM word at a time; VRAM addresses are assumed to be stable.
;
; ========================================================================

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_memsetw_vram

EXTERN asm_sms_vram_write_de
EXTERN asm_sms_setw_vram

asm_sms_memsetw_vram:

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

   call asm_sms_vram_write_de

   ex de,hl
   jp asm_sms_setw_vram
