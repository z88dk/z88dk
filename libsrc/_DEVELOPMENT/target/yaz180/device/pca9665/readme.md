## The PCA9665 - Fm+ parallel bus to I2C-bus controller

The PCA9665 serves as an interface between most standard parallel-bus microcontrollers/microprocessors and the serial I2C-bus and allows the parallel bus system to communicate bidirectionally with the I2C-bus. The PCA9665 can operate as a master or a slave and can be a transmitter or receiver. Communication with the I2C-bus is carried out on a Byte or Buffered mode using interrupt or polled handshake. The PCA9665 controls all the I2C-bus specific sequences, protocol, arbitration and timing with no external timing element required.

The PCA9665 has the same footprint as the PCA9564 with additional features:

+ 1 MHz transmission speeds
+ Up to 25 mA drive capability on SCL/SDA
+ 68-byte Rx and Tx buffer
+ I2C-bus General Call
+ Software reset on the parallel bus

### Description

The PCA9665/PCA9665A acts as an interface device between standard high-speed parallel buses and the serial I 2 C-bus. On the I 2 C-bus, it can act either as a master or slave.

Bidirectional data transfer between the I 2 C-bus and the parallel-bus microcontroller is carried out on a byte or buffered basis, using either an interrupt or polled handshake.

### PCA9665 Registers

The PCA9665/PCA9665A contains eleven registers which are used to configure the operation of the device as well as to send and receive serial data. There are four registers that can be accessed directly and seven registers that are accessed indirectly by setting a register pointer.

The four direct registers are selected by setting pins A0 and A1 to the appropriate logic levels before a read or write operation is executed on the parallel data bus.

The seven indirect registers require that the INDPTR (indirect register pointer, one of the four direct registers described above) is initially loaded with the address of the register in the indirect address space before a read or write is performed to the INDIRECT data field.


```
    DIRECT REGISTERS

    Register Name   Register function   A1  A0  Read/Write  Default
    I2CSTA          status              0   0   R           F8h
    INDPTR          indirect pointer    0   0   W           00h
    I2CDAT          data                0   1   R/W         00h
    INDIRECT        indirect data       1   0   R/W         00h
    I2CCON          control             1   1   R/W         00h


    INDIRECT REGISTERS

    Register name   Register function   INDPTR  Read/Write  Default
    I2CCOUNT        byte count          00h     R/W         01h
    I2CADDR         own address         01h     R/W         E0h
    I2CSCLL         SCL LOW period      02h     R/W         9Dh
    I2CSCLH         SCL HIGH period     03h     R/W         86h
    I2CTO           time-out            04h     R/W         FFh
    I2CPRESET       parallel s/w reset  05h     W           00h [A5h 5Ah]
    I2CMODE         I2C-bus mode        06h     R/W         00h
```

### PCA9665 Register Bits

