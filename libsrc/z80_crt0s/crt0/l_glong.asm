;       Z88 Small C+ Run Time Library 
;       Long functions
;

                SECTION   code_crt0_sccz80
		PUBLIC    l_glong
		PUBLIC    l_glonghlp


;Fetch long dehl from (hl)

.l_glonghlp
IF EZ80
   defb	0xed, 0x27		;ld hl,(hl)
ELSE
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
ENDIF

.l_glong

   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
IF EZ80
   defb	0xed, 0x27		;ld hl,(hl)
ELSE
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
ENDIF
   ex de,hl
   ret
