; ========================================================================
; 
; void *sms_memcpy_vram_to_vram_unsafe(void *dst, void *src, unsigned int n)
;
; memcpy within vram unsafe; ; VRAM addresses are assumed to be stable.
;
; ========================================================================

; better would be to read a bunch of bytes into the stack and then write them quickly to dst

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_memcpy_vram_to_vram_unsafe

asm_sms_memcpy_vram_to_vram_unsafe:

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

inner_loop:
   
   ; must yield opportunities for an interrupt to occur
   
   di
   
   out (c),l
   out (c),h
   in a,(__IO_VDP_DATA)

   out (c),e
   out (c),d
   out (__IO_VDP_DATA),a

   ei

   inc hl
   inc de
   
   djnz inner_loop

   ld a,b
   pop bc
   
   djnz outer_loop

   ld c,b
   res 6,d
   
   ret
