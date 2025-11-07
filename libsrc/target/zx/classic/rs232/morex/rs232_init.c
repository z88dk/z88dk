/*
 *      z88dk RS232 Function
 *
 *      ZX Spectrum (Morex,B&V,Indescomp) version
 *
 *      unsigned char rs232_init()
 *
 *      Initialise the serial interface
 *
 *      $Id: rs232_init.c $
 */


#include <rs232.h>


u8_t rs232_init()
{
#asm
       ld      hl,$0113   ;RS_BAUD_2400
       ld      (__BV_BAUD),hl
	   ld      a,255
	   ld      (__BV_HANDSHAKE),a
       ld      hl,RS_ERR_OK
       ret


public __BV_BIT_DELAY

__BV_BIT_DELAY:
  CALL __BV_BAUD_DELAY
  CALL __BV_BAUD_DELAY
  RET

public __BV_BAUD_DELAY

__BV_BAUD_DELAY:
  PUSH AF
  PUSH BC
  PUSH HL
  LD BC,(__BV_BAUD)
  LD H,B
LFC0F_7:
  LD B,H
LFC0F_8:
  DJNZ LFC0F_8
  DEC C
  JR NZ,LFC0F_7
  POP HL
  POP BC
  POP AF
  RET



; --------------------------------------
;; SECTION bss_clib

public __BV_HANDSHAKE

__BV_HANDSHAKE:
  DEFB $FF


public __BV_BAUD

; Values suggested in the B&V interface manual
;----------------------------------------------
; 48K:  125, 20 ;   50bps   16K:  150, 32
; 48K:  225, 4  ;  110bps   16K:  130, 14
; 48K:  165, 4  ;  150bps   16K:  150, 10
; 48K:  83, 4   ;  300bps   16K:  200, 4 
; 48K:  41, 4   ;  600bps   16K:  60,  2 
; 48K:  31, 2   ; 1200bps   16K:  210, 0 
; 48K:  19, 1   ; 2400bps   16K:  25,  0 
; 48K:  7, 1    ; 4800bps   16K:  ---    

; BAUD Rate (Default: 2400 baud)

__BV_BAUD:   DEFW 0


#endasm
}
