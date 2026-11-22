
; ===============================================================
; Feb 2014
; ===============================================================
; 
; w_vector_t *w_vector_init(void *p, size_t capacity, size_t max_size)
;
; Initialize a word vector structure at address p and allocate
; space for capacity words to begin with.  The vector's array
; will not be allowed to grow beyond max_size words.
;
; Returns p on success or 0 on failure.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC asm_w_vector_init

EXTERN asm_b_vector_init, error_zc

asm_w_vector_init:

   ; enter : de = void *p
   ;         bc = capacity in words
   ;         hl = max_size in words
   ;
   ; exit  : success
   ;
   ;            hl = w_vector_t *
   ;            carry reset
   ;
   ;         fail if required vector > 64k
   ;
   ;            hl = 0
   ;            carry set
   ;
   ;         fail if max_size < capacity
   ;
   ;            hl = 0
   ;            carry set
   ;
   ;         fail if unsuccessful realloc
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
   
   add hl,hl
   jp c, error_zc
   
   sla c
   rl b
   jp c, error_zc

   jp asm_b_vector_init
