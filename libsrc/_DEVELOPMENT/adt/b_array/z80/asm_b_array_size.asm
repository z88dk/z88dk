
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_array_size(b_array_t *a)
;
; Return the array's current size.
;
; ===============================================================

PUBLIC asm_b_array_size

EXTERN l_readword_hl

asm_b_array_size:

   jp l_readword_hl - 2

;defc asm_b_array_size = l_readword_hl - 2

   ; enter : hl = array *
   ;
   ; exit  : hl = size
   ;
   ; uses  : a, hl
