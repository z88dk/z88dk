
; ===============================================================
; Feb 2014
; ===============================================================
; 
; int b_vector_reserve(b_vector_t *v, size_t n)
;
; Allocate at least n bytes for the vector's array.
;
; If the array is already larger, do nothing.
;
; ===============================================================

XLIB asm_b_vector_reserve

LIB error_znc, error_einval_mc, asm_realloc, error_mc

asm_b_vector_reserve:

   ; enter : hl = b_vector_t *
   ;         bc = size_t n = reserve
   ;
   ; exit  : success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl
   
   ld de,4
   add hl,de
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   
   ex de,hl                    ; hl = vector.capacity
   
   sbc hl,bc                   ; hl = vector.capacity - reserve
   jp nc, error_znc            ; if vector.capacity >= reserve

   ex de,hl
   inc hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   
   ex de,hl                    ; hl = vector.max_size
   
   or a
   sbc hl,bc                   ; hl = vector.max_size - reserve
   jp c, error_einval_mc       ; if vector.max_size < reserve
   
   ; attempt to allocate a larger array
   
   ; bc = reserve
   ; hl = & vector.max_size + 1b

   ld de,-6
   add hl,de
   
   ld e,(hl)
   dec hl
   ld d,(hl)
   
   push hl                     ; save b_vector_t *
   push bc                     ; save reserve
   
   ex de,hl                    ; hl = vector.array
   call asm_realloc
   ex de,hl                    ; de = new_array
   
   pop bc                      ; bc = reserve
   pop hl                      ; hl = b_vector_t *
   
   jp c, error_mc              ; if realloc failed

   ld (hl),e
   inc hl
   ld (hl),d                   ; vector.array = new_array
   inc hl
   
   inc hl
   inc hl
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; vector.capacity = reserve
   
   jp error_znc
