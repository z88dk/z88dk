;
;   SEGA SC-3000 C Library
;
;	Print character to the screen
;
;	$Id: fputc_cons.asm,v 1.3+  (GIT) $
;

	  SECTION code_clib
          PUBLIC  fputc_cons_native

;
; Entry:        a= char to print
;


.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
IF STANDARDESCAPECHARS
	cp	10
ELSE
	cp	13
ENDIF
	jr	nz,nocr
	ld	a,13
	call	$2400
	ld	a,10
.nocr
	jp	$2400
