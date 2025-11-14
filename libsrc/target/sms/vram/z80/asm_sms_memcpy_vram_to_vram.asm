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
   ;         bc = 0
   ;
   ; uses  : af, bc, de, hl

   set 6,d
   
   dec bc
   inc b
   inc c

   ld a,c

no_adjust:
   
   ld c,__IO_VDP_COMMAND

outer_loop:

   push bc
   ld b,a

   di

inner_loop:
   
   ; must yield opportunities for an interrupt to occur

   out (c),l
   out (c),h

   inc hl
   xor a
   ret nz

   in a,(__IO_VDP_DATA)

   ei
   nop
   nop
   di

   out (c),e
   out (c),d
   out (__IO_VDP_DATA),a

   inc de
   djnz inner_loop

   ld a,b
   pop bc
   
   djnz outer_loop

   ei

   ld c,b
   res 6,d
   
   ret
