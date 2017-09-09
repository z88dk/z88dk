; compiles at address 0x0 get am9511a apu driver by default

PUBLIC _z180_nmi
EXTERN asm_am9511a_isr

defc _z180_nmi = asm_am9511a_isr
