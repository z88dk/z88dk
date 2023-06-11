/*********************************************************************
* Project:        Generic project reuseable code
* Unit Name:      micro8085.h
* Description:    Declaration of embedded drivers for micro8085 target
* Prepared By:    Anders Hjelm
* Creation Date:  2021-11-30
**********************************************************************/
#ifndef _MICRO8085_H_
#define _MICRO8085_H_

/*********************************************************************
* Include Files
**********************************************************************/
#include <stdint.h>
#include <stdbool.h>

/*********************************************************************
* Public Macros
**********************************************************************/
#define PCMD    0x00    // command port of 8155
#define PORTA   0x01    // data port A of 8155
#define PORTB   0x02    // data port B of 8155
#define PORTC   0x03    // data port C of 8155
#define PSELECT 0x30    // two bit general io port
#define PDAC    0x60    // dac 8 bit output port

/*********************************************************************
* Public Type Definitions
**********************************************************************/

/*********************************************************************
* Public Constant Declarations
**********************************************************************/

/*********************************************************************
* Public Variable Declarations
**********************************************************************/

/*********************************************************************
* Public Function Declarations
**********************************************************************/
/*********************************************************************
* uint16_t get_msec(void)
* \\ return system millisec free running counter
**********************************************************************/
extern uint16_t get_msec(void);

/*********************************************************************
* bool ee_mem_rd(uint8_t *pDest, uint16_t u16Addr, uint16_t u16Len)
* \\ read consecutive stream of bytes from non volatile eeprom memory
* \\ on spi bus starting at specified memory addr for specifed length
* \\ return true if success
**********************************************************************/
extern bool ee_mem_rd(uint8_t *, uint16_t, uint16_t);

/*********************************************************************
* bool ee_mem_wr(uint8_t *pSource, uint16_t u16Addr, uint16_t u16Len)
* \\ write consecutive stream of bytes to non volatile eeprom memory
* \\ on spi bus starting at specified memory addr for specifed length
* \\ return true if success
**********************************************************************/
extern bool ee_mem_wr(uint8_t *, uint16_t, uint16_t);

/*********************************************************************
* void spi_rxbuf(uint8_t *pDst, uint16_t u16Len)
* \\ master receive stream of bytes on spi bus to destination buffer
**********************************************************************/
extern void spi_rxbuf(uint8_t *, uint16_t);

/*********************************************************************
* void spi_txbuf(uint8_t *pSrc, uint16_t u16Len)
* \\ master transmit stream of bytes on spi bus from source buffer
**********************************************************************/
extern void spi_txbuf(uint8_t *, uint16_t);

/*********************************************************************
* uint8_t spi_rxbyte(void)
* \\ master receive one byte on spi bus
**********************************************************************/
extern uint8_t spi_rxbyte(void);

/*********************************************************************
* void spi_txbyte(uint8_t u8Data)
* \\ master transmit one byte on spi bus
**********************************************************************/
extern void spi_txbyte(uint8_t);

/*********************************************************************
* void uart_putc(uint8_t u8Data)
* \\ transmit one 8 bit data on serial interface
* \\ same as _fputc_cons_native but without <cr> to <cr><lf> conversion
**********************************************************************/
extern void uart_putc(uint8_t);

/*********************************************************************
* void uart_puts(char *pData)
* \\ transmit string of data from source buffer until null
**********************************************************************/
extern void uart_puts(char *);

/*********************************************************************
* uint16_t uart_rxlen(void)
* \\ return number of chars available in uart rcv buffer
**********************************************************************/
extern uint16_t uart_rxlen(void);

/*********************************************************************
* uint16_t uart_rxget(uint8_t *pDst, uint16_t u16Max)
* \\ receive/pull data from uart rcv buf to desitnation, up to max len
* \\ returns actual number of bytes pulled (if less than max allowed)
**********************************************************************/
extern uint16_t uart_rxget(uint8_t *, uint16_t);

/*********************************************************************
* void uart_txput(uint8_t *pSrc, uint16_t u16Len)
* \\ transmit stream of bytes to uart bus from source buffer
**********************************************************************/
extern void uart_txput(uint8_t *, uint16_t);

/*********************************************************************
* uint8_t io_inp(uint8_t u8Addr)
* \\ read from io port adr
**********************************************************************/
extern uint8_t io_inp(uint8_t);

/*********************************************************************
* void io_outp(uint8_t u8Addr, uint8_t u8Data)
* \\ write to io port addr
**********************************************************************/
extern void io_outp(uint8_t, uint8_t);

/*********************************************************************
* void beep_en(void)
* void beep_dis(void)
* \\ enabe/disable sound function (gating the 1kHz timer tick)
**********************************************************************/
extern void beep_en(void);
extern void beep_dis(void);

/*********************************************************************
* uint8_t adc1_in(void)
* uint8_t adc2_in(void)
* \\ trig-wait-read 8 bit data from a/d converter(s) (in all ~150 us)
**********************************************************************/
extern uint8_t adc1_in(void);
extern uint8_t adc2_in(void);

/*********************************************************************
* void fputc_cons_native(char data)
* \\ this is stdio/printf output function including <cr><lf> conversion
* \\ can also be used as a general output function writing data to uart
**********************************************************************/
extern void fputc_cons_native(char);

/*********************************************************************
* char fgetc_cons(void)
* \\ this is stdio input function which can also be used as a general
* \\ input function reading data from uart (it will wait for rcvd char)
**********************************************************************/
extern char fgetc_cons(void);

/*********************************************************************
* char getk(void)
* \\ this is stdio input function which can also be used as a general
* \\ input function reading data from uart (returns zero if no char)
**********************************************************************/
extern char getk(void);

#endif /* _MICRO8085_H_ */
