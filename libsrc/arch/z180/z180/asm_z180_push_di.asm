
; ===============================================================
; Stefano Bodrato
; aralbrec: accommodate nmos z80 bug
; ===============================================================
;
; void z180_push_di(void)
;
; Save the current ei/di status on the stack and disable ints.
;
; ===============================================================

SECTION code_clib
SECTION code_z180

PUBLIC asm_z180_push_di
PUBLIC asm_cpu_push_di

asm_z180_push_di:
asm_cpu_push_di:

   ; exit  : stack = ei_di_status
   ;
   ; uses  : af

   ex (sp),hl
   push hl

   ld a,i
   
   di
   
   push af
   pop hl                      ; hl = ei_di status
   
   pop af                      ; af = ret
   ex (sp),hl                  ; restore hl, push ei_di_status
   
   push af
   ret
