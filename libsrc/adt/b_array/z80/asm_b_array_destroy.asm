
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void b_array_destroy(b_array_t *a)
;
; Zero the array structure.
; array.capacity = 0 ensures no array operations can be performed.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_array

PUBLIC asm_b_array_destroy

EXTERN l_setmem_hl

asm_b_array_destroy:

   ; enter : hl = array *
   ;
   ; uses  : af, hl

   xor a
   jp l_setmem_hl - 12
