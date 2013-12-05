;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; int width(columns)
;
;       $Id: width.asm,v 1.2 2013-12-05 09:34:01 stefano Exp $
;



XLIB width

width:
   ld	a,l
   jp	$2030
