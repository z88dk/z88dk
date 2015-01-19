; 04.2006 aralbrec
; 01.2014 stefano

; void __FASTCALL__ zx_border(uchar colour)

PUBLIC zx_border

zx_border:

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
   ld	a,(23624)
   and	$c7
   or	e
   ld  (23624),a
   
   ret
