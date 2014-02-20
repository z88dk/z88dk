
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void b_vector_destroy(b_vector_t *v)
;
; Free the vector's array and zero out the structure.
;
; ===============================================================

XLIB asm_b_vector_destroy

LIB asm_free, l_setmem_hl

asm_b_vector_destroy:

   ; enter : hl = b_vector_t *
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
