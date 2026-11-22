; sccz80 crt0 library - 8080 version

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_mult
PUBLIC l_mult_u
PUBLIC l_mult_0

; HL = DE * HL [signed]
.l_mult
; HL = DE * HL [unsigned]
.l_mult_u
    LD      bc,hl

; HL = DE * BC [signed]
.l_mult_0
    LD      hl,0
ccmul1:
    LD      a,c
    RRCA
    JP      NC,ccmul2
    ADD     hl,de
ccmul2:
    XOR     a
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
