
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

PUBLIC asm_b_array_destroy

EXTERN l_zerostruct6_hl

asm_b_array_destroy:

   jp l_zerostruct6_hl

;defc asm_b_array_destroy = l_zerostruct6_hl

   ; enter : hl = array *
   ;
   ; uses  : af, hl
