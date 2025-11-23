
IFNDEF __ZXN_INC_DMA
DEFINE __ZXN_INC_DMA

defc __IO_DMA = 0x6b
defc __IO_DMA_DATAGEAR = 0x6b

defc __D_WR0 = 0x00

defc __D_WR0_TRANSFER = 0x01
defc __D_WR0_A_TO_B = 0x04
defc __D_WR0_B_TO_A = 0x00

defc __D_WR0_X3_A_START_L = 0x08
defc __D_WR0_X4_A_START_H = 0x10
defc __D_WR0_X34_A_START = 0x18
defc __D_WR0_X5_LEN_L = 0x20
defc __D_WR0_X6_LEN_H = 0x40
defc __D_WR0_X56_LEN = 0x60

defc __D_WR0_X3 = 0x08
defc __D_WR0_X4 = 0x10
defc __D_WR0_X5 = 0x20
defc __D_WR0_X6 = 0x40
defc __D_WR0_X34 = 0x18
defc __D_WR0_X35 = 0x28
defc __D_WR0_X36 = 0x48
defc __D_WR0_X45 = 0x30
defc __D_WR0_X46 = 0x50
defc __D_WR0_X56 = 0x60
defc __D_WR0_X345 = 0x38
defc __D_WR0_X346 = 0x58
defc __D_WR0_X356 = 0x68
defc __D_WR0_X456 = 0x70
defc __D_WR0_X3456 = 0x78

defc __D_WR0_TRANSFER_A_TO_B = 5
defc __D_WR0_TRANSFER_B_TO_A = 1
defc __D_WR0_XFER_A_TO_B = 5
defc __D_WR0_XFER_B_TO_A = 1

defc __D_WR1 = 0x04

defc __D_WR1_A_IS_MEM = 0x00
defc __D_WR1_A_IS_IO = 0x08
defc __D_WR1_A_DEC = 0x00
defc __D_WR1_A_INC = 0x10
defc __D_WR1_A_FIX = 0x20

defc __D_WR1_X6 = 0x40
defc __D_WR1_X6_A_TIMING = 0x40

defc __D_WR1X6_A_CLEN_2 = 0x02
defc __D_WR1X6_A_CLEN_3 = 0x01
defc __D_WR1X6_A_CLEN_4 = 0x00

defc __D_WR1_A_IS_MEM_DEC = 4
defc __D_WR1_A_IS_MEM_INC = 20
defc __D_WR1_A_IS_MEM_FIX = 36
defc __D_WR1_A_IS_IO_DEC = 12
defc __D_WR1_A_IS_IO_INC = 28
defc __D_WR1_A_IS_IO_FIX = 44

defc __D_WR2 = 0x00

defc __D_WR2_B_IS_MEM = 0x00
defc __D_WR2_B_IS_IO = 0x08
defc __D_WR2_B_DEC = 0x00
defc __D_WR2_B_INC = 0x10
defc __D_WR2_B_FIX = 0x20

defc __D_WR2_X6 = 0x40
defc __D_WR2_X6_B_TIMING = 0x40

defc __D_WR2X6_B_CLEN_2 = 0x02
defc __D_WR2X6_B_CLEN_3 = 0x01
defc __D_WR2X6_B_CLEN_4 = 0x00

defc __D_WR2X6_X5 = 0x20
defc __D_WR2X6_X5_PRESCALAR = 0x20

defc __D_WR2_B_IS_MEM_DEC = 0
defc __D_WR2_B_IS_MEM_INC = 16
defc __D_WR2_B_IS_MEM_FIX = 32
defc __D_WR2_B_IS_IO_DEC = 8
defc __D_WR2_B_IS_IO_INC = 24
defc __D_WR2_B_IS_IO_FIX = 40

defc __D_WR3 = 0x80
defc __D_WR3_ENABLE_DMA = 0x40

defc __D_WR4 = 0x81

defc __D_WR4_CONT = 0x20
defc __D_WR4_BURST = 0x40

defc __D_WR4_X2 = 0x04
defc __D_WR4_X3 = 0x08
defc __D_WR4_X23 = 0x0c

defc __D_WR4_X2_B_START_L = 0x04
defc __D_WR4_X3_B_START_H = 0x08
defc __D_WR4_X23_B_START = 0x0c

defc __D_WR5 = 0x82

defc __D_WR5_CE = 0x00
defc __D_WR5_CE_WAIT = 0x10

defc __D_WR5_STOP = 0x00
defc __D_WR5_RESTART = 0x20

defc __D_LOAD = 0xcf
defc __D_CONTINUE = 0xd3
defc __D_ENABLE_DMA = 0x87
defc __D_DISABLE_DMA = 0x83
defc __D_READ_MASK = 0xbb

defc __D_RM_STATUS = 0x01
defc __D_RM_COUNTER_L = 0x02
defc __D_RM_COUNTER_H = 0x04
defc __D_RM_COUNTER = 0x06
defc __D_RM_A_ADDR_L = 0x08
defc __D_RM_A_ADDR_H = 0x10
defc __D_RM_A_ADDR = 0x18
defc __D_RM_B_ADDR_L = 0x20
defc __D_RM_B_ADDR_H = 0x40
defc __D_RM_B_ADDR = 0x60

ENDIF
