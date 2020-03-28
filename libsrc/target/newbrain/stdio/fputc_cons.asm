;
; 	Basic video handling for the Grundy Newbrain
;	By Stefano Bodrato May 2005
;
;	(HL)=char to display
;
;
;	$Id: fputc_cons.asm,v 1.5+ (now on GIT) $
;
	SECTION code_clib
	PUBLIC	fputc_cons_native

.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	
	cp	12
	jr	nz,nocls
	ld	a,31		; clear screen
.nocls

; This fix works for 80 columns, but it wouldn't scroll anymore in default mode
;
;	cp	13
;	jr	nz,nocrlf
;	ld	a,10		; line feed
;	call	doprint
;	ld	a,$1c		; cursor home left (13 wasn't good in 80 columns mode)
;.nocrlf

IF STANDARDESCAPECHARS
	cp	10
	jr	nz,nocrlf
	call doprint
	ld	a,13
ELSE
        cp 13
	jr      nz,nocrlf
	call doprint
	ld      a,10
ENDIF
.nocrlf

.doprint
	ld	e,0
	rst	20h
	defb	30h
	ret
