======================================================
; Stefano Bodrato
; ===============================================================
;
; void z80_push_int_state(void)
;
; Save the current ei/di status on the stack.
;
; ===============================================================

XLIB asm_z80_push_int_state

asm_z80_push_int_state:

   ; exit  : stack = ei_di_status
   ;
   ; uses  : af, hl

   pop hl                      ; hl = return address
   
   ld a,i                      ; ei_di_status into p/v flag
   push af                     ; save ei_di_status to stack

   jp (hl)                     ; ret
