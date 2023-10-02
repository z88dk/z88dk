; uchar __FASTCALL__ inp(uint port)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC inp
PUBLIC _inp
PUBLIC inp_fastcall
PUBLIC _inp_fastcall

inp:
_inp:
    pop     de
    pop     hl
    push    hl
    push    de

.inp_fastcall
._inp_fastcall

IF  __CPU_RABBIT__

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
