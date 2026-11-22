
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int bv_stack_push(bv_stack_t *s, int c)
;
; Push item onto stack.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC asm_bv_stack_push

EXTERN asm_b_vector_append

defc asm_bv_stack_push = asm_b_vector_append

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
