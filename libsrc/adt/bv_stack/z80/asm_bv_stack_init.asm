
; ===============================================================
; Mar 2014
; ===============================================================
; 
; bv_stack_t *bv_stack_init(void *p, size_t capacity, size_t max_size)
;
; Initialize a byte vector structure at address p and allocate
; an array of capacity bytes to begin with.  The vector's array
; will not be allowed to grow beyond max_size bytes.
;
; Returns p on success or 0 on failure.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC asm_bv_stack_init

EXTERN asm_b_vector_init

defc asm_bv_stack_init = asm_b_vector_init

   ; enter : de = void *p
   ;         bc = capacity
   ;         hl = max_size
   ;
   ; exit  : success
   ;
   ;            hl = stack *
   ;            carry reset
   ;
   ;         fail if max_size < capacity
   ;
   ;            hl = 0
   ;            carry set, errno = EINVAL
   ;
   ;         fail if unsuccessful realloc
   ;
   ;            hl = 0
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl
