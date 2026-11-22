
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int wa_stack_push(wa_stack_t *s, void *item)
;
; Push item onto stack.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC asm_wa_stack_push

EXTERN asm_w_array_append

defc asm_wa_stack_push = asm_w_array_append

   ; enter : hl = stack *
   ;         bc = item
   ;
   ; exit  : bc = item
   ;
   ;         success
   ;
   ;            de = & stack.data[idx

   ;            hl = idx of appended word
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, de, hl