```
    Bits in I2CSTA

    Bit 7:2 = ST[5:0]   status code corresponding I2C states
    Bit 1:0             always reads zero

    Bits in INDPTR

    Bit 7:3             reserved, must always be written to zero
    Bit 2:0 = IP[2:0]   address of the indirect register

    Bits in I2CCON

    Bit 7   = AA        Assert Acknowledge Flag
    Bit 6   = ENSIO     Bus Controller Enable change only when I2C bus idle.
    Bit 5   = STA       Start Flag
    Bit 4   = STO       Stop Flag
    Bit 3   = SI        Serial Interrupt Flag
    Bit 2:1             reserved, must always be written to zero
    Bit 0   = MODE      Mode Flag, 1 = byte mode, 0 = buffered mode

    Remark: Since none of the registers should be written to via
    the parallel interface once the Serial Interrupt line has been
    de-asserted, all the other registers that need to be modified
    should be written to before the content of the I2CCON register
    is modified.

    Bits in I2CICOUNT

    Bit 7   = LB        Last Byte control bit
                        LB bit is only used for Receiver Buffered modes
    Bit 6   = BC[6:0]   Number of bytes to be read or written (up to 68 bytes)

    Bits in I2CADDR

    Bit 7:1 = AD[7:1]   Own slave address
    Bit 0   = GC        General Call

    Bits in I2CTO

    Bit 7   = TE        Time-Out Enable control bit

    Bits in I2CMODE

    Bit 7:2             reserved, must always be written to zero
    Bit 1:0 = AC[1:0]   Bus Mode 00b Std 01b Fast 10b Fast+ 11b Turbo

    Bits in I2CSTA (Status Codes Returned)

    __IO_I2C_STA_ILLEGAL_START_STOP      $00
    __IO_I2C_STA_MASTER_START_TX         $08
    __IO_I2C_STA_MASTER_RESTART_TX       $10
    __IO_I2C_STA_MASTER_SLA_W_ACK        $18
    __IO_I2C_STA_MASTER_SLA_W_NAK        $20
    __IO_I2C_STA_MASTER_DATA_W_ACK       $28
    __IO_I2C_STA_MASTER_DATA_W_NAK       $30
    __IO_I2C_STA_MASTER_ARB_LOST         $38
    __IO_I2C_STA_MASTER_SLA_R_ACK        $40
    __IO_I2C_STA_MASTER_SLA_R_NAK        $48
    __IO_I2C_STA_MASTER_DATA_R_ACK       $50
    __IO_I2C_STA_MASTER_DATA_R_NAK       $58
    __IO_I2C_STA_SLAVE_AD_W              $60
    __IO_I2C_STA_SLAVE_AL_AD_W           $68
    __IO_I2C_STA_SDA_STUCK               $70
    __IO_I2C_STA_SCL_STUCK               $78
    __IO_I2C_STA_SLAVE_DATA_RX_ACK       $80
    __IO_I2C_STA_SLAVE_DATA_RX_NAK       $88
    __IO_I2C_STA_SLAVE_STOP_OR_RESTART   $A0
    __IO_I2C_STA_SLAVE_AD_R              $A8
    __IO_I2C_STA_SLAVE_AL_AD_R           $B0
    __IO_I2C_STA_SLAVE_DATA_TX_ACK       $B8
    __IO_I2C_STA_SLAVE_DATA_TX_NAK       $C0
    __IO_I2C_STA_SLAVE_LST_TX_ACK        $C8
    __IO_I2C_STA_SLAVE_GC                $D0
    __IO_I2C_STA_SLAVE_GC_AL             $D8
    __IO_I2C_STA_SLAVE_GC_RX_ACK         $E0
    __IO_I2C_STA_SLAVE_GC_RX_NAK         $E8
    __IO_I2C_STA_IDLE                    $F8 _IDLE is unused, so
    __IO_I2C_STA_ILLEGAL_ICOUNT          $FC _ILLEGAL_ICOUNT can be $F8 case

    Bits in I2CCON Echo (i2c1ControlEcho, i2c2ControlEcho), for CPU control

    __IO_I2C_CON_ECHO_BUS_STOP           $10 We are finished the sentence
    __IO_I2C_CON_ECHO_SI                 $08 Serial Interrupt Received
    __IO_I2C_CON_ECHO_BUS_RESTART        $04 Bus Restart Requested
    __IO_I2C_CON_ECHO_BUS_ILLEGAL        $02 Unexpected Bus Response

    Bits in I2CICOUNT

    __IO_I2C_ICOUNT_LB                   $80 Last Byte control bit is only used
                                             for Receiver Buffered modes
    Bits in I2C_ITO

    __IO_I2C_ITO_TE                      $80 Time-Out Enable control bit

    Bits in I2C_IMODE

    __IO_I2C_IMODE_STD                   $00 Standard mode
    __IO_I2C_IMODE_FAST                  $01 Fast mode
    __IO_I2C_IMODE_FASTP                 $02 Fast Plus mode
    __IO_I2C_IMODE_TURBO                 $03 Turbo mode

    __IO_I2C_IMODE_CR                    $07 Clock Rate (MASK)
```
