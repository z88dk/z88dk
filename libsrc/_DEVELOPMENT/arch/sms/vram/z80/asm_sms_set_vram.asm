; ========================================================================
; 
; void *sms_set_vram(unsigned char c, unsigned int n)
;
; set VRAM; VRAM addresses are assumed to be stable.
;
; ========================================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_set_vram

asm_sms_set_vram:

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

loop:

   out (__IO_VDP_DATA),a
   
   cpi                         ; hl++, bc--
   jp pe, loop
   
   ret
