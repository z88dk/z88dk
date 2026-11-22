SECTION code_clib
SECTION code_adt_b_vector

PUBLIC __vector_realloc_grow
PUBLIC __0_vector_realloc_grow

EXTERN asm_realloc, error_zc

__vector_realloc_grow:

   ; Expand vector.data to hold n bytes
   ;
   ; enter : hl = vector *
   ;         bc = n
   ;
   ; exit  : bc = n
   ;
   ;         success
   ;
   ;            vector.capacity = n
   ;            hl = vector *
   ;            de = vector.data
   ;            carry reset
   ;
   ;         fail if max_size exceeded
   ;
   ;            hl = 0
   ;            de = & vector.capacity + 1b
   ;            
   ;            carry set
   ;
   ;         fail if realloc failed
   ;
   ;            hl = 0
   ;            de = & vector.capacity + 1b
   ;            carry set
   ;
   ;
   ; uses  : af, de, hl
   
   ld de,7
   add hl,de                   ; hl = & vector.max_size + 1b

__0_vector_realloc_grow:

   ; carry reset

   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = vector.max_size
   dec hl
   
   ex de,hl                    ; hl = vector.max_size
   
   sbc hl,bc                   ; hl = vector.max_size - n
   jp c, error_zc              ; if n > vector.max_size
   
   push de                     ; save & vector.capacity + 1b
   
   ld hl,-5
   add hl,de                   ; hl = vector *
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = vector.data
   
   ; hl = vector.data
   ; bc = n
   ; stack = & vector.capacity + 1b
   
   push bc
   
   call asm_realloc

   pop bc
   jp c, error_zc - 1          ; if realloc error
   
   ; hl = new vector.data
   ; bc = n
   ; stack = & vector.capacity + 1b
   
   pop de
   ex de,hl
   
   ld (hl),b
   dec hl
   ld (hl),c                   ; vector.capacity = n
   
   dec hl
   dec hl
   dec hl                      ; hl = & vector.data + 1b
   
   ld (hl),d
   dec hl
   ld (hl),e                   ; vector.data = new vector.data
   
   ret
