
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t b_vector_write_block(void *src, size_t n, b_vector_t *v, size_t idx)
;
; Write at most n bytes from the src to the vector at index idx.
; Returns number of bytes actually written, which may be less
; than n if the vector could not be grown sufficiently.
;
; ===============================================================

XLIB asm_b_vector_write_block
XDEF asm_b_vector_write_block_extra

LIB __vector_make_room

asm_b_vector_write_block:

   exx
   ld de,0
   exx

asm_b_vector_write_block_extra:

   ; Copy n bytes from src to vector[idx]
   ;
   ; If necessary, the vector is grown to accommodate the write.
   ; If idx > vector.size such that a hole is created, the hole is zeroed.
   ;
   ; enter : hl'= void *src
   ;         de'= extra
   ;         bc = size_t idx
   ;         de = size_t n
   ;         hl = b_vector_t *
   ;
   ; exit  : hl'= src_ptr, pointer to char after last copied
   ;
   ;         success
   ;
   ;            hl = num bytes written to vector
   ;            de = & vector.array[idx]
   ;            de'= & vector.array[idx+num]
   ;             a = realloc_status
   ;               = 0 if realloc was performed
   ;               =-1 if not all n bytes could be written
   ;               > 0 otherwise
   ;            carry reset
   ;
   ;         fail if idx >= vector.capacity and vector could not grow
   ;
   ;            hl = 0
   ;            carry set, errno = ENOMEM
   ;
   ;         fail if idx + n > 64k
   ;
   ;            hl = 0
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   call __vector_make_room     ; make room for n bytes @ vector[idx]
   ret c                       ; if no room is available
   
   ; copy bytes from src to vector.array[idx]
   
   ; bc = num bytes available at idx
   ; hl = & vector.array[idx]
   ;  a = realloc_status
   ;    = 0 if realloc was performed
   ;    =-1 if num bytes available is < n
   ;    > 0 otherwise
   ; hl'= void *src
   
   push af                     ; save realloc_status
   push bc                     ; save num bytes
   push hl                     ; save & vector.array[idx]
   
   exx
   
   pop de                      ; & vector.array[idx]
   pop bc                      ; bc = num bytes
   
   ld a,b
   or c
   jr z, skip_write            ; if degenerate case
   
   ldir
   
skip_write:

   exx
   ex de,hl

   ld l,c
   ld h,b                      ; hl = num bytes
   
   pop af                      ; a = realloc_status
   
   ; hl = num bytes written
   ; de = & vector.array[idx]
   ;  a = realloc_status = 0 if realloc performed
   ; hl'= src + num bytes
   ; de'= & vector.array[idx + num bytes]
   
   ret
