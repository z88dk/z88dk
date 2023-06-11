;; compiles at address 0x0 get acia driver by default

IF !__CPU_8085__

PUBLIC _z80_rst_38h
EXTERN _acia_interrupt

defc _z80_rst_38h = _acia_interrupt

ENDIF
