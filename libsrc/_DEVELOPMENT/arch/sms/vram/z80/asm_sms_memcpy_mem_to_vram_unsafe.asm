; ========================================================================
; 
; void *sms_memcpy_mem_to_vram_unsafe(void *dst, void *src, unsigned int n)
;
; memcpy from memory to vram; VRAM addresses are assumed to be stable.
;
; ========================================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_memcpy_mem_to_vram_unsafe
PUBLIC asm_sms_memcpy_mem_to_vram_unsafe_continue

EXTERN asm_sms_set_vram_write_de

asm_sms_memcpy_mem_to_vram_unsafe:

   ; memcpy from memory to vram
   ;
   ; enter : hl = void *src in memory
   ;         de = void *dst in vram
   ;         bc = unsigned int n > 0
   ;
   ; exit  : de = void *src, &byte after last read from memory
   ;         hl = void *dst, &byte after last written in vram
   ;
   ; uses  : af, bc, de, hl

   call asm_sms_set_vram_write_de
   
   ex de,hl
   add hl,bc
   ex de,hl

asm_sms_memcpy_mem_to_vram_unsafe_continue:

   ; hl = void *src in memory
   ; bc = unsigned int n > 0
   ; VRAM has dst address set
   
   ld a,b
   inc a
   ld b,c
   
   inc b
   djnz no_adjust
   dec a
   
no_adjust:
   
   ld c,__IO_VDP_DATA
   
loop:

   otir
   
   dec a
   jr nz, loop

   ex de,hl
   ret
 