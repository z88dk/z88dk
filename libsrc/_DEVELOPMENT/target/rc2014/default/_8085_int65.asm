;; compiles at address 0x0 get acia driver by default

IF __CPU_8085__

PUBLIC _8085_int65
EXTERN _acia_interrupt

defc _8085_int65 = _acia_interrupt

ENDIF

