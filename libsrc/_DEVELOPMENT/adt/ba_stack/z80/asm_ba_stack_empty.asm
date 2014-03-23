
; ===============================================================
; Feb 2014
; ===============================================================
; 
; int ba_stack_empty(ba_stack_t *s)
;
; Return true (non-zero) if stack is empty.
;
; ===============================================================

XLIB asm_ba_stack_empty

LIB l_testword_hl

asm_ba_stack_empty:

   jp l_testword_hl - 2

;defc asm_ba_stack_empty = l_testword_hl - 2

   ; enter : hl = stack *
   ;
   ; exit  : if stack is empty
   ;
   ;           hl = 1
   ;           z flag set
   ;
   ;         if stack is not empty
   ;
   ;           hl = 0
   ;           nz flag set
   ;
   ; uses  : af, hl
