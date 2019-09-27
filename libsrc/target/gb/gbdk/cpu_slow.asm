;       .title  "CGB support"
;       .module CGB

        MODULE  cpu_slow

        PUBLIC  cpu_slow
        PUBLIC  _cpu_slow
        PUBLIC  cpu_fast
        PUBLIC  _cpu_fast

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

;void __LIB__ cpu_slow(void);
;void __LIB__ cpu_fast(void);
cpu_slow:                     ; Banked
_cpu_slow:                     ; Banked
        LDH     A,(KEY1)
        AND     0x80           ; Is GBC in double speed mode?
        RET     Z               ; No, already in single speed

shift_speed:
        LDH     A,(IE)
        PUSH    AF

        XOR     A               ; A = 0
        LDH     (IE),A         ; Disable interrupts
        LDH     (IF),A

        LD      A,0x30
        LDH     (P1),A

        LD      A,0x01
        LDH     (KEY1),A

        STOP

        POP     AF
        LDH     (IE),A

        RET

_cpu_fast:                     ; Banked
cpu_fast:
        LDH     A,(KEY1)
        AND     0x80           ; Is GBC in double speed mode?
        RET     NZ              ; Yes, exit
        JR      shift_speed
