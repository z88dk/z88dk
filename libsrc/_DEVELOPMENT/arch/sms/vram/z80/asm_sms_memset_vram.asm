; ========================================================================
; 
; void *sms_memset_vram(void *dst, unsigned char c, unsigned int n)
;
; memset VRAM; VRAM addresses are assumed to be stable.
;
; ========================================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_memset_vram

EXTERN asm_sms_set_vram_write_de

asm_sms_memset_vram:

   ; memset vram
   ;
   ; enter : de = void *dst in vram
   ;          a = unsigned char c
   ;         bc = unsigned int n > 0
   ;
   ; exit  : hl = void *dst, &byte after last written in vram
   ;
   ; uses  : af, bc, de, hl

   ld l,a
   call asm_sms_set_vram_write_de
   ld a,l
   
   ex de,hl
   
loop:

   out (__IO_VDP_DATA),a
   
   cpi                         ; hl++, bc--
   jp pe, loop
   
   ret
