
SECTION code_clib
PUBLIC IM2CreateCommon
PUBLIC _IM2CreateCommon
PUBLIC _im2_hookDisp

.IM2CreateCommon
._IM2CreateCommon

   ld bc,_im2_hookDisp
   ldir
   add a,a
   inc a
   ld c,a
   ld l,e
   ld h,d
   inc de
   ld (hl),0
   ldir
   ex de,hl
   ret

DEFC _im2_hookDisp = 13   ; runhooks - GenericISR
