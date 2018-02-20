;
; Read the spectrum keyboard without needing the ROM interrupt
;
; Lifted from newlib
;


		SECTION	code_clib
		PUBLIC	fgetc_cons_inkey
		PUBLIC	_fgetc_cons_inkey

		EXTERN in_GetKey

.fgetc_cons_inkey
._fgetc_cons_inkey
   call in_GetKey	; get intial keypress

   jr	c,fgetc_cons_inkey	;just keep looping
   ld	a,l
   cp	13
   jr	nz,notCR
   ld   l,10
notCR:
   cp   10
   jr   nz,notLF
   ld   l,13
notLF:
   cp   4		;EOF
   ret  nz
   ld	hl,-1
   ret
