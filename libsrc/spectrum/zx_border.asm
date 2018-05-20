; 04.2006 aralbrec
; 01.2014 stefano

; void __FASTCALL__ zx_border(uchar colour)

SECTION code_clib
PUBLIC zx_border
PUBLIC _zx_border

EXTERN __PORT254COPY

zx_border:
_zx_border:

   in a,(254)
   and $40
   
   rra
   rra
   or l
   
   out (254),a
   and 7
   rla
   rla
   rla
   ld	e,a
   ld	a,(__PORT254COPY)
   and	$c7
   or	e
   ld  (__PORT254COPY),a
   
   ret
