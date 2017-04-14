; ========================================================================
; 
; void *sms_memcpy_vram_to_vram(void *dst, void *src, unsigned int n)
;
; memcpy within vram; ; VRAM addresses are assumed to be stable.
;
; ========================================================================

; a faster method that copies more than one byte at a time should be sought

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_memcpy_vram_to_vram

asm_sms_memcpy_vram_to_vram:

   ; memcpy within vram
   ;
   ; enter : hl = void *src in vram
   ;         de = void *dst in vram
   ;         bc = unsigned int n > 0
   ;
   ; exit  : hl = void *src, &byte after last read
   ;         de = void *dst, &byte after last written
   ;
   ; uses  : af, bc, de, hl, af'
   
loop:

   ; must yield opportunities for an interrupt to occur

   di

   ld a,l
   out (__IO_VDP_COMMAND),a
   ld a,h
   out (__IO_VDP_COMMAND),a

   in a,(__IO_VDP_DATA)
   ex af,af'

   ld a,e
   out (__IO_VDP_COMMAND),a
   ld a,d
   or $40
   out (__IO_VDP_COMMAND),a

   ei

   ex af,af'
   out (__IO_VDP_DATA),a
    
   inc de
    
   cpi
   jp pe, loop
    
   ret
