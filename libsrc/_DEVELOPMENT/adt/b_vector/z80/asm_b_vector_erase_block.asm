
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t b_vector_erase_block(b_vector_t *v, size_t idx, size_t n)
;
; Remove bytes at indices [idx, idx+n) from the vector.
;
; ===============================================================

XLIB asm_b_vector_erase_block

LIB error_einval_mc, asm_memcpy

asm_b_vector_erase_block:

   ; enter : hl = b_vector_t *
   ;         bc = size_t idx
   ;         de = size_t n
   ;
   ; exit  : success
   ;
   ;            de = & vector.array[idx]
   ;            hl = idx = index of first byte following erased
   ;            carry reset
   ;
   ;         fail if block exceeds vector.array
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl

   inc hl
   inc hl
   
   ld a,(hl)
   inc hl
   
   push bc                     ; save idx
   push hl                     ; save & vector.size + 1b
   push de                     ; save n
   
   ld h,(hl)
   ld l,a
   
   ex de,hl                    ; de = vector.size, hl = n
   
   add hl,bc                   ; hl = idx + n
   jp c, error_einval_mc - 3   ; if (idx + n) > 64k

   scf
   sbc hl,de                   ; hl = idx + n - vector.size - 1
   jp nc, error_einval_mc - 3  ; if (idx + n) > vector.size

   ; de = vector.size
   ; stack = idx, & vector.size + 1b, n

   pop bc                      ; bc = n
   ex de,hl                    ; hl = vector.size
   
   or a
   sbc hl,bc                   ; hl = vector.size - n = new_size

   ; bc = n
   ; hl = new_size
   ; stack = idx, & vector.size + 1b
   
   pop de
   ex de,hl                    ; de = new_size, hl = & vector.size + 1b
   
   ld (hl),d
   dec hl
   ld (hl),e                   ; vector.size = new_size
   dec hl
   
   ld e,(hl)
   dec hl
   ld d,(hl)                   ; de = vector.array

   ; bc = n
   ; de = vector.array
   ; stack = idx
   
   pop hl
   push hl
   add hl,de

   ld e,l
   ld d,h                      ; de = & vector.array[idx]
   
   add hl,bc                   ; hl = & vector.array[idx+n]

   push de                     ; save & vector.array[idx]
   
   call asm_memcpy

   pop de                      ; de = & vector.array[idx]
   pop hl                      ; hl = idx
   
   ret
