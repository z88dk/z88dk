
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *b_vector_append_block(b_vector_t *v, size_t n)
;
; Grow vector by n bytes and return a pointer to the appended
; bytes.
;
; ===============================================================

XLIB asm_b_vector_append_block
XDEF asm0_b_vector_append_block

LIB asm_realloc
LIB error_enomem_zc, error_zc, error_einval_zc

asm_b_vector_append_block:

   ; enter : hl = vector *
   ;         bc = size_t n
   ;
   ; exit  : bc = size_t n
   ;
   ;         success
   ;
   ;            hl = & bytes added to vector.array
   ;            de = idx of bytes added to vector.array
   ;            carry reset
   ;
   ;         fail if max_size exceeded
   ;
   ;            hl = 0
   ;            carry set, errno = EINVAL
   ;
   ;         fail if insufficient memory or lock not acquired
   ;
   ;            hl = 0
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl
   
   inc hl
   inc hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = vector.size
   inc hl

   ex de,hl
   add hl,bc
   ex de,hl                    ; de = new_size
   
   jp c, error_enomem_zc       ; if new_size > 64k

asm0_b_vector_append_block:

   ; bc = n = grow amount in bytes
   ; de = new_size
   ; hl = & vector.capacity

   push bc                     ; save n
   
   ld c,e
   ld b,d                      ; bc = new_size

   ld e,(hl)
   inc hl
   ld d,(hl)
   
   ex de,hl                    ; hl = vector.capacity
   
   sbc hl,de                   ; hl = vector.capacity - new_size
   
   ex de,hl
   jr c, capacity_growing      ; if vector.capacity < new_size
   
capacity_unchanged:

   ; bc = new_size
   ; hl = & vector.capacity + 1b
   ; stack = n
   
   dec hl
   dec hl

rejoin:

   ld d,(hl)
   ld (hl),b
   dec hl
   ld e,(hl)                   ; de = vector.old_size
   ld (hl),c                   ; vector.size = new_size
   dec hl
   
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a                      ; hl = vector.array
   
   add hl,de                   ; hl = & bytes added to array
   pop bc                      ; bc = n = number of bytes added
   
   ret

capacity_growing:

   ; bc = new_size
   ; hl = & vector.capacity + 1b
   ; stack = n

   inc hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   
   ex de,hl                    ; hl = vector.max_size

   or a
   sbc hl,bc                   ; hl = vector.max_size - new_size
   
   ex de,hl
   jr c, max_size_exceeded

   ; attempt to allocate more memory
   
   ; hl = & vector.max_size + 1b
   ; bc = new_size
   ; stack = n
   
   ld de,-7
   add hl,de
   
   push hl                     ; save vector *
   push bc                     ; save new_size
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = vector.array
   
   call asm_realloc
   ex de,hl                    ; de = void *p_new
   
   pop bc                      ; bc = new_size
   pop hl                      ; hl = vector *
   
   jr c, realloc_failed

   ld (hl),e
   inc hl
   ld (hl),d                   ; vector.array = p_new
   
   ld de,4
   add hl,de                   ; hl = & vector.capacity + 1b
   
   ld (hl),b
   dec hl
   ld (hl),c                   ; vector.capacity = new_size

   dec hl
   jr rejoin

max_size_exceeded:

   pop bc                      ; bc = n
   jp error_einval_zc

realloc_failed:

   pop bc                      ; bc = n
   jp error_zc
