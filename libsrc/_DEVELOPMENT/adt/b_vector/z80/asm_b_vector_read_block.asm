
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_vector_read_block(void *dst, size_t n, b_vector_t *v, size_t idx)
;
; Copy at most n bytes from the vector at index idx to address
; dst.  Returns number of bytes actually copied, which may be
; less than n if the vector does not contain n bytes of data at
; idx.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_read_block

EXTERN asm_b_array_read_block

defc asm_b_vector_read_block = asm_b_array_read_block

   ; enter : de'= void *dst
   ;         hl = vector *
   ;         de = n
   ;         bc = idx
   ; 
   ; exit  : bc = idx
   ;         de = n
   ;
   ;         success
   ;
   ;            hl = number of bytes read
   ;            hl'= void *dst
   ;            de'= ptr in dst to one byte after last one written
   ;            carry reset
   ;
   ;         fail if idx out of range
   ;
   ;            hl = 0
   ;            de'= void *dst
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
