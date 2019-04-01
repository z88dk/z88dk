; void bordercolor(int c) __z88dk_fastcall;
;
;

		SECTION		code_clib
		PUBLIC		bordercolor
		PUBLIC		_bordercolor

		EXTERN		conio_map_colour

		INCLUDE		"target/laser500/def/laser500.def"	

bordercolor:
_bordercolor:
	ld	a,l
	call	conio_map_colour
	rlca
	rlca
	rlca
	rlca
	and	@11110000
	ld	e,a
	ld	hl,SYSVAR_port44
	ld	a,(hl)
	and	@00001111
	or	e
	ld	(hl),a
	out	($44),a
	ret
