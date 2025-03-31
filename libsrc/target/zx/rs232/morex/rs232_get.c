/*
 *	z88dk RS232 Function
 *
 *  ZX Spectrum (Morex,B&V,Indescomp) version
 *
 *	unsigned char rs232_get(char *)
 *
 *	Returns RS_ERROR_OVERFLOW on error (and sets carry)
 *
 *
 *      $Id: rs232_get.c $
 */


#include <rs232.h>


uint8_t rs232_get(uint8_t *char) __naked __z88dk_fastcall
{
#asm

  extern  __BV_BIT_DELAY
  extern  __BV_BAUD_DELAY
  extern  __BV_HANDSHAKE

   DI

  LD A,(BV_FLAGS)
  RES 4,A
  LD (BV_FLAGS),A
  
CHAN3_INPUT_0:
  LD A,(BV_FLAGS)
  BIT 4,A                       ; Byte received ?
  JR Z,CHAN3_INPUT_1
  RES 4,A
  LD (BV_FLAGS),A
  LD A,(BV_RECEIVED)
  JR CHAN3_INPUT_3

CHAN3_INPUT_1:
  CALL RS232_RECEIVE
  PUSH AF
  CALL __BV_BIT_DELAY
  IN A,($FB)
  AND $80
  JR Z,RS232_NO_MORE_DATA
  CALL RCV_BYTE
  LD (BV_RECEIVED),A
  LD A,(BV_FLAGS)
  SET 4,A                       ; Byte received
  LD (BV_FLAGS),A
RS232_NO_MORE_DATA:
  POP AF
CHAN3_INPUT_3:
  CP $0A
  JR Z,CHAN3_INPUT_0
  CP $1B
  JR NZ,CHAN3_INPUT_4
  LD A,$0A
CHAN3_INPUT_4:
  AND A

  EI
  
	ld	hl,RS_ERR_NO_DATA
	ret	z

  pop bc
  pop hl
  ld  (hl),a
  push hl
  push bc

	ld	hl,RS_ERR_OK  

  RET

; This entry point is used by the routine at CHAN3_INPUT.
RS232_RECEIVE:
  LD A,(__BV_HANDSHAKE)
  AND $FB
  OUT ($7F),A
  LD (__BV_HANDSHAKE),A
WAIT_RS232_DATA:
  IN A,($FB)
  AND $80
  JR Z,WAIT_RS232_DATA
  LD A,(__BV_HANDSHAKE)
  OR $04                    ; enable RS232 Clear To Send signal
  OUT ($7F),A
  LD (__BV_HANDSHAKE),A           ; update status bits
  CALL __BV_BAUD_DELAY
; This entry point is used by the routine at CHAN3_INPUT.
RCV_BYTE:
  PUSH BC
  CALL __BV_BIT_DELAY
  LD B,$08

; Get character
RCV_BYTE_0:
  IN A,($FB)
  RL A
  RR C
  CALL __BV_BIT_DELAY
  PUSH IX                  ; ..more delay
  POP IX
  PUSH HL                  ; ..a smaller delay
  POP HL
  NOP                      ; ..a tiny delay
  DJNZ RCV_BYTE_0
  LD A,C
  CPL
  AND $7F
  CALL __BV_BIT_DELAY
  POP BC
  RET

;--------------------------------------

BV_RECEIVED:  defb 0
BV_FLAGS:     defb 0

#endasm
}
