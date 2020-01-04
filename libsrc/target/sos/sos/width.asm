;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; int width(columns)
;
;       $Id: width.asm,v 1.4 2016-06-19 20:58:00 dom Exp $
;


        SECTION   code_clib
PUBLIC width
PUBLIC _width

width:
_width:
   ld	a,l
   jp	$2030
