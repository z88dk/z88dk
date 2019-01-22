;       Z88 Small C+ Run time Library
;       l_gint variant to be used sometimes by the peephole optimizer
;

                SECTION   code_crt0_sccz80
		PUBLIC l_glong2sp
		PUBLIC l_glong2sp_hlp

.l_glong2sp_hlp
IF EZ80
  	defb	0xed, 0x27	; ld hl,(hl)
ELSE 
        ld      a,(hl)
        inc     hl
        ld      h,(hl)
        ld      l,a
ENDIF
; Fetch long from hl and push to stack
.l_glong2sp
        ld	e,(hl)
        inc     hl
        ld	d,(hl)
	inc	hl
IF EZ80
  	defb	0xed, 0x27	; ld hl,(hl)
ELSE 
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
ENDIF
	ex	(sp),hl
	push	de
	jp	(hl)
