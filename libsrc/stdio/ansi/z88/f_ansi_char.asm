;
;	Print a character at ansi_ROW, ansi_COLUMNUMN
;	Enter with char in a
;
;	djm 6/6/2000
;
;	This ain't pretty..we do far too many calls to oz for my liking..
;
;
;	$Id: f_ansi_char.asm,v 1.3 2001-05-02 09:21:51 dom Exp $
;

		XLIB ansi_char

		INCLUDE	"#stdio.def"

		XREF ansi_ROW
		XREF ansi_COLUMN
		XDEF text_rows
		XDEF text_cols


.text_rows	defb 8
.text_cols	defb 80


.ansi_char
	push	af
	ld	hl,start
	call_oz(gn_sop)
	ld	a,(ansi_COLUMN)
	add	a,32
	call_oz(os_out)
	ld	a,(ansi_ROW)
	add	a,32
	call_oz(os_out)
	pop	af
	call_oz(os_out)
	ret
.start
	defb	1,'3','@',0


