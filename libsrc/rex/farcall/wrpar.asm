;
;	Far Call for REX6000
;
;	WritePar function to write parameters to a save place
;	Daniel
;

		XLIB	wrpar
		XREF	far_par1
		XREF	far_par2
		XREF	far_par3
		XREF	far_par4


.wrpar
	ld	ix,2
	add	ix,sp
	ld	l,(ix+0)
	ld	h,(ix+1)
	ld	(far_par4),hl
	ld	l,(ix+2)
	ld	h,(ix+3)
	ld	(far_par3),hl
	ld	l,(ix+4)
	ld	h,(ix+5)
	ld	(far_par2),hl
	ld	l,(ix+6)
	ld	h,(ix+7)
	ld	(far_par1),hl
	ret



