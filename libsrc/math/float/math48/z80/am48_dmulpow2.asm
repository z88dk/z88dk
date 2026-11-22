
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dmulpow2

EXTERN am48_derror_znc, am48_derror_erange_infc

am48_dmulpow2:

   ; multiply AC' by a power of two
   ; AC' *= 2^(HL)
   ;
   ; enter : AC'= double x
   ;         HL = signed integer
   ;
   ; exit  : success
   ;
   ;            AC'= x * 2^(HL)
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC'= +-inf
   ;            carry set, errno set
   ;
   ; uses  : af, bc', de', hl'

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
   
   jp nz, am48_derror_znc
   jp am48_derror_erange_infc
