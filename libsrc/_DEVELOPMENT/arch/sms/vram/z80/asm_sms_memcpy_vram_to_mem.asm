; ========================================================================
; 
; void *sms_memcpy_vram_to_mem(void *dst, void *src, unsigned int n)
;
; memcpy from vram to memory; VRAM addresses are assumed to be stable.
;
; ========================================================================

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_memcpy_vram_to_mem

EXTERN asm_sms_vram_read_hl
EXTERN asm_sms_copy_vram_to_mem

asm_sms_memcpy_vram_to_mem:

   ; memcpy from vram to memory
   ;
   ; enter : hl = void *src in vram
   ;         de = void *dst in memory
   ;         bc = unsigned int n > 0
   ;
   ; exit  : hl = void *src, &byte after last read from vram
   ;         de = void *dst, &byte after last written in memory
   ;         bc = 0
   ;
   ; uses  : af, bc, de, hl

   call asm_sms_vram_read_hl

   add hl,bc
   ex de,hl

   ; hl = void *dst in memory
   ; bc = unsigned int n > 0
   ; VRAM has src address set

   jp asm_sms_copy_vram_to_mem
