;
;       VZ700 C Library
;
;	Print character to the screen
;

	  SECTION code_clib
	  MODULE  fputc_cons_native
          PUBLIC  fputc_cons_native


.fputc_cons_native
	ld	hl,2
	add	hl,sp
	push	ix		;Save callers
	ld	a,(hl)
	
IF STANDARDESCAPECHARS
	cp  10
	jr  nz,notCR
	call	$57d9
	ld	a,13
	jr setout
.notCR
ENDIF

.setout
	call	$57d9		;CHROUT, print charater in a
	pop	ix
	ret

