
; ===============================================================
; Feb 2014
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

XLIB asm_b_vector_read_block

LIB __vector_at, l_minu_de_hl, asm_memcpy, error_zc

asm_b_vector_read_block:

   ; enter : de'= void *dst
   ;         hl = b_vector_t *
   ;         de = size_t n
   ;         bc = size_t idx
   ; 
   ; exit  : bc = size_t idx
   ;         de = size_t n
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

   push de                     ; save size_t n

   call __vector_at

   ex (sp),hl
   ex de,hl

   jp c, error_zc - 1
      
   ; de = n
   ; bc = idx
   ; hl = vector.size
   ; de'= void *dst
   ; stack = & vector.array[idx]
   
   sbc hl,bc                   ; hl = size - idx
   call l_minu_de_hl           ; hl = min(size - idx, n)
   
   push hl                     ; save num bytes to copy
   
   exx
   
   pop bc                      ; bc = num bytes to copy
   pop hl                      ; hl = & vector.array[idx]
   
   ; hl = & vector.array[idx]
   ; bc = num bytes to copy
   ; de = void *dst
   
   call asm_memcpy
   
   exx
   ret
