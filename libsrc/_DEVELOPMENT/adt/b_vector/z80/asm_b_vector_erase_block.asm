
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t b_vector_erase_block(b_vector_t *v, size_t idx, size_t n)
;
; Remove bytes at indices [idx, idx+n) from the vector by copying
; data backward and adjusting vector.size.
;
; ===============================================================

XLIB asm_b_vector_erase_block

LIB asm_memcpy, error_einval_mc, l_neg_hl

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
   ;         fail if block at least partly extends outside vector.array
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl

   inc hl
   inc hl
   
   ld a,(hl)
   inc hl
   
   push bc                     ; save size_t idx
   push hl                     ; save & vector.size + 1b
   push de                     ; save size_t n
   
   ld h,(hl)
   ld l,a
   
   ex de,hl                    ; de = vector.size, hl = size_t n
   
   add hl,bc                   ; hl = idx + n
   jp c, error_einval_mc - 3   ; if (idx + n) > 64k

   sbc hl,de                   ; hl = idx + n - vector.size
   jp nc, error_einval_mc - 3  ; if (idx + n) >= vector.size

   call l_neg_hl               ; hl = vector.size - (idx + n)

   ; de = vector.size
   ; hl = num bytes to copy
   ; stack = size_t idx, & vector.size + 1b, size_t n

   pop bc                      ; bc = size_t n
   ex de,hl                    ; hl = vector.size
   
   or a
   sbc hl,bc                   ; hl = vector.size - n = new_size

   ; bc = size_t n
   ; hl = new_size
   ; de = num bytes to copy
   ; stack = size_t idx, & vector.size + 1b
   
   ex de,hl                    ; de = new_size
   ex (sp),hl                  ; hl = & vector.size + 1b
   
   ld (hl),d
   dec hl
   ld (hl),e                   ; vector.size = new_size

   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = vector.array

   ; bc = size_t n
   ; de = vector.array
   ; stack = size_t idx, num bytes to copy

   pop af
   pop hl
   push hl
   push af
   
   ; bc = size_t n
   ; de = vector.array
   ; hl = size_t idx
   ; stack = size_t idx, num bytes to copy
   
   add hl,de                   ; hl = idx + vector.array

   ld e,l
   ld d,h                      ; de = & vector.array[idx]
   
   add hl,bc                   ; hl = & vector.array[idx+n]

   pop bc                      ; bc = num bytes to copy
   
   push de                     ; save & vector.array[idx]
   
   call asm_memcpy

   pop de                      ; de = & vector.array[idx]
   pop hl                      ; hl = idx
   
   ret
