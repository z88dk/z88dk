
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int ba_stack_pop(ba_stack_t *s)
;
; Pop item from stack.
;
; ===============================================================

XLIB asm_ba_stack_pop

LIB asm_b_array_pop_back

asm_ba_stack_pop:

   jp asm_b_array_pop_back

;defc asm_ba_stack_pop = asm_b_array_pop_back

   ; enter : hl = stack *
   ;
   ; exit  : success
   ;
   ;            hl = last char, popped
   ;            carry reset
   ;
   ;         fail if stack is empty
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl
