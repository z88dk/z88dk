;; compiles at address 0x0 get asci0 driver by default

PUBLIC _z180_int_asci0
EXTERN _asci0_interrupt

defc _z180_int_asci0 = _asci0_interrupt
