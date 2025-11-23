
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t w_vector_append_n(w_vector_t *v, size_t n, void *item)
;
; Append n copies of item to the end of the vector, return
; index of new block.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC asm_w_vector_append_n

EXTERN asm_b_vector_append_block, asm1_w_array_append_n, error_mc

asm_w_vector_append_n:

   ; enter : hl = vector *
   ;         de = n
   ;         bc = item
   ;
   ; exit  : success
   ;
   ;            hl = idx of words appended
   ;            de = & vector.data[idx

   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   sla e
   rl d                        ; num bytes = n * 2
   jp c, error_mc

   push bc                     ; save item
   
   call asm_b_vector_append_block
   jp nc, asm1_w_array_append_n
   
   jp error_mc - 1             ; if vector append failed
