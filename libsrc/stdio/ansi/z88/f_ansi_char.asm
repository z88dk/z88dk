;
;	Print a character at ansi_ROW, ansi_COLUMN
;	Enter with char in a
;
;	djm 6/6/2000
;
;	This ain't pretty..we do far too many calls to oz for my liking..
;
;
;	$Id: f_ansi_char.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;

		XLIB ansi_char

		XREF ansi_ROW
		XREF ansi_COL

.ansi_char
	push	af
	ld	hl,start
	call_oz(gn_sop)
	ld	a,(ansi_ROW)
	add	32
	call_oz(os_out)
	ld	a,(ansi_COL)
	add	32
	call_oz(os_out)
	pop	af
	call_oz(os_out)
	ret
.start
	defb	1,'3','@',0


