
XLIB __vector_at

LIB l_ltu_bc_hl, error_einval_mc

__vector_at:

   ; return & vector.array[idx]
   ;
   ; enter : hl = vector *
   ;         bc = size_t idx (index in bytes)
   ;
   ; exit  : bc = size_t idx
   ;         de = vector.size
   ;
   ;         success
   ;
   ;            hl = & vector.array[idx]
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, de, hl

   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = void *array
   inc hl
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = size
   
   call l_ltu_bc_hl
   jp nc, error_einval_mc      ; if bc >= hl, idx >= size
   
   ex de,hl
   add hl,bc

   ret
