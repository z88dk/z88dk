;
;	f_ansi_dline - clear line
;
;	djm 6/6/2000
;
;	Entry: a = row
;
;
;	$Id: f_ansi_dline.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;


	XLIB	ansi_dline


.ansi_dline
	push	af
	ld	a,1
	call_oz(os_out)
	ld	a,'3'
	call_oz(os_out)
	ld	a,'@'
	call_oz(os_out)
	pop	af
	add	32
	call_oz(os_out)
	ld	hl,rest
	call_oz(gn_sop)
	ret
.rest
	defb	32,1,'2','C',253,0
