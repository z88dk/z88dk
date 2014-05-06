;
;       Philips P2000 Graphics Functions
;
;       cls ()  -- clear screen
;
;       Stefano Bodrato - Apr 2014
;
;
;       $Id: clsgraph.asm,v 1.1 2014-05-06 06:01:48 stefano Exp $
;


        XLIB    cleargraphics
		XREF	base_graphics

.cleargraphics
;	ld		a,12
;	call  $60C0     ; cls
	
	ld    hl,(base_graphics)
	ld    c,23
gfxset:
	ld    (hl),23	; Set graph mode modifier at the beginning of the text rows
	inc   hl
	ld    b,79
gfxrow:
	ld    (hl),32
	inc   hl
	djnz  gfxrow
	dec   c
	jr    nz,gfxset
	
	ret

