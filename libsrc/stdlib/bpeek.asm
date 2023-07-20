; uchar __FASTCALL__ bpeek(void *addr)
; 11.2006 aralbrec

SECTION code_clib
PUBLIC bpeek
PUBLIC _bpeek
PUBLIC bpeek_fastcall
PUBLIC _bpeek_fastcall

.bpeek
._bpeek
    pop de
    pop hl
    push hl
    push de
.bpeek_fastcall
._bpeek_fastcall

   ld l,(hl)
   ld h,0
   ret
