; ========================================================================
; 
; void *sms_memsetw_vram(void *dst, unsigned int c, unsigned int n)
;
; memset VRAM word at a time; VRAM addresses are assumed to be stable.
;
; ========================================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_memsetw_vram

EXTERN asm_sms_set_vram_write_de

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

   call asm_sms_set_vram_write_de
   ex de,hl
   
loop:

   ld a,e
   out (__IO_VDP_DATA),a
   
   cpi                         ; hl++, bc--
   
   ld a,d
   out (__IO_VDP_DATA),a

   nop
   jp pe, loop

   ret
