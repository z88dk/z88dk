;==============================================================================
; Contents of this file are copyright Phillip Stevens
;
; You have permission to use this for NON COMMERCIAL USE ONLY
; If you wish to use it elsewhere, please include an acknowledgement to myself.
;
; https://github.com/feilipu/
;
; https://feilipu.me/
;
;
; This work was authored in Marrakech, Morocco during May/June 2017.

    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC _i2c1_isr

    EXTERN __i2c1RxPtr, __i2c1TxPtr
    EXTERN __i2c1ControlEcho, __i2c1ControlInput, __i2c1SlaveAddr, __i2c1SentenceLgth

    EXTERN pca9665_read_indirect, pca9665_read_burst, pca9665_write_indirect, pca9665_write_burst
    EXTERN asm_i2c_reset

._i2c1_isr
    push af
    push bc
    push hl

    in0 a,(DCNTL)
    push af
    ld a,DCNTL_MWI0                     ;DMA/Wait Control Reg Set I/O Wait States minimum
    out0 (DCNTL),a

    ld bc,__IO_I2C1_PORT_BASE|__IO_I2C_PORT_STA
    in a,(c)                            ;get the status from status register for switch
    rrca                                ;rotate right to make word offset case addresses
    rrca
    and a,$3E                           ;reset low bit to ensure word addresses, clear upper 2 bits

    ld hl,i2c1_end
    push hl                             ;prepare a return address for the switch

    ld hl,i2c1_int_switch_table
    add a,l                             ;create the address for the switch
    ld l,a
    jr NC,i2c1_nc
    inc h
.i2c1_nc
    ld a,(hl)                           ;load the address for our switch case
    inc hl
    ld h,(hl)
    ld l,a

    ld a,(__i2c1ControlInput)           ;get our mode
    rrca                                ;put mode in Carry, buffer = 1

    jp (hl)                             ;make the switch

.i2c1_end
    pop af
    out0 (DCNTL),a                      ;DMA/Wait Control Reg Set I/O Wait States

    pop hl                              ;return here to clean up afterwards
    pop bc
    pop af
    ei
    ret

;---------------------------------------

._MASTER_START_TX
._MASTER_RESTART_TX
    jr NC,_MASTER_BYTE_TX               ;byte mode

    ld a,(__i2c1SentenceLgth)
    ld hl,__i2c1SlaveAddr               ;check for buffer write, Bit 0:[R=1,W=0]
    bit 0,(hl)
    jr NZ,_MASTER_BUFFER_TX_R

    inc a                               ;write: sentence length + address (+1)
    jr _MASTER_BUFFER_TX_W

._MASTER_BUFFER_TX_R
    or a,__IO_I2C_ICOUNT_LB             ;read: include LB NAK

._MASTER_BUFFER_TX_W
    ld c,__IO_I2C_PORT_ICOUNT
    call pca9665_write_indirect         ;write the length

    ld a,(hl)                           ;get address of slave we're reading or writing, Bit 0:[R=1,W=0]
    ld c,__IO_I2C_PORT_DAT
    out (c),a                           ;write the slave address

    rrca                                ;check for Bit 0:[R=1,W=0]
    jr C,_MASTER_BUFFER_RX              ;don't write bytes for RX

    ld a,(__i2c1SentenceLgth)
    ld hl,(__i2c1TxPtr)                 ;get the address to where we pop
    call pca9665_write_burst            ;write A bytes from HL

._MASTER_BUFFER_RX
    ld a,__IO_I2C_CON_ENSIO|__IO_I2C_CON_MODE   ;clear the interrupt & continue in buffer mode
    ld c,__IO_I2C_PORT_CON
    out (c),a
    ret

._MASTER_BYTE_TX
    ld a,(__i2c1SlaveAddr)              ;get address of slave we're reading or writing, Bit 0:[R=1,W=0]
    ld c,__IO_I2C_PORT_DAT
    out (c),a

    ld a,__IO_I2C_CON_ENSIO             ;clear the interrupt & continue in byte mode
    ld c,__IO_I2C_PORT_CON
    out (c),a
    ret

