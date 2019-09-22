
        MODULE  jpad

        PUBLIC  asm_jpad


        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

        ;; Get Keypad Button Status
        ;; The following bits are set if pressed:
        ;;   0x80 - Start   0x08 - Down
        ;;   0x40 - Select  0x04 - Up
        ;;   0x20 - B       0x02 - Left
        ;;   0x10 - A       0x01 - Right
asm_jpad:
        PUSH    BC              ; Save modified registers
        LD      A,0x20
        LDH     (P1),A         ; Turn on P15

        LDH     A,(P1)         ; Delay
        LDH     A,(P1)
        CPL
        AND     0x0F
        SWAP    A
        LD      B,A
        LD      A,0x10
        LDH     (P1),A         ; Turn on P14
        LDH     A,(P1)         ; Delay
        LDH     A,(P1)
        LDH     A,(P1)
        LDH     A,(P1)
        LDH     A,(P1)
        LDH     A,(P1)
        CPL
        AND     0x0F
        OR      B
        SWAP    A
        LD      B,A
        LD      A,0x30
        LDH     (P1),A         ; Turn off P14 and P15 (reset joypad)
        LD      A,B
        POP     BC              ; Restore registers
        RET
