;
; 	ANSI Video handling for the MSX
;
; 	Handles colors
;
;	Scrollup
;
;	Stefano Bodrato - Oct. 2017
;
;	$Id: f_ansi_scrollup.asm $
;

        SECTION  code_clib
	PUBLIC	ansi_SCROLLUP
	EXTERN	msx_attr
	
IF FORmsx
		EXTERN     msxbios
        INCLUDE "arch/msx/def/msxbios.def"
ELSE
IF FORsvi
		EXTERN     msxbios
        INCLUDE "arch/svi/def/svibios.def"
ENDIF
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
	ld	ix,LDIRMV
	call	msxbios
	pop hl
	push hl
	
	ld de,-256
	add hl,de
	
	ld	de,line_buffer
	ld bc,256
	ex de,hl
	ld	ix,LDIRVM
	call	msxbios
	
	
	pop hl
	push hl
	
	ld de,8192
	add hl,de
	push hl
	ld	de,line_buffer
	ld	bc,256
	;ex de,hl
	ld	ix,LDIRMV
	call	msxbios
	pop hl
	ld de,-256
	add hl,de
	ld	de,line_buffer
	ld bc,256
	ex de,hl
	ld	ix,LDIRVM
	call	msxbios
	
	
	
	pop hl
	inc h
	;ld de,256
	;add hl,de

	pop bc
	djnz scloop

	dec h
	xor a
	ld bc,256
	ld	ix,FILVRM
	call	msxbios
	
	
	pop ix

	ret
 

	SECTION bss_clib	
	
.line_buffer			defs 256
