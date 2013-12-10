
XLIB l_mulu_40_32x8
LIB l_mulu_16_8x8

l_mulu_40_32x8:

   ; multiply 32-bit and 8-bit number into 40-bit result
   ;
   ; enter : dehl = 32-bit multiplicand
   ;            a = 8-bit multiplicand
   ; 
   ; exit  : adehl = 40 bit product
   ;
   ; uses  : af, bc, de, hl, ixh
   
   ex de,hl                    ; HLDE = 32-bit multiplicand

   ld ixh,d
   ld c,e
   ld e,a
   ld a,l
   
   ;    HA(IXH)C = 32-bit multiplicand
   ; *         E = 8-bit multiplicand
   ;    --------
   ;          CE
   ;     (IXH)E
   ;        AE
   ; +     HE
   ;   ---------
   ;   sum = 40-bit product
   ;
   ; function l_mulu_16_8x8 returns hl=h*e
   
   call l_mulu_16_8x8
   push hl                     ; save HE
   
   ld h,a
   call l_mulu_16_8x8
   push hl                     ; save AE
   
   ld a,ixh
   ld h,a
   call l_mulu_16_8x8
   push hl                     ; save (IXL)E
   
   ld h,c
   call l_mulu_16_8x8          ; hl = CE
   
   pop de                      ; de = (IXL)E
   
   ld c,d                      ; bc = 0(IXL)
   ld d,e
   ld e,b                      ; de = E0
   
   add hl,de                   ; hl = CE + E0
   
   ex de,hl                    ; DE = lowest 16-bits of result
   
   pop hl                      ; hl = AE
   adc hl,bc                   ; hl = AE + 0(IXL) + carry
   
   ld a,l                      ; a = bits 16-23 of result
   ld c,h
   
   pop hl                      ; hl = HE
   adc hl,bc                   ; hl = top 16 bits of result
   
   ; result = HLADE
   ; to       AHLDE
   ; then     ADEHL
   
   ld c,l
   ld l,a
   ld a,h
   ld h,c
   
   ex de,hl
   ret
