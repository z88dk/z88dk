; sccz80 crt0 library - 8080 version

                SECTION   code_crt0_sccz80
                PUBLIC    l_asr
		PUBLIC	  l_asr_hl_by_e

.l_asr
        ex      de,hl
.l_asr_hl_by_e
.l_asr1
        dec     e
        ret     m
IF __CPU_8085__
	sra	hl
ELSE
	ld	a,h
	rla
	ld	a,h
	rra
	ld	h,a
	ld	a,l
	rra
	ld	l,a
ENDIF
        jp      l_asr1

