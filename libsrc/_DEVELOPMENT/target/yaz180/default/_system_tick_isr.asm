; compiles at address 0x0 get system tick driver by default

PUBLIC _z180_int_prt0
EXTERN asm_system_tick

defc _z180_int_prt0 = asm_system_tick

