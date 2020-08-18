
	SECTION	code_crt0_sccz80
	PUBLIC	l_mult

; Multiply two 16 bit numbers hl=hl*de ((un)signed)
.l_mult
        ld      b,16
        ld      a,h
        ld      c,l
        ld      hl,0
.l_mult1
        add     hl,hl
        rl      c
        rla                     ;DLE 27/11/98
        jr      nc,l_mult2
        add     hl,de
.l_mult2
        djnz    l_mult1
        ret
