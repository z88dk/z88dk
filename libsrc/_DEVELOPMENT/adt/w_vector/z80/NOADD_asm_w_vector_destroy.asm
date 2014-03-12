
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_B_VECTOR_DESTROY

; ===============================================================
; Feb 2014
; ===============================================================
; 
; void w_vector_destroy(w_vector_t *v)
;
; Free the vector's array and zero out the structure.
;
; ===============================================================

asm_w_vector_destroy:

   ; enter : hl = vector *
   ;
   ; uses  : af, de, hl
