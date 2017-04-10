; ========================================================================
; 
; void *sms_memcpy_vram_to_vram_unsafe(void *dst, void *src, unsigned int n)
;
; memcpy within vram unsafe; ; VRAM addresses are assumed to be stable.
;
; ========================================================================

; unsafe version has not been written yet
; the idea is to read a bunch of bytes into the stack and then write them quickly to dst

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_memcpy_vram_to_vram_unsafe

EXTERN asm_sms_memcpy_vram_to_vram

defc asm_sms_memcpy_vram_to_vram_unsafe = asm_sms_memcpy_vram_to_vram

;; asm_sms_memcpy_vram_to_vram_unsafe:
;; 
;;    ; memcpy within vram
;;    ;
;;    ; enter : hl = void *src in vram
;;    ;         de = void *dst in vram
;;    ;         bc = unsigned int n > 0
;;    ;
;;    ; exit  : hl = void *src, &byte after last read
;;    ;         de = void *dst, &byte after last written
;;    ;
;;    ; uses  : af, bc, de, hl, af'
