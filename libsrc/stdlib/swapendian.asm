; void __FASTCALL__ *swapendian(void *addr)
; 04.2006 aralbrec

SECTION code_clib
PUBLIC swapendian
PUBLIC _swapendian

.swapendian
._swapendian

   ld a,l
   ld l,h
   ld h,a
   ret
