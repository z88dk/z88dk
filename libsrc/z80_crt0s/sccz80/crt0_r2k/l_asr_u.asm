; Crt0 for Rabbit
;
; Shift de right by hl bits
;
;
                SECTION   code_crt0_sccz80
                PUBLIC    l_asr_u

; Entry: hl = bit shift counter
;        de = value to shift
; Exit:  hl = result
;
.l_asr_u
	ex	de,hl
.l_asr_u_1
	dec	e
        ret     m
        and     a
	defb	0xfc	; rr hl
        jp      l_asr_u_1
