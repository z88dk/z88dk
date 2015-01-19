; void __FASTCALL__ *swapendian(void *addr)
; 04.2006 aralbrec

PUBLIC swapendian

.swapendian

   ld a,l
   ld l,h
   ld h,a
   ret
