
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void bv_stack_destroy(bv_stack_t *s)
;
; Free the stack's array and zero out the structure.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC asm_bv_stack_destroy

EXTERN asm_b_vector_destroy

defc asm_bv_stack_destroy = asm_b_vector_destroy

   ; enter : hl = vector *
   ;
   ; uses  : af, de, hl
