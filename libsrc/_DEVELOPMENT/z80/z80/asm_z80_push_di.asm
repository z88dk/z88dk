
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
   ; uses  : af, hl

   pop hl                      ; hl = return address
   
   ld a,i                      ; ei_di_status into p/v flag
   di                          ; disable interrupts
   
   push af                     ; save ei_di_status to stack
   jp (hl)                     ; ret
