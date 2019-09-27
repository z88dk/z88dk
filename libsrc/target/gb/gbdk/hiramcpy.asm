


        MODULE  hiramcpy

        PUBLIC  hiramcpy
        PUBLIC  _hiramcpy


        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

;void __LIB__ hiramcpy(uint8_t dst, const void *src, uint8_t n) NONBANKED;
_hiramcpy:
hiramcpy:
        PUSH    BC

        LD      HL,sp+8         ; Skip return address and registers
        LD      C,(HL)          ; C = dst
        LD      HL,sp+4
        LD      B,(HL)          ; B = n
        LD      HL,sp+6
        LD      A,(HL+)         ; HL = src
        LD      H,(HL)
        LD      L,A
        CALL    asm_hiramcpy
        POP     BC
        RET

asm_hiramcpy:
        LD      A,(HL+)
        LDH     (C),A
        INC     C
        DEC     B
        JR      NZ,asm_hiramcpy
        RET
