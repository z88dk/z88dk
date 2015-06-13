
SECTION code_fp_math48

PUBLIC lm48__twof

EXTERN lm48__float_error_znc, lm48__float_error_erange_pinfc

lm48__twof:

   ; AC' = AC' * 2^(HL)
   ;
   ; uses : af, bc', de', hl'
   
   push hl
   
   exx
   
   ld a,l
   ex (sp),hl
   
   or a
   jr z, zero
   
   sub $80
   
   push bc
   
   ld c,a
   add a,a
   sbc a,a
   ld b,a
   
   add hl,bc
   
   pop bc
   
   ld a,l
   add a,a
   sbc a,a
   xor h
   jr nz, overflow
   
   ld a,l
   add a,$80
   jr z, overflow

zero:

   pop hl
   ld l,a

   exx
   ret

overflow:

   bit 7,h
   pop hl
   
   exx
   
   jp nz, lm48__float_error_znc
   jp lm48__float_error_erange_pinfc
