
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_array_read_block(void *dst, size_t n, b_array_t *a, size_t idx)
;
; Copy at most n bytes from the array at index idx to address
; dst.  Returns number of bytes actually copied, which may be
; less than n if the array does not contain n bytes of data at
; idx.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_array

PUBLIC asm_b_array_read_block

EXTERN __array_at, l_minu_de_hl, asm_memcpy, error_zc

asm_b_array_read_block:

   ; enter : de'= void *dst
   ;         hl = array *
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
   ;            carry set
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   push de                     ; save n

   call __array_at

   ex (sp),hl
   ex de,hl

   jp c, error_zc - 1
      
   ; de = n
   ; bc = idx
   ; hl = array.size
   ; de'= void *dst
   ; stack = & array.data[idx]
   
   sbc hl,bc                   ; hl = size - idx
   call l_minu_de_hl           ; hl = min(size - idx, n)
   
   push hl                     ; save num bytes to copy
   
   exx
   
   pop bc                      ; bc = num bytes to copy
   pop hl                      ; hl = & array.data[idx]
   
   ; hl = & array.data[idx]
   ; bc = num bytes to copy
   ; de = void *dst
   
   call asm_memcpy
   
   exx
   ret
