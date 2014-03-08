
; ===============================================================
; Stefano Bodrato
; ===============================================================
;
; void z80_push_ei(void)
;
; Save the current ei/di status on the stack and enable ints.
;
; ===============================================================

XLIB asm_z80_push_ei

asm_z80_push_ei:

   ; exit  : stack = ei_di_status
   ;
   ; uses  : af, hl

   pop hl                      ; hl = return address
   
   ld a,i                      ; ei_di_status into p/v flag
   ei                          ; enable interrupts
   
   push af                     ; save ei_di_status to stack
   jp (hl)                     ; ret
