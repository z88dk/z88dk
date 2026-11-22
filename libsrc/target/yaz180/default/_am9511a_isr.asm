; compiles at address 0x0 get am9511a apu driver by default

PUBLIC _z180_rst_38h
EXTERN asm_am9511a_isr

defc _z180_rst_38h = asm_am9511a_isr
