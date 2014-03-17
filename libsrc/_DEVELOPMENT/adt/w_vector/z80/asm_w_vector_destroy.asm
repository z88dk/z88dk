
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void w_vector_destroy(w_vector_t *v)
;
; Free the vector's array and zero out the structure.
;
; ===============================================================

XLIB asm_w_vector_destroy

LIB asm_b_vector_destroy

defc asm_w_vector_destroy = asm_b_vector_destroy

   ; enter : hl = vector *
   ;
   ; uses  : af, de, hl
