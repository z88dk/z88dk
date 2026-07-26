
; Generate references to any portions of i2c1
; code that must be part of every compile that
; uses the i2c1.

PUBLIC asm_i2c1_need

EXTERN __i2c1ControlEcho

DEFC asm_i2c1_need = __i2c1ControlEcho

