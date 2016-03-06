; uchar __FASTCALL__ bpeek(void *addr)
; 11.2006 aralbrec

SECTION code_clib
PUBLIC bpeek
PUBLIC _bpeek

.bpeek
._bpeek

   ld l,(hl)
   ld h,0
   ret
