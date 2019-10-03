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

    PUBLIC _i2c2_byte_isr

    EXTERN __i2c2RxPtr, __i2c2TxPtr
    EXTERN __i2c2ControlEcho, __i2c2SlaveAddr, __i2c2SentenceLgth, __i2c2SentenceStop

    EXTERN asm_i2c_reset

._i2c2_byte_isr
    push af
    push bc
    push hl
    
    ld bc,__IO_I2C2_PORT_BASE|__IO_I2C_PORT_STA
    in a,(c)                            ;get the status from status register for switch
    rrca                                ;rotate right to make word offset case addresses
    rrca
    and a,$3E                           ;reset low bit to ensure word addresses, clear upper 2 bits

    ld hl,i2c2_byte_end
    push hl                             ;prepare a return address for the switch

    ld hl,i2c2_int_switch_table
    add a,l                             ;create the address for the switch
    ld l,a
    jr NC,i2c2_nc
    inc h

.i2c2_nc
    ld a,(hl)                           ;load the address for our switch case
    inc hl
    ld h,(hl)
    ld l,a
    jp (hl)                             ;make the switch

.i2c2_byte_end
    pop hl                              ;return here to clean up afterwards
    pop bc
    pop af
    ei
    reti

;---------------------------------------

._MASTER_START_TX
._MASTER_RESTART_TX
    ld a,(__i2c2SlaveAddr)              ;get address of slave we're reading or writing, Bit 0:[R=1,W=0]
    ld bc,__IO_I2C2_PORT_BASE|__IO_I2C_PORT_DAT
    out (c),a

    ld a,__IO_I2C_CON_ENSIO             ;clear the interrupt & continue
    ld bc,__IO_I2C2_PORT_BASE|__IO_I2C_PORT_CON
    out (c),a
    ret

;---------------------------------------

._MASTER_DATA_W_ACK                     ;data transmitted
    ld hl,__i2c2SentenceLgth            ;decrement the remaining sentence length
    dec (hl)

._MASTER_SLA_W_ACK                      ;SLA+W transmitted
    ld a,(__i2c2SentenceLgth)
    or a
    jr Z,_MASTER_SLA_W_NAK

    ld hl,(__i2c2TxPtr)                 ;get the address to where we pop 
    ld a,(hl)
    inc hl                              ;move the Tx pointer along
    ld (__i2c2TxPtr),hl

    ld bc,__IO_I2C2_PORT_BASE|__IO_I2C_PORT_DAT
    out (c),a                           ;write the byte

    ld a,__IO_I2C_CON_ENSIO             ;clear the interrupt & continue
    ld bc,__IO_I2C2_PORT_BASE|__IO_I2C_PORT_CON
    out (c),a
    ret

._MASTER_SLA_W_NAK
._MASTER_DATA_W_NAK
    ld a,__IO_I2C_CON_ECHO_BUS_STOPPED  ;sentence complete, we're done    
    ld (__i2c2ControlEcho),a

    in0 a,(ITC)                         ;get INT/TRAP Control Register (ITC)
    and ~ITC_ITE2                       ;mask out INT2
    out0 (ITC),a                        ;disable external interrupt

    ld a,(__i2c2SentenceStop)
    or a
    ret Z

    ld a,__IO_I2C_CON_ENSIO|__IO_I2C_CON_STO    ;clear the interrupt & send stop
    ld bc,__IO_I2C2_PORT_BASE|__IO_I2C_PORT_CON
    out (c),a
    ret

;---------------------------------------

._MASTER_DATA_R_NAK                     ;last byte we're receiving 
                                        ;__i2c2SentenceLgth should be 1
._MASTER_DATA_R_ACK                     ;data received
    ld bc,__IO_I2C2_PORT_BASE|__IO_I2C_PORT_DAT
    in a,(c)                            ;get the byte

    ld hl,(__i2c2RxPtr)                 ;get the address to where we poke                
    ld (hl),a                           ;write the Rx byte to the __i2c2RxPtr target
    inc hl                              ;move the Rx pointer along
    ld (__i2c2RxPtr),hl                 ;write where the next byte should be poked

    ld hl,__i2c2SentenceLgth            ;decrement the remaining sentence length
    dec (hl)

._MASTER_SLA_R_ACK                      ;SLA+R transmitted
    ld a,(__i2c2SentenceLgth)
    cp 1                                ;is there 1 byte to receive?
    jr Z,_MASTER_SLA_R_NACK1
    or a                                ;is there 0 byte to receive?
    jr Z,_MASTER_SLA_R_NAK 
                                        ;so there are multiple bytes to receive
    ld a,__IO_I2C_CON_AA|__IO_I2C_CON_ENSIO ;clear the interrupt & ACK                                      
    ld bc,__IO_I2C2_PORT_BASE|__IO_I2C_PORT_CON
    out (c),a
    ret

._MASTER_SLA_R_NACK1
    ld a,__IO_I2C_CON_ENSIO             ;clear the interrupt & generate NAK
    ld bc,__IO_I2C2_PORT_BASE|__IO_I2C_PORT_CON
    out (c),a
    ret

._MASTER_SLA_R_NAK
    ld a,__IO_I2C_CON_ECHO_BUS_STOPPED  ;sentence complete, we're done    
    ld (__i2c2ControlEcho),a

    in0 a,(ITC)                         ;get INT/TRAP Control Register (ITC)
    and ~ITC_ITE2                       ;mask out INT2
    out0 (ITC),a                        ;disable external interrupt

    ld a,(__i2c2SentenceStop)
    or a
    ret Z

    ld a,__IO_I2C_CON_ENSIO|__IO_I2C_CON_STO    ;clear the interrupt & send stop
    ld bc,__IO_I2C2_PORT_BASE|__IO_I2C_PORT_CON
    out (c),a
    ret

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
    ld (__i2c2ControlEcho),a
    ret

._ILGL_START_STOP
._SDA_STUCK
._SCL_STUCK
._UNUSED_0x90
._UNUSED_0x98
._UNUSED_0xF0
    ld a,__IO_I2C_CON_ECHO_BUS_RESTART  ;unexpected bus status or error    
    ld (__i2c2ControlEcho),a
    ld a,__IO_I2C2_PORT_MSB
    jp asm_i2c_reset


    SECTION rodata_driver

.i2c2_int_switch_table
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

