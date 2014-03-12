
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_W_ARRAY_CAPACITY

; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t w_array_size(w_array_t *a)
;
; Return the array's current size in words.
;
; ===============================================================

asm_w_array_size:

   ; enter : hl = array *
   ;
   ; exit  : hl = size in words
   ;
   ; uses  : a, hl
