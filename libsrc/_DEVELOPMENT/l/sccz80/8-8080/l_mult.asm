; sccz80 crt0 library - 8080 version

SECTION code_crt0_sccz80

PUBLIC l_mult

; HL = DE * HL [signed]
.l_mult
ccmul:  LD      b,h
        LD      c,l
        LD      hl,0
ccmul1: LD      a,c
        RRCA
        JP      NC,ccmul2
        ADD     hl,de
ccmul2: XOR     a
        LD      a,b
        RRA
        LD      b,a
        LD      a,c
        RRA
        LD      c,a
        OR      b
        RET     Z

        XOR     a
        LD      a,e
        RLA
        LD      e,a
        LD      a,d
        RLA
        LD      d,a
        OR      e
        RET     Z
        JP      ccmul1
