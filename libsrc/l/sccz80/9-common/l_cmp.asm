;
;	Z80 Runtime Library
;
;	Signed integer compare
;
;	$Id: l_cmp.asm,v 1.5 2015-12-03 01:11:39 aralbrec Exp $:

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_cmp

l_cmp:

   ; signed compare of DE and HL
   ;   carry is sign of difference [set => DE < HL

   ;   zero is zero/non-zero

   ld a,h
   add a,$80
   ld b,a
   
   ld a,d
   add a,$80
   
   cp b
   ret nz
   
   ld a,e
   cp l
   
   ret
