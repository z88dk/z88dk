/*********************************************************************
* Project:        Generic project reuseable code
* Unit Name:      micro8085.c
* Description:    Example code and board demo for micro8085 target
* Prepared By:    Anders Hjelm
* Creation Date:  2021-11-30
**********************************************************************/
/*********************************************************************
* Include Files
**********************************************************************/
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "micro8085.h"

/*********************************************************************
* Public Constant Definitions
**********************************************************************/

/*********************************************************************
* Public Variable Definitions
**********************************************************************/

/*********************************************************************
* Private Macros
**********************************************************************/

/*********************************************************************
* Private Type Definitions
**********************************************************************/

/*********************************************************************
* Private Constant Definitions
**********************************************************************/

/*********************************************************************
* Private Variable Definitions
**********************************************************************/
static uint16_t u16Tick;
static uint8_t au8RxBuf[16];
static uint8_t au8MemBuf[256];
static uint8_t u8PortC;
static uint8_t u8Tmp;
static uint8_t *pu8RcvBuf = 0xff00;    // dummy ptr to rcv buf location

/**********************************************************************
* Private Function Declarations
**********************************************************************/
static void vPrintMem(uint8_t *, uint16_t, uint16_t);

/*********************************************************************
* Public Function Definitions
**********************************************************************/
/*********************************************************************
* void main(void)
* \\ the system main() function
* \\ purpose of main loop is just to supply an example and to test all
* \\ target driver funcitions even if that makes the code look a bit silly
**********************************************************************/
void main(void)
{
  io_outp(PCMD, 0x03);                      // set ports A & B as output
  io_outp(PSELECT, 0x01);                   // enable the white led
  u8PortC = io_inp(PORTC) & 0x3f;           // read start val for buttons
  uart_puts("\r\nHello World!\r\n");        // an alternative to printf
  for (;;)
  {                                         // look at system millsec tick
    if ((uint16_t)(get_msec() - u16Tick) > 1000)
    {
      u16Tick += 1000;                      // bump 1000 ms every time
      if (uart_rxlen() == 0)                // if rx buffer is empty
      {                                     // we print a dot
        uart_putc('.');                     // every second
      }
    }
    u8Tmp = adc2_in();                      // convert nbr.2 adc
    io_outp(PDAC, u8Tmp);                   // wr to dac (intensity white led)
    io_outp(PORTA, u8Tmp);                  // and output to port A leds
    io_outp(PORTB, adc1_in());              // nbr.1 adc to port B leds
    u8Tmp = io_inp(PORTC) & 0x3f;           // look for pressed buttons
    if (u8Tmp != u8PortC)                   // anything changed?
    {
      u8PortC = u8Tmp;
      if ((u8PortC & 0x08) == 0)            // which button was it..
      {
        beep_en();                          // let's beep while pressed
      }
      else if ((u8PortC & 0x10) == 0)       // trig a pull from rcv buffer
      {                                     // pull and echo max 16 bytes
        uint16_t u16Len = uart_rxget(au8RxBuf, 16);
        uart_txput(au8RxBuf, u16Len);
        if (au8RxBuf[0] == 'W')             // use 'W' and 'R' to trig
        {                                   // write/read operations
          if (ee_mem_wr(pu8RcvBuf, 5000, 256))
          {                                 // just write whatever is in
            printf(" wr_ok\n");             // the rcv buf for the moment
          }
          else
          {
            printf(" wr_err\n");
          }
        }
        else if (au8RxBuf[0] == 'R')
        {                                   // read back from eeprom
          if (ee_mem_rd(au8MemBuf, 5000, 256))
          {                                 // and print the data
            vPrintMem(au8MemBuf, 5000, 256);
          }
          else
          {
            printf(" rd_err\n");
          }
        }
      }
      else
      {
        beep_dis();                         // stop sound on button release
      }
    }
  }
}

/*********************************************************************
* Private Function Definitions
**********************************************************************/
/*********************************************************************
* void vPrintMem(uint8_t *pData, uint16_t u16Addr, uint16_t u16Len)
* \\ Prints contents of supplied memory chunk in hex and ascii format
**********************************************************************/
void vPrintMem(uint8_t *pData, uint16_t u16Addr, uint16_t u16Len)
{
  uint8_t u8TmpLen, i, ch;
  while (u16Len)
  {
    u8TmpLen = (u16Len > 16) ? 16 : (uint8_t)u16Len;
    printf("\n%04x: ", u16Addr);
    for (i = 0; i < u8TmpLen; i++)
    {
      printf("%02x ", *(pData + i));
    }
    for (i = 0; i < u8TmpLen; i++)
    {
      ch = *(pData + i);
      if ((ch < 32) || (ch > 126))
      {
        ch = '.';
      }
      printf("%c", ch);
    }
    pData += u8TmpLen;
    u16Addr += u8TmpLen;
    u16Len -= u8TmpLen;
  }
  printf("\n");
}
