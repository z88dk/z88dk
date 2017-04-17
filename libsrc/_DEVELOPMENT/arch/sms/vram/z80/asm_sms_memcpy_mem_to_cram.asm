; ========================================================================
; 
; void *sms_memcpy_mem_to_cram(void *cram, void *src, unsigned int n)
;
; memcpy from memory to cram; VRAM addresses are assumed to be stable.
;
; ========================================================================

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_memcpy_mem_to_cram

EXTERN asm_sms_memcpy_mem_to_vram

asm_sms_memcpy_mem_to_cram:

   ; memcpy from memory to cram
   ;
   ; enter : hl = void *src in memory
   ;         de = void *dst in cram 0-31
   ;         bc = unsigned int n > 0
   ;
   ; exit  : de = void *src, &byte after last read from memory
   ;         hl = void *dst, &byte after last written to cram
   ;         bc = 0
   ;
   ; uses  : af, bc, de, hl

   ld a,$c0
   or d
   ld d,a
   
   jp asm_sms_memcpy_mem_to_vram
