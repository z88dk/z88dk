
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
   
   add a,l
   jp pe, overflow
   ld l,a
   
   ld a,h
   adc a,0
   ld h,a
   
   add a,a
   sbc a,a
   xor h
   jr nz, overflow
   
   ld a,l
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
