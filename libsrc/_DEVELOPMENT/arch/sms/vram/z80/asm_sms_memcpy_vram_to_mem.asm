; ========================================================================
; 
; void *sms_memcpy_vram_to_mem(void *dst, void *src, unsigned int n)
;
; memcpy from vram to memory; VRAM addresses are assumed to be stable.
;
; ========================================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_memcpy_vram_to_mem
PUBLIC asm_sms_memcpy_vram_to_mem_continue

EXTERN asm_sms_set_vram_read_hl

asm_sms_memcpy_vram_to_mem:

   ; memcpy from vram to memory
   ;
   ; enter : hl = void *src in vram
   ;         de = void *dst in memory
   ;         bc = unsigned int n > 0
   ;
   ; exit  : hl = void *src, &byte after last read from vram
   ;         de = void *dst, &byte after last written in memory
   ;
   ; uses  : af, bc, de, hl

   call asm_sms_set_vram_read_hl

   add hl,bc
   ex de,hl

asm_sms_memcpy_vram_to_mem_continue:

   ; hl = void *dst in memory
   ; bc = unsigned int n > 0
   ; VRAM has src address set

   ld a,b
   inc a
   ld b,c
   
   inc b
   djnz no_adjust
   dec a
   
no_adjust:
   
   ld c,__IO_VDP_DATA
   
loop:

   ini
   djnz loop
   
   dec a
   jr nz, loop
   
   ex de,hl
   ret
 