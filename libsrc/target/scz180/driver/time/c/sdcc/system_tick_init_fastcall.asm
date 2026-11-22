SECTION code_driver

PUBLIC _system_tick_init_fastcall

EXTERN asm_system_tick_init

; initialize the system tick

defc _system_tick_init_fastcall = asm_system_tick_init
