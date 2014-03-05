
XLIB __vector_reserve
XDEF __vector_reserve_extra

LIB asm_realloc
LIB error_znc, error_zc, error_mnc, error_einval_zc

__vector_reserve:

   ld de,0

__vector_reserve_extra:

   ; Adjust the vector's capacity by growing the vector's array
   ; with realloc as necessary.  Vector.size is not altered,
   ; vector.capacity changed only if capacity is increased.
   ;
   ; enter : bc = new_capacity
   ;         de = extra
   ;         hl = & vector.size + 1b
   ;
   ; exit  : bc = new_capacity
   ;         de = & vector.capacity + 1b
   ;
   ;         success if new_capacity <= vector.capacity
   ;
   ;            hl = 0 (indicates no realloc performed)
   ;            carry reset (success) 
   ;
   ;         success if vector growth via realloc is successful
   ;
   ;            hl = -1 (indicates realloc performed)
   ;            vector.capacity = new_capacity + extra bytes
   ;            carry reset (success)
   ;
   ;         fail if vector growth > vector.max_capacity or growth > 64k
   ;
   ;            hl = 0 (indicates no realloc performed)
   ;            carry set (fail), errno = EINVAL
   ;
   ;         fail if vector growth via realloc is unsuccessful
   ;
   ;            hl = 0 (indicates no realloc performed)
   ;            carry set (fail), errno set by realloc
   ;
   ; uses  : af, de, hl

   push de                     ; save extra

   inc hl
   
   ld e,(hl)
   inc hl                      ; hl = & vector.capacity + 1b
   ld d,(hl)                   ; de = vector.capacity
   
   ex de,hl                    ; hl = vector.capacity
   
   or a
   sbc hl,bc                   ; hl = vector.capacity - new_capacity
   jp nc, error_znc - 1        ; if vector.capacity >= new_capacity, indicate success
   
   ; vector capacity exceeded, try to realloc the vector array
   
   ; bc = new_capacity
   ; de = & vector.capacity + 1b
   ; stack = extra
   
   pop hl                      ; hl = extra
   
   add hl,bc                   ; hl = realloc_size = new_capacity + extra
   jp c, error_einval_zc       ; if realloc_size > 64k, indicate failure

   push hl                     ; save realloc_size
   push bc                     ; save new_capacity
   
   ld c,l
   ld b,h                      ; bc = realloc_size
   
   ex de,hl                    ; hl = & vector.capacity + 1b
   
   inc hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = vector.max_capacity
   
   dec hl
   dec hl
   
   ex de,hl                    ; hl = vector.max_capacity
   
   ; bc = realloc_size
   ; de = & vector.capacity + 1b
   ; hl = vector.max_capacity
   ; stack = realloc_size, new_capacity
   ; carry reset
   
   sbc hl,bc                   ; hl = vector.max_capacity - realloc_size
   jr c, error_max_reached     ; if realloc_size > vector.max_capacity
   
   ; vector growth is ok, now try to realloc
      
   ld hl,-5
   add hl,de                   ; hl = & vector.array
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = vector.array
   
   ex de,hl                    ; hl = vector.array
   push de                     ; save & vector.array + 1b
   
   ; bc = realloc_size
   ; hl = vector.array
   ; stack = realloc_size, new_capacity, & vector.array + 1b
   
   call asm_realloc            ; hl = new_array
   
   pop de
   ex de,hl                    ; hl = & vector.array + 1b, de = new_array
   jr c, error_realloc         ; if realloc failed
   
   ; de = new_array
   ; hl = & vector.array + 1b
   ; stack = realloc_size, new_capacity
   
   ld (hl),d
   dec hl
   ld (hl),e                   ; vector.array = new_array
   
   ld de,4
   add hl,de                   ; hl = & vector.capacity
   
   pop bc                      ; bc = new_capacity
   pop de                      ; de = realloc_size
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; vector.capacity = realloc_size
   
   ex de,hl                    ; de = & vector.capacity + 1b
   
   ; bc = new_capacity
   ; de = & vector.capacity + 1b
   
   jp error_mnc                ; indicate realloc took place

error_max_reached:

   ; requested capacity would exceed vector's max_capacity

   ; de = & vector.capacity + 1b
   ; stack = realloc_size, new_capacity

   pop bc                      ; bc = new_capacity
   jp error_einval_zc - 1      ; indicate error

error_realloc:

   ; realloc was unable to acquire memory

   ; hl = & vector.array + 1b
   ; stack = realloc_size, new_capacity

   ld de,4
   add hl,de
   ex de,hl                    ; de = & vector.capacity + 1b
   
   pop bc                      ; bc = new_capacity
   jp error_zc - 1             ; indicate error
