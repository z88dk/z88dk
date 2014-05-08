
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void b_vector_destroy(b_vector_t *v)
;
; Free the vector's array and zero out the structure.
;
; ===============================================================

PUBLIC asm_b_vector_destroy

EXTERN asm_free, l_zerostruct8_hl

   inc hl
   inc hl
   
asm_b_vector_destroy:

   ; enter : hl = vector *
   ;
   ; uses  : af, de, hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   dec hl
   
   call l_zerostruct8_hl
   
   ex de,hl
   jp asm_free
