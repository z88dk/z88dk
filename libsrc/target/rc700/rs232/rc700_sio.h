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
#define SIO_A_DATA          0x08    /* channel A data                  */
#define SIO_A_CTRL          0x0A    /* channel A command/status (WR/RR)*/
#define CTC0                0x0C    /* CTC ch0 = SIO-A baud generator  */

/* Read Register 0 status bits (polled) */
#define SIO_RR0_RX_AVAIL    0x01    /* Rx character available          */
#define SIO_RR0_TX_EMPTY    0x04    /* Tx buffer empty                 */

/* Write-register pointers (WR0 low 3 bits select the next WR) */
#define SIO_WR0_RESET       0x18    /* WR0: channel reset              */
#define SIO_WR1_PTR         0x01
#define SIO_WR3_PTR         0x03
#define SIO_WR4_PTR         0x04
#define SIO_WR5_PTR         0x05

#define SIO_WR1_NO_INT      0x00    /* WR1: interrupts disabled (poll) */

/* WR4 (Tx/Rx control) — x16 clock is fixed; parity/stop are OR'd in. */
#define SIO_WR4_X16         0x40    /* x16 clock (baud from CTC/16)    */
#define SIO_WR4_STOP1       0x04    /* 1 stop bit                      */
#define SIO_WR4_STOP2       0x0C    /* 2 stop bits                     */
#define SIO_WR4_PAR_EN      0x01    /* parity enable                   */
#define SIO_WR4_PAR_EVEN    0x02    /* even (vs odd) parity            */

/* WR3 (Rx control) bits-per-char + Rx enable; WR5 (Tx control) likewise. */
#define SIO_WR3_RX_EN       0x01
#define SIO_WR5_TX_EN       0x08
#define SIO_WR5_RTS         0x02

/* CTC ch0 counter-mode control word (from RC700 firmware); a time
 * constant byte follows.  baud = 38400 / TC (614400 Hz / 16 / TC). */
#define CTC0_CTRL           0x47

#endif /* _RC700_SIO_H_ */
