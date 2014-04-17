
; ===============================================================
; Stefano Bodrato
; ===============================================================
;
; void z80_push_di(void)
;
; Save the current ei/di status on the stack and disable ints.
;
; ===============================================================

XLIB asm_z80_push_di

asm_z80_push_di:

   ; exit  : stack = ei_di_status
   ;
   ; uses  : af

   ex (sp),hl
   push hl
   
   ld a,i                      ; ei_di status into p/v flag
   di
   
   push af
   pop hl                      ; hl = ei_di status
   
   pop af                      ; af = ret
   ex (sp),hl                  ; restore hl, push ei_di_status
   
   push af
   ret
