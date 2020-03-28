; 04.2006 aralbrec
; 01.2014 stefano

; void __FASTCALL__ zx_border(uchar colour)

SECTION code_clib
PUBLIC zx_border
PUBLIC _zx_border

EXTERN __SYSVAR_BORDCR

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
   ld	a,(__SYSVAR_BORDCR)
   and	$c7
   or	e
   ld  (__SYSVAR_BORDCR),a
   
   ret
