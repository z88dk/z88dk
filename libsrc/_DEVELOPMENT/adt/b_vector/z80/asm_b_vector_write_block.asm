
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
XDEF asm_b_vector_write_block_extra, asm0_b_vector_write_block_extra

LIB error_einval_zc, error_enomem_zc, error_zc
LIB __vector_resize_extra, asm_memset, asm_memmove, l_neg_bc

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
   
   push de                     ; save size_t n
   push bc                     ; save size_t idx

   ex de,hl                    ; hl = size_t n
   
   add hl,bc                   ; hl = n + idx = new_size
   jp c, error_einval_zc - 2   ; if new_size > 64k
   
   ld c,l
   ld b,h                      ; bc = new_size
   
   ex de,hl                    ; hl = vector *
   
   inc hl
   inc hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = vector.size = old_size
   
   push de                     ; save old_size

asm0_b_vector_write_block_extra:

   ; bc = new_size
   ; hl = & vector.size + 1b
   ; hl'= void *src
   ; de'= extra
   ; stack = n, idx, old_size

   exx
   
   push de                     ; save extra
   
   exx
   
   pop de                      ; de = extra
   
   ; bc = new_size
   ; hl = & vector.size + 1b
   ; de = extra
   ; hl'= void *src
   ; stack = n, idx, old_size
   
   call __vector_resize_extra  ; make sure there is room for the write
   jr c, resize_failed         ; if resize failed
   
   inc l
   inc l
   
   ld a,l
   
   ; de = & vector.size + 1b
   ; a  = realloc_status = 0 if realloc performed
   ; hl'= void *src
   ; stack = n, idx, old_size

rejoin:

   ex de,hl                    ; hl = & vector.size + 1b
   
   dec hl
   dec hl
   
   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = vector.array

   pop hl                      ; hl = old_size
   pop bc                      ; bc = idx
   push af                     ; save realloc_status

   ; de = vector.array
   ; hl = old_size
   ; bc = idx
   ; hl'= void *src
   ; stack = n, realloc_status
   
   sbc hl,bc                   ; hl = old_size - idx
   jr nc, hole_absent          ; if old_size >= idx, there is no hole

   ; write is occurring past end of original vector
   ; the created hole needs to be zeroed

hole_present:

   ; de = vector.array
   ; hl = old_size - idx
   ; bc = idx
   ; hl'= void *src
   ; stack = n, realloc_status

   push hl                     ; save old_size - idx
   
   add hl,bc
   add hl,de                   ; hl = & vector.array[old_size]

   pop bc                      ; bc = old_size - idx
   call l_neg_bc               ; bc = hole_size = idx - old_size

   ; hl = & vector.array[old_size]
   ; bc = hole_size = idx - old_size
   ; hl'= void *src
   ; stack = n, realloc_status

   ld e,0
   call asm_memset
   
   ex de,hl
   
   ; hl = & vector.array[idx]
   ; hl'= void *src
   ; stack = n, realloc_status
   
   jr write_bytes

hole_absent:

   ; de = vector.array
   ; bc = idx
   ; hl'= void *src
   ; stack = n, realloc_status

   ex de,hl
   add hl,bc

   ; time to copy bytes from src into vector.array

write_bytes:

   ; hl = & vector.array[idx]
   ; hl'= void *src
   ; stack = n, realloc_status

   push hl
   
   exx
   
   pop de                      ; de = & vector.array[idx]
   
   pop af                      ; a = realloc_status
   pop bc                      ; bc = n

   push af                     ; save realloc_status
   push bc                     ; save n
   push hl                     ; save src
   
   ; hl = void *src
   ; de = & vector.array[idx]
   ; bc = size_t n
   ; stack = realloc_status, n, src
   
   call asm_memmove            ; play safe
   
   pop hl                      ; hl = void *src
   pop bc                      ; bc = size_t n
   
   add hl,bc                   ; hl = src + n
   
   push bc                     ; save size_t n
   
   exx
   ex de,hl

   pop hl                      ; hl = size_t n
   pop af                      ; a = realloc_status
   
   ; hl = size_t n
   ; de = & vector.array[idx]
   ;  a = realloc_status = 0 if realloc performed
   ; hl'= src + n
   
   ret

resize_failed:

   ; vector is unable to grow so write up to vector capacity
   
   ; de = & vector.size + 1b
   ; hl'= void *src
   ; stack = n, idx, old_size

   ; need to replace n in stack with (vector.capacity - idx)

   pop af
   pop bc
   push bc                     ; bc = idx
   push af
   
   ex de,hl                    ; hl = & vector.size + 1b
   
   inc hl
   inc hl
   
   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = vector.capacity
   dec hl
   
   ex de,hl

   ; de = & vector.size + 1b
   ; hl = vector.capacity
   ; bc = idx
   ; hl'= void *src
   ; stack = n, idx, old_size

   or a
   sbc hl,bc                   ; hl = vector.capacity - idx

   jp c, error_enomem_zc - 3   ; if vector.capacity < idx
   jp z, error_enomem_zc - 3   ; if vector.capacity == idx

   ; de = & vector.size + 1b
   ; hl = new_n
   ; hl'= void *src
   ; stack = n, idx, old_size
   
   ld c,l
   ld b,h                      ; bc = new_n
   
   ld hl,4
   add hl,sp
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; replace n with new_n
   
   ; de = & vector.size + 1b
   ; hl'= void *src
   ; stack = new_n, idx, old_size

   ld a,-1

   ; de = & vector.size + 1b
   ; a  = realloc_status = 0 if realloc performed
   ; hl'= void *src
   ; stack = n, idx, old_size

   jr rejoin
