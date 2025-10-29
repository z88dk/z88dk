; ========================================================================
; 
; void *sms_memset_vram(void *dst, unsigned char c, unsigned int n)
;
; memset VRAM; VRAM addresses are assumed to be stable.
;
; ========================================================================

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_memset_vram

EXTERN asm_sms_vram_write_de
EXTERN asm_sms_set_vram

asm_sms_memset_vram:

   ; memset vram
   ;
   ; enter : de = void *dst in vram
   ;          a = unsigned char c
   ;         bc = unsigned int n > 0
   ;
   ; exit  : hl = void *dst, &byte after last written in vram
   ;         bc = 0
   ;
   ; uses  : f, bc, de, hl

   ld l,a
   call asm_sms_vram_write_de
   ld a,l
   
   ex de,hl
   jp asm_sms_set_vram
