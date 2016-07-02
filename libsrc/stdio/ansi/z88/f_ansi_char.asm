;
;	Print a character at ansi_ROW, ansi_COLUMNUMN
;	Enter with char in a
;
;	djm 6/6/2000
;
;	This ain't pretty..we do far too many calls to oz for my liking..
;
;
;	$Id: f_ansi_char.asm,v 1.7 2016-07-02 10:24:35 dom Exp $
;

		SECTION	code_clib
		PUBLIC ansi_CHAR

		INCLUDE	"stdio.def"

		EXTERN ansi_ROW
		EXTERN ansi_COLUMN
		PUBLIC text_rows
		PUBLIC text_cols


.text_rows	defb 8
.text_cols	defb 80


.ansi_CHAR
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


