
XLIB __vector_back

LIB error_einval_mc

__vector_back:

   ; enter : hl = vector *
   ;
   ; exit  : success
   ;
   ;            bc = vector.size
   ;            de = vector.array
   ;            hl = & vector.size + 1b
   ;            carry reset
   ;
   ;         fail if vector is empty
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, de, hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = vector.array
   inc hl
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = vector.size

   ld a,b
   or c
   ret nz
   
   jp error_einval_mc          ; if vector is empty
