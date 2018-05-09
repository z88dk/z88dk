;
; 	ANSI Video handling for the MSX
;
; 	Handles colors
;
;	Scrollup
;
;	Stefano Bodrato - Sept. 2017
;
;	$Id: f_ansi_scrollup_nobios.asm $
;

        SECTION  code_clib
	PUBLIC	ansi_SCROLLUP
	EXTERN	msx_attr
	
IF FORm5
	INCLUDE "target/m5/def/m5bios.def"
ELSE
	EXTERN	LDIRVM
	EXTERN	LDIRMV
	EXTERN	FILVRM
ENDIF
	
.ansi_SCROLLUP
	push ix
	
	ld b,23
	ld	hl,256

.scloop
	push bc
	
	push hl
	ld	de,line_buffer
	ld	bc,256
	;ex de,hl
	call	LDIRMV
	pop hl
	push hl
	
	ld de,-256
	add hl,de
	
	ld	de,line_buffer
	ld bc,256
	ex de,hl
	call	LDIRVM
	
	
	pop hl
	push hl
	
	ld de,8192
	add hl,de
	push hl
	ld	de,line_buffer
	ld	bc,256
	;ex de,hl
	call	LDIRMV
	pop hl
	ld de,-256
	add hl,de
	ld	de,line_buffer
	ld bc,256
	ex de,hl
	call	LDIRVM
	
	
	
	pop hl
	inc h
	;ld de,256
	;add hl,de

	pop bc
	djnz scloop

	dec h
	xor a
	ld bc,256
	call	FILVRM
	
	
	pop ix

	ret
 

	SECTION bss_clib	
	
.line_buffer			defs 256
