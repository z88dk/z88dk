; compiles at address 0x0 get am9511a driver by default

PUBLIC _z180_nmi
EXTERN _am9511a_isr

defc _z180_nmi = _am9511a_isr
