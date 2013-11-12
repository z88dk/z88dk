;
;	Sharp X1 specific routines
;   switch to 80 columns text mode
;	Uses high resolution text if available
;
;	$Id: x1_set_text_80.asm,v 1.1 2013-11-12 13:50:16 stefano Exp $
;

	XLIB	x1_set_text_80
	LIB		x1_get_pcg_version
	LIB		set_crtc_10
	XREF	text_cols


t80v1:
	defb 6Fh, 50h, 59h, 38h, 1Fh, 02h, 19h, 1Ch, 00h, 07h
t80v2:
	defb 6Bh, 50h, 59h, 88h, 1Bh, 02h, 19h, 1Ah, 00h, 0Fh

x1_set_text_80:

		call	x1_get_pcg_version
		ld		a,l
		dec		a
		push	af
		jr		nz,pcgv2
		ld		hl,t80v1
		jr		set_vmode
pcgv2:
		ld		hl,t80v2
set_vmode:
		call	set_crtc_10
		pop		af
		jr		z,x1mode	; low resolution text (16khz, ...)
		ld		a,3			; high resolution text (16khz, ...)
x1mode:
		ld		bc,1FD0h
		out		(c),a

		ld		a,80
		ld		(text_cols),a

		ret
