;; compiles at address 0x0 get acia driver by default

IFDEF __CRTCFG

IF __CRTCFG = 0

PUBLIC _z80_rst_38h
EXTERN _acia_interrupt

defc _z80_rst_38h = _acia_interrupt

ENDIF

ENDIF
