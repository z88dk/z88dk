SECTION code_driver

PUBLIC system_tick_init_fastcall

EXTERN asm_system_tick_init

; initialize the system tick

defc system_tick_init_fastcall = asm_system_tick_init
