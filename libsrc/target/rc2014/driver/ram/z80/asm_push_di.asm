
; ===============================================================
; Stefano Bodrato
; ===============================================================
;
; void asm_push_di(void)
;
; Save the current ei/di status on the stack and disable ints.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib

PUBLIC asm_push_di

.asm_push_di

   ; exit  : stack = ei_di_status
   ;
   ; uses  : af

   ex (sp),hl
   push hl                      ; preserve hl

   ld a,i                       ; cmos z80 has no bug

   di

   push af
   pop hl                       ; hl = ei_di status

   pop af                       ; af = ret
   ex (sp),hl                   ; restore hl, push ei_di_status

   push af
   ret
