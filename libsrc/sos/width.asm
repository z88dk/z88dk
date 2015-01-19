;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; int width(columns)
;
;       $Id: width.asm,v 1.3 2015-01-19 01:33:07 pauloscustodio Exp $
;



PUBLIC width

width:
   ld	a,l
   jp	$2030
