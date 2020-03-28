; Internal library routine for openwindow, opentitled & openpopup
; 26/3/00 GWL


        SECTION code_clib

	PUBLIC	opwin
	include	"stdio.def"

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

.windef	defb	1		;wndow definer
	defm	"7#"
	defb	0
	
.winclr	defb	1		;window clear + reset modes
	defm	"2C"
	defb	0

.winmod	defb	1		;set default modes (cursor + scroll)
	defm	"3+CS"
	defb	0

