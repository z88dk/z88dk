; ========================================================================
; 
; void *sms_memcpy_mem_to_vram(void *dst, void *src, unsigned int n)
;
; memcpy from memory to vram; VRAM addresses are assumed to be stable.
;
; ========================================================================

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_memcpy_mem_to_vram

EXTERN asm_sms_vram_write_de
EXTERN asm_sms_copy_mem_to_vram

asm_sms_memcpy_mem_to_vram:

   ; memcpy from memory to vram
   ;
   ; enter : hl = void *src in memory
   ;         de = void *dst in vram
   ;         bc = unsigned int n > 0
   ;
   ; exit  : de = void *src, &byte after last read from memory
   ;         hl = void *dst, &byte after last written to vram
   ;         bc = 0
   ;
   ; uses  : af, bc, de, hl

   call asm_sms_vram_write_de
   
   ex de,hl
   add hl,bc
   ex de,hl

   ; hl = void *src in memory
   ; bc = unsigned int n > 0
   ; VRAM has dst address set

   jp asm_sms_copy_mem_to_vram
