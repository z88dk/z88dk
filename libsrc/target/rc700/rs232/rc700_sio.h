/*
 * RC700 SIO-A (Z80-SIO channel A) register/port definitions.
 *
 * On the RC700, SIO-A drives the CP/M reader (RDR) and punch (PUN)
 * devices.  Ports and the WR init sequence match the RC700 firmware
 * (rc700-gensmedet cpnos-in-c: hal.h + init.c).  Datasheet: Zilog Z80-SIO.
 *
 * RC700 issue: https://github.com/z88dk/z88dk/issues/3011
 */

#ifndef _RC700_SIO_H_
#define _RC700_SIO_H_

/* I/O ports */
#define SIO_A_DATA          0x08    /* channel A data                 */
#define SIO_A_CTRL          0x0A    /* channel A command/status (WR/RR)*/

/* Read Register 0 status bits (polled) */
#define SIO_RR0_RX_AVAIL    0x01    /* Rx character available          */
#define SIO_RR0_TX_EMPTY    0x04    /* Tx buffer empty                 */

/* Channel-A init sequence: WR0 reset, WR4 x16/1-stop/no-parity,
 * WR3 Rx 8-bit + enable, WR5 Tx 8-bit + enable + RTS, WR1 no-ints. */
#define SIO_WR0_RESET       0x18
#define SIO_WR4_PTR         0x04
#define SIO_WR4_8N1_X16     0x44
#define SIO_WR3_PTR         0x03
#define SIO_WR3_RX8_EN      0xE1
#define SIO_WR5_PTR         0x05
#define SIO_WR5_TX8_EN_RTS  0x6A
#define SIO_WR1_PTR         0x01
#define SIO_WR1_NO_INT      0x00

#endif /* _RC700_SIO_H_ */
