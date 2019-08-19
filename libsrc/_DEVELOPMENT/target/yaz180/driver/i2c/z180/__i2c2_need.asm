
; Generate references to any portions of i2c2
; code that must be part of every compile that
; uses the i2c2.

PUBLIC asm_i2c2_need

EXTERN __i2c2ControlEcho

DEFC asm_i2c2_need = __i2c2ControlEcho

