SECTION code_clib
SECTION code_adt_b_vector

PUBLIC __vector_make_room
PUBLIC __vector_make_room_extra

EXTERN error_zc
EXTERN __array_make_room, __0_array_make_room, __vector_realloc_grow

__vector_make_room:

   exx
   ld de,0
   exx

__vector_make_room_extra:

   ; Make room for n bytes at index idx (overwrite not insert).
   ; If idx > vector.size, zero the resulting hole.
   ;
   ; enter : de = & vector.size
   ;         hl = n
   ;         bc = idx
   ;         de'= extra
   ;
   ; exit  : de'= extra
   ;
   ;         success
   ;
   ;            hl = & vector.data[idx]
   ;            bc = n
   ;             a = 0 if realloc performed
   ;            carry reset
   ;            
   ;         fail if idx + n > 64k or max_size exceeded
   ;
   ;            hl = 0
   ;            carry set
   ;
   ;         fail if idx + n + extra > 64k or realloc failed
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
      
   call __array_make_room
   jr c, realloc_needed

   inc a
   ret

realloc_needed:

   or a
   jp z, error_zc

   ; de = & vector.size
   ; hl = n
   ; bc = idx
   ; de'= extra
   
   push hl                     ; save n
   push bc                     ; save idx
   
   add hl,bc                   ; hl = idx + n
   
   push hl                     ; save idx + n
   
   exx
   push de
   exx
   
   pop bc                      ; bc = extra
   
   add hl,bc                   ; hl = realloc_size = idx + n + extra
   jp c, error_zc - 3
   
   ld c,l
   ld b,h                      ; bc = realloc_size
   
   ex de,hl
   
   dec hl
   dec hl                      ; hl = vector *
   
   ; hl = vector *
   ; bc = realloc_size
   ; de'= extra
   ; stack = n, idx, idx + n
   
   call __vector_realloc_grow
   jp c, error_zc - 3
   
   ; hl = vector *
   ; de'= extra
   ; stack = n, idx, idx + n
   
   inc hl
   inc hl                      ; hl = & vector.size
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = old_size
   
   pop de                      ; de = new_size = idx + n
   
   ld (hl),d
   dec hl
   ld (hl),e                   ; vector.size = new_size
   inc hl

   ; hl = & vector.size + 1b
   ; bc = old_size
   ; de'= extra
   ; stack = n, idx

   jp __0_array_make_room
