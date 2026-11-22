/*
 *      z88dk RS232 Function
 *
 *      ZX Spectrum (Morex,B&V,Indescomp) version
 *
 *      unsigned char rs232_put(char)
 *
 *      No error checking, for now.
 *
 *      $Id: rs232_put.c $
 */


#include <rs232.h>


uint8_t __FASTCALL__ rs232_put(uint8_t char)
{       
#asm

  extern  __BV_BIT_DELAY
  extern  __BV_HANDSHAKE
  
  DI           ; TODO: deal with __bit_irqstatus to and avoid EI when not appropriate

RS232_BUSY:
  IN A,($FB)                ; Check for RTS
  AND $02                   ; test RS232 busy signal
  JR Z,RS232_BUSY

  LD A,(__BV_HANDSHAKE)
  AND $FD
  OUT ($7F),A
  LD (__BV_HANDSHAKE),A
  CALL __BV_BIT_DELAY

  LD B,$08            ; TODO: 7 bit mode
SD_BYTE:
  LD A,L
  RR A
  LD L,A
  LD A,(__BV_HANDSHAKE)
  JR C,SD_BYTE_0
  AND $FD
  JR SD_BYTE_1
SD_BYTE_0:
  OR $02                    ; enable RS232 TX data signal
SD_BYTE_1:
  LD (__BV_HANDSHAKE),A
  OUT ($7F),A
  CALL __BV_BIT_DELAY
  DJNZ SD_BYTE

  LD A,(__BV_HANDSHAKE)
  OR $02                    ; enable RS232 TX data signal
  LD (__BV_HANDSHAKE),A
  OUT ($7F),A
  CALL __BV_BIT_DELAY
  CALL __BV_BIT_DELAY
  EI
  
#endasm
}
