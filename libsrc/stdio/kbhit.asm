

	MODULE kbhit
        SECTION code_clib

        PUBLIC  kbhit
        PUBLIC  _kbhit
        PUBLIC  getch
        PUBLIC  _getch

        EXTERN  getk
        EXTERN  fgetc_cons


kbhit:
_kbhit:
	ld	hl,(kbhit_key)	; check if we've got a keypress pending
	ld	a,h
	or	l
	ret	nz		; we've got something pending
	call	getk		; read the keyboard
	ld	(kbhit_key),hl
	ret

getch:
_getch:
	ld	hl,(kbhit_key)
	ld	de,0
IF __CPU_8080__
	ex	de,hl
	ld	(kbhit_key),hl
	ex	de,hl
ELSE
	ld	(kbhit_key),de
ENDIF
	ld	a,h
	or	l
	ret	nz		; consume that keypress
	; We didn't have anything, lets just read the keyboard
	call	fgetc_cons
	ret

	SECTION	bss_clib

kbhit_key:	defw	0

