
; ===============================================================
; Feb 2014
; ===============================================================
; 
; int b_vector_shrink_to_fit(b_vector_t *v)
;
; Release any excess memory allocated for the vector's array.
;
; After calling, vector.capacity == vector.size
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_shrink_to_fit

EXTERN __array_info, asm_realloc, error_mnc, error_zc

asm_b_vector_shrink_to_fit:

   ; enter : hl = vector *
   ;
   ; exit  : success
   ;
   ;            hl = -1
   ;            carry reset
   ;
   ;         fail on realloc not getting lock
   ;
   ;            hl = 0
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl
   
   call __array_info
   
   ; de = vector.data
   ; bc = vector.size
   ; hl = & vector.size + 1b

   inc hl
   
   push hl                     ; save & vector.capacity
   push bc                     ; save vector.size

   ex de,hl                    ; hl = vector.data
   call asm_realloc

   pop bc                      ; bc = vector.size
   pop hl                      ; hl = & vector.capacity

   jp c, error_zc              ; if realloc failed
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; vector.capacity = vector.size
   
   jp error_mnc
