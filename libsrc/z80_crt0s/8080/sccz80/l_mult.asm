
SECTION code_crt0_sccz80

PUBLIC l_mult

; HL = DE * HL [signed]
l_mult:
ccmul:  LD      b,h
        LD      c,l
        LD     HL,0
ccmul1: LD      a,c
        RRCA
        JP      NC,ccmul2
        ADD     HL,DE
ccmul2: XOR     a
        LD      a,b
        RRA
        LD      b,a
        LD      a,c
        RRA
        LD      c,a
        OR     b
        RET     Z
        XOR     a
IF __CPU_8085__
        rl      de
        ld      a,d
ELSE
        LD      a,e
        RLA
        LD      e,a
        LD      a,d
        RLA
        LD      d,a
ENDIF
        OR     e
        RET     Z
        JP     ccmul1
