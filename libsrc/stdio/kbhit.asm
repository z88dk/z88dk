

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
IF __CPU_GBZ80__
	ld	hl,kbhit_key
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	or	h
	ret	nz
	call	getk
	ld	de,kbhit_key
	ld	a,l
	ld	(de),a
	inc	de
	ld	a,h
	ld	(de),a
ELSE
	ld	hl,(kbhit_key)	; check if we've got a keypress pending
	ld	a,h
	or	l
	ret	nz		; we've got something pending
	call	getk		; read the keyboard
	ld	(kbhit_key),hl
	ret
ENDIF

getch:
_getch:
IF __CPU_GBZ80__
	ld	hl,kbhit_key
	ld	a,(hl+)
	ld	e,a
	ld	d,(hl)
	xor	a
	ld	(hl-),a
	ld	(hl),a
	ld	h,d
	ld	l,e
ELSE
	ld	hl,(kbhit_key)
	ld	de,0
  IF __CPU_INTEL__
	ex	de,hl
	ld	(kbhit_key),hl
	ex	de,hl
  ELSE
	ld	(kbhit_key),de
  ENDIF
ENDIF
	ld	a,h
	or	l
	ret	nz		; consume that keypress
	; We didn't have anything, lets just read the keyboard
	call	fgetc_cons
	ret

	SECTION	bss_clib

kbhit_key:	defw	0

