
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void b_vector_destroy(b_vector_t *v)
;
; Free the vector's array and zero out the structure.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_destroy

EXTERN asm_free, l_setmem_hl
   
asm_b_vector_destroy:

   ; enter : hl = vector *
   ;
   ; uses  : af, de, hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   dec hl
   
   xor a
   call l_setmem_hl - 16
   
   ex de,hl
   jp asm_free
