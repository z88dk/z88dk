;       Z88 Small C+ Run Time Library 
;       Long functions
;

SECTION code_clib
SECTION code_l_sccz80
PUBLIC    l_long_or

; "or" primary and secondary into dehl
; dehl = primary
; stack = secondary, ret
; Conventional way = 38T +ix (RCM), this way 36T + ix

.l_long_or

   pop ix
   ld	b,d	;2
   ld	c,e	;2
   pop 	de	;7
   or	hl,de	;2
   ld	d,b	;2
   ld   e,c	;2
   ld   b,h	;2
   ld   c,l	;2
   pop	hl	;7
   or	hl,de	;2
   ex   de,hl	;2
   ld   h,b	;2
   ld   l,c	;2
   jp	(ix)