;---------------------------------------

._MASTER_DATA_W_ACK                     ;data transmitted
    jr C,_MASTER_BUFFER_RET0            ;buffer mode

    ld hl,__i2c1SentenceLgth            ;decrement the remaining sentence length
    dec (hl)

._MASTER_SLA_W_ACK                      ;SLA+W transmitted
    jr C,_MASTER_BUFFER_RET0            ;buffer mode

    ld a,(__i2c1SentenceLgth)
    or a
    jr Z,_MASTER_BUS_STOP

    ld hl,(__i2c1TxPtr)                 ;get the address to where we pop
    ld a,(hl)
    inc hl                              ;move the Tx pointer along
    ld (__i2c1TxPtr),hl

    ld c,__IO_I2C_PORT_DAT
    out (c),a                           ;write the byte

    ld a,__IO_I2C_CON_ENSIO             ;clear the interrupt & continue
    ld c,__IO_I2C_PORT_CON
    out (c),a
    ret

._MASTER_SLA_W_NAK
._MASTER_DATA_W_NAK
    jr C,_MASTER_BUFFER_RET1            ;buffer mode
    jr _MASTER_BUS_STOP

;---------------------------------------

._MASTER_BUFFER_RET1
    ld a,0x01
    ld (__i2c1SentenceLgth),a           ;return sentence length 1
    jr _MASTER_BUFFER_RX_GET

._MASTER_BUFFER_RET0
    xor a
    ld (__i2c1SentenceLgth),a           ;return sentence length 0
;   jr _MASTER_BUFFER_RX_GET

._MASTER_BUFFER_RX_GET
    ld c,__IO_I2C_PORT_ICOUNT
    call pca9665_read_indirect
    and 0x7F ;~__IO_I2C_ICOUNT_LB       ;remove LB bit
    ld hl,(__i2c1RxPtr)                 ;get the address to where we poke
    ld c,__IO_I2C_PORT_DAT
    call pca9665_read_burst
;   jr _MASTER_BUS_STOP

._MASTER_BUS_STOP
    ld a,__IO_I2C_CON_ECHO_BUS_STOPPED  ;sentence complete, we're done
    ld (__i2c1ControlEcho),a

    in0 a,(ITC)                         ;get INT/TRAP Control Register (ITC)
    and ~ITC_ITE1                       ;mask out INT1
    out0 (ITC),a                        ;disable external interrupt

    ld a,(__i2c1ControlInput)
    and a,__IO_I2C_CON_STO
    ret Z

    ld a,__IO_I2C_CON_ENSIO|__IO_I2C_CON_STO    ;clear the interrupt & send stop
    ld c,__IO_I2C_PORT_CON
    out (c),a
    ret

;---------------------------------------

._MASTER_DATA_R_NAK                     ;last byte we're receiving
    jr NC,_MASTER_DATA_R_ACK1           ;byte mode __i2c1SentenceLgth should be 1

    ld c,__IO_I2C_PORT_ICOUNT
    call pca9665_read_indirect
    and 0x7F ;~__IO_I2C_ICOUNT_LB       ;remove LB bit

    ld hl,__i2c1SentenceLgth
    sub a,(hl)
    ld (hl),a                           ;return sentence length - ICOUNT
    jr _MASTER_BUFFER_RX_GET

._MASTER_DATA_R_ACK                     ;data received
    jr C,_MASTER_BUFFER_RET0            ;buffer mode
._MASTER_DATA_R_ACK1
    ld c,__IO_I2C_PORT_DAT
    in a,(c)                            ;get the byte

    ld hl,(__i2c1RxPtr)                 ;get the address to where we poke
    ld (hl),a                           ;write the Rx byte to the __i2c1RxPtr target
    inc hl                              ;move the Rx pointer along
    ld (__i2c1RxPtr),hl                 ;write where the next byte should be poked

    ld hl,__i2c1SentenceLgth            ;decrement the remaining sentence length
    dec (hl)
    jr _MASTER_SLA_R_ACKN

