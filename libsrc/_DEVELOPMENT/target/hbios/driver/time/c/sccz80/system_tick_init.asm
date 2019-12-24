SECTION code_driver

PUBLIC system_tick_init

EXTERN asm_system_tick_init

; initialize the system tick

defc system_tick_init = asm_system_tick_init
