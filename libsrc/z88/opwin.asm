; Internal library routine for openwindow, opentitled & openpopup
; 26/3/00 GWL

	XLIB	opwin
	include	"#stdio.def"

.opwin	ld	hl,windef
	call_oz(gn_sop)
	ld	a,(ix+10)	; window ID 
	add	a,'0'
	call_oz(os_out)
	ld	a,(ix+8)	; tlx
	add	a,$20
	call_oz(os_out)
	ld	a,(ix+6)	; tly
	add	a,$20
	call_oz(os_out)
	ld	a,(ix+4)	; width
	add	a,$20
	call_oz(os_out)
	ld	a,(ix+2)	; height
	add	a,$20
	call_oz(os_out)
	ld	a,b		; type
	call_oz(os_out)
	ld	hl,winclr
	call_oz(gn_sop)
	ld	a,(ix+10)
	add	a,'0'
	call_oz(os_out)		; clear & select window
	ld	hl,winmod
	call_oz(gn_sop)		; set default modes
	ret

.windef	defm	1&"7#"&0	; window definer
.winclr	defm	1&"2C"&0	; window clear & reset modes
.winmod	defm	1&"3+CS"&0	; set default modes (cursor & scroll)