._MASTER_SLA_R_ACK                      ;SLA+R transmitted
    jr C,_MASTER_BUFFER_RET0            ;buffer mode

._MASTER_SLA_R_ACKN
    ld a,(__i2c1SentenceLgth)
    cp 1                                ;is there 1 byte to receive?
    jr Z,_MASTER_SLA_R_NAK1
    or a                                ;is there 0 byte to receive?
    jr Z,_MASTER_BUS_STOP 
                                        ;so there are multiple bytes to receive
    ld a,__IO_I2C_CON_AA|__IO_I2C_CON_ENSIO ;clear the interrupt & ACK
    ld c,__IO_I2C_PORT_CON
    out (c),a
    ret

._MASTER_SLA_R_NAK1
    ld a,__IO_I2C_CON_ENSIO             ;clear the interrupt & generate NAK
    ld c,__IO_I2C_PORT_CON
    out (c),a
    ret

._MASTER_SLA_R_NAK
    jr NC,_MASTER_BUS_STOP              ;byte mode
    jr _MASTER_BUFFER_RET1              ;buffer mode, return sentence length 1


._MASTER_ARB_LOST
._SLAVE_AD_W
._SLAVE_AL_AD_W
._SLAVE_DATA_RX_ACK
._SLAVE_DATA_RX_NAK
._SLAVE_STOP_RESRT
._SLAVE_AD_R
._SLAVE_AL_AD_R
._SLAVE_DATA_TX_ACK
._SLAVE_DATA_TX_NAK
._SLAVE_LST_TX_ACK
._SLAVE_GC
._SLAVE_GC_AL                           ;bus should be released for other master
._SLAVE_GC_RX_ACK
._SLAVE_GC_RX_NAK
._ILGL_ICOUNT
    ld a,__IO_I2C_CON_ECHO_BUS_ILLEGAL  ;unexpected bus status or error
    ld (__i2c1ControlEcho),a
    ret

._ILGL_START_STOP
._SDA_STUCK
._SCL_STUCK
._UNUSED_0x90
._UNUSED_0x98
._UNUSED_0xF0
    ld a,__IO_I2C_CON_ECHO_BUS_RESTART  ;unexpected bus status or error
    ld (__i2c1ControlEcho),a
    ld a,__IO_I2C1_PORT_MSB
    jp asm_i2c_reset


    SECTION rodata_driver

.i2c1_int_switch_table
    DEFW _ILGL_START_STOP
    DEFW _MASTER_START_TX
    DEFW _MASTER_RESTART_TX
    DEFW _MASTER_SLA_W_ACK
    DEFW _MASTER_SLA_W_NAK
    DEFW _MASTER_DATA_W_ACK
    DEFW _MASTER_DATA_W_NAK
    DEFW _MASTER_ARB_LOST
    DEFW _MASTER_SLA_R_ACK
    DEFW _MASTER_SLA_R_NAK
    DEFW _MASTER_DATA_R_ACK
    DEFW _MASTER_DATA_R_NAK
    DEFW _SLAVE_AD_W
    DEFW _SLAVE_AL_AD_W
    DEFW _SDA_STUCK
    DEFW _SCL_STUCK
    DEFW _SLAVE_DATA_RX_ACK
    DEFW _SLAVE_DATA_RX_NAK
    DEFW _UNUSED_0x90
    DEFW _UNUSED_0x98
    DEFW _SLAVE_STOP_RESRT
    DEFW _SLAVE_AD_R
    DEFW _SLAVE_AL_AD_R
    DEFW _SLAVE_DATA_TX_ACK
    DEFW _SLAVE_DATA_TX_NAK
    DEFW _SLAVE_LST_TX_ACK
    DEFW _SLAVE_GC
    DEFW _SLAVE_GC_AL
    DEFW _SLAVE_GC_RX_ACK
    DEFW _SLAVE_GC_RX_NAK
    DEFW _UNUSED_0xF0
    DEFW _ILGL_ICOUNT                   ;_ILGL_ICOUNT can be $F8 _IDLE

