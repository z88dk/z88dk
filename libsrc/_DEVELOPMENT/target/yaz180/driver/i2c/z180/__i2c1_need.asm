
; Generate references to any portions of i2c1
; code that must be part of every compile that
; uses the i2c1.

PUBLIC asm_i2c1_needRx, asm_i2c1_needTx

EXTERN __i2c1RxBuffer, __i2c1TxBuffer

DEFC asm_i2c1_needRx = __i2c1RxBuffer
DEFC asm_i2c1_needTx = __i2c1TxBuffer

