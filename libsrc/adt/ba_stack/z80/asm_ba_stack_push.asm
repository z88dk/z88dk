
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int ba_stack_push(ba_stack_t *s, int c)
;
; Push item onto stack.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC asm_ba_stack_push

EXTERN asm_b_array_append

defc asm_ba_stack_push = asm_b_array_append

   ; enter : hl = stack *
   ;         bc = int c
   ;
   ; exit  : bc = int c
   ;
   ;         success
   ;
   ;            de = & stack.data[idx]
   ;            hl = idx of appended char
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, de, hl
