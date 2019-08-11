
; Generate references to any portions of i2c2
; code that must be part of every compile that
; uses the i2c2.

PUBLIC asm_i2c2_needRx, asm_i2c2_needTx

EXTERN __i2c2RxBuffer, __i2c2TxBuffer

DEFC asm_i2c2_needRx = __i2c2RxBuffer
DEFC asm_i2c2_needTx = __i2c2TxBuffer

