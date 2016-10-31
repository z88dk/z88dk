; 04.2006 aralbrec
; 01.2014 stefano

; void __FASTCALL__ zx_border(uchar colour)

SECTION code_clib
PUBLIC zx_border
PUBLIC _zx_border
	EXTERN	RG0SAV

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
   
   ld a,(RG0SAV)
   and	$c7
   or	e
   ld (RG0SAV),a
   
;   call p3_poke
   
   ret
