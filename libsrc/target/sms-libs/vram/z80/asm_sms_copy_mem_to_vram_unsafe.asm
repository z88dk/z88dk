; ========================================================================
; 
; void sms_copy_mem_to_vram_unsafe(void *src, unsigned int n)
;
; copy from memory to vram; VRAM addresses are assumed to be stable.
;
; ========================================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_copy_mem_to_vram_unsafe

asm_sms_copy_mem_to_vram_unsafe:

   ; copy from memory to vram
   ;
   ; enter : hl = void *src in memory
   ;         bc = unsigned int n > 0
   ;
   ;         VRAM DESTINATION ADDRESS IS ALREADY SET!
   ;
   ; exit  : de = void *src, &byte after last read from memory
   ;         bc = 0
   ;
   ; uses  : af, bc, de, hl

   dec bc
   inc b
   inc c

   ld a,b
   ld b,c
   
no_adjust:
   
   ld c,__IO_VDP_DATA
   
loop:

   otir
   
   dec a
   jr nz, loop

   ld c,a
   ex de,hl
   ret
 