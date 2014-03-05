
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
XDEF asm_b_vector_append_block_extra

LIB __0_vector_resize_extra, error_einval_zc, error_zc

asm_b_vector_append_block:

   ld de,0

asm_b_vector_append_block_extra:

   ; enter : bc = size_t n
   ;         de = extra
   ;         hl = vector *
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
   ; uses  : af, de, hl

   push bc                     ; save size_t n
   push de                     ; save extra

   inc hl
   inc hl                      ; hl = & vector.size

   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = vector.size
   
   push de                     ; save vector.size
   ex de,hl                    ; hl = vector.size
   
   ; bc = size_t n
   ; hl = vector.size
   ; de = & vector.size + 1b
   ; stack = size_t n, extra, vector.size
   
   add hl,bc                   ; hl = new_size = vector.size + n
   jp c, error_einval_zc - 3   ; if new_size > 64k
   
   ld c,l
   ld b,h                      ; bc = new_size
   
   pop hl
   ex (sp),hl                  ; hl = extra
   ex de,hl
   
   ; bc = new_size
   ; de = extra
   ; hl = & vector.size + 1b
   ; stack = size_t n, vector.size
   
   push hl                     ; save & vector.size + 1b
   
   call __0_vector_resize_extra
   
   pop hl                      ; hl = & vector.size + 1b
   pop de                      ; de = vector.size = idx of bytes added
   pop bc                      ; bc = size_t n
   
   jp c, error_zc              ; if resize failed
   
   ; vector growth succeeded
   
   ; bc = size_t n
   ; de = idx of bytes added
   ; hl = & vector.size + 1b
   
   dec hl
   dec hl                      ; hl = & vector.array + 1b
   
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a                      ; hl = vector.array
   
   add hl,de                   ; hl = & vector.array[idx]
   ret
