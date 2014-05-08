
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t w_array_capacity(w_array_t *a)
;
; Return the amount of space allocated for the array in words.
;
; ===============================================================

PUBLIC asm_w_array_capacity

EXTERN l_readword_2_hl

asm_w_array_capacity:

   jp l_readword_2_hl - 4

;defc asm_w_array_capacity = l_readword_2_hl - 4

   ; enter : hl = array *
   ;
   ; exit  : hl = capacity in words
   ;
   ; uses  : a, hl
