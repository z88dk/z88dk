; ========================================================================
; 
; void sms_setw_vram(unsigned int c, unsigned int n)
;
; memset VRAM word at a time; VRAM addresses are assumed to be stable.
;
; ========================================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_setw_vram

asm_sms_setw_vram:

   ; memset vram by word
   ;
   ; enter : de = unsigned int c
   ;         bc = unsigned int n > 0
   ;
   ;         VRAM DESTINATION ADDRESS ALREADY SET!
   ;
   ; exit  : de = unsigned int c
   ;         bc = 0
   ;
   ; uses  : af, bc, hl

loop:

   ld a,e
   out (__IO_VDP_DATA),a
   
   cpi                         ; hl++, bc--
   
   ld a,d
   out (__IO_VDP_DATA),a

   nop
   jp pe, loop

   ret
