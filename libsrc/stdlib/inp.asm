; uchar __FASTCALL__ inp(uint port)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC inp
PUBLIC _inp

.inp
._inp

IF FORrcmx000

   defb 0d3h ; ioi
   ld a,(hl)
   ld h,0
   ld l,a

ELSE

   ld c,l
   ld b,h
   in l,(c)
   ld h,0

ENDIF

   ret
