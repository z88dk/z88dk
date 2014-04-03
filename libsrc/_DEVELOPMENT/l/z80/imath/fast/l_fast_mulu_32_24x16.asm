
XLIB l_fast_mulu_32_24x16

LIB l0_fast_mulu_32_24x8, l_fast_mulu_32_24x8, error_mulu_overflow_mc

l_fast_mulu_32_24x16:

   ; unsigned multiplication of 24-bit and 16-bit
   ; multiplicands into a 40-bit product
   ;
   ; error reported on overflow
   ; 
   ; enter : ehl = 24-bit multiplicand
   ;          bc = 16-bit multiplicand
   ;
   ; exit  : success
   ;
   ;            dehl = 32-bit product
   ;            carry reset
   ;
   ;         unsigned overflow
   ;
   ;            dehl = $ffffffff = ULONG_MAX
   ;            carry set, errno = ERANGE
   
   ; uses  : af, bc, de, hl

   ; split into two multiplications

   ld d,c
   push hl
   push de                     ; save HLCE
   
   ld a,b
   call l0_fast_mulu_32_24x8        ; dehl = B * EHL
   
   inc d
   dec d
   jr nz, overflow_0

   ; shift left 8 bits
   
   ld d,l
   ld l,h
   ld h,e
   ld e,a                      ; hlde = B * EHL << 8
   
   pop bc                      ; bc = CE
   ex (sp),hl                  ; hl = HL
   push de
   
   ld a,c
   ld e,b
   call l_fast_mulu_32_24x8         ; dehl = C * EHL

   ; add the two results
   
   pop bc
   add hl,bc
   
   ex de,hl
   
   pop bc
   adc hl,bc
   
   jr c, overflow_1
   
   ex de,hl
   ret

overflow_0:

   pop de
   pop hl
   
overflow_1:

   call error_mulu_overflow_mc
   
   ld e,l
   ld d,h
   
   ret
