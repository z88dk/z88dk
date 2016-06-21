; void __FASTCALL__ ts_vmod(uchar mode)
; 02.2008 aralbrec

SECTION code_clib
PUBLIC ts_vmod
PUBLIC _ts_vmod

.ts_vmod
._ts_vmod

   ld a,l
   and $3f
   xor $38                     ; invert paper bits to settings expected by port $ff
   ld l,a
   
   in a,($ff)
   and $c0                     ; preserve current local bank selection and interrupt state
   or l
   out ($ff),a
   
   ret
