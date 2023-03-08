;
;       Philips VG-5000 C Library
;
;	Print character to the screen
;
;       We will corrupt any register
;
;
;	$Id: fputc_cons.asm$
;

	  SECTION code_clib
          PUBLIC  fputc_cons_native

;
; Entry:        hl points char to print
;



.fputc_cons_native
	ld	hl,2
	add	hl,sp

  
	ld	a,(hl)

	push    iy
	ld      iy,$47FA                ;iy -> ix (it must point to the BASIC system variables, IX+0=INTDIV)
	
	cp	7
	jr	nz,nobel
	ld	a,14
	jr setout

.nobel

	cp	12
	jr	nz,nocls
	ld	a,31
	jr setout

.nocls

IF STANDARDESCAPECHARS
	cp  10
	jr  nz,notCR
	ld	a,13
;	jr setout
.notCR
ENDIF


.setout
	rst $18

	pop iy
	ret

