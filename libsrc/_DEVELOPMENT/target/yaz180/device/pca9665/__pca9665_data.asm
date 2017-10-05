
    INCLUDE "config_private.inc"

    SECTION data_align_256

    PUBLIC i2c1RxBuffer, i2c1TxBuffer
    PUBLIC i2c2RxBuffer, i2c2TxBuffer

    i2c1RxBuffer:   DEFS    __I2C_RX_SIZE
    i2c1TxBuffer:   DEFS    __I2C_TX_SIZE    
    i2c2RxBuffer:   DEFS    __I2C_RX_SIZE
    i2c2TxBuffer:   DEFS    __I2C_TX_SIZE

    ; pad to next 256 byte boundary

    IF (ASMPC & 0xff)
       defs 256 - (ASMPC & 0xff)
    ENDIF

    SECTION data_driver

    PUBLIC i2c1RxInPtr, i2c1RxOutPtr, i2c1RxBufUsed
    PUBLIC i2c1TxInPtr, i2c1TxOutPtr, i2c1TxBufUsed
    PUBLIC i2c1StatusEcho, i2c1ControlEcho, i2c1SlaveAddr, i2c1SentenceLgth

    PUBLIC i2c2RxInPtr, i2c2RxOutPtr, i2c2RxBufUsed
    PUBLIC i2c2TxInPtr, i2c2TxOutPtr, i2c2TxBufUsed
    PUBLIC i2c2StatusEcho, i2c2ControlEcho, i2c2SlaveAddr, i2c2SentenceLgth
    
    i2c1RxInPtr:    DEFW    i2c1RxBuffer
    i2c1RxOutPtr:   DEFW    i2c1RxBuffer
    i2c1TxInPtr:    DEFW    i2c1TxBuffer
    i2c1TxOutPtr:   DEFW    i2c1TxBuffer
    i2c1RxBufUsed:  DEFB    0
    i2c1TxBufUsed:  DEFB    0

    i2c1StatusEcho: DEFB    0
    i2c1ControlEcho: DEFB   0
    i2c1SlaveAddr:  DEFB    0
    i2c1SentenceLgth: DEFB  0

    i2c2RxInPtr:    DEFW    i2c2RxBuffer
    i2c2RxOutPtr:   DEFW    i2c2RxBuffer
    i2c2TxInPtr:    DEFW    i2c2TxBuffer
    i2c2TxOutPtr:   DEFW    i2c2TxBuffer
    i2c2RxBufUsed:  DEFB    0
    i2c2TxBufUsed:  DEFB    0

    i2c2StatusEcho: DEFB    0
    i2c2ControlEcho: DEFB    0
    i2c2SlaveAddr:  DEFB    0
    i2c2SentenceLgth: DEFB   0
