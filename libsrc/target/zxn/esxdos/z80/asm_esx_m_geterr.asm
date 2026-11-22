; void esx_m_geterr(uint16_t error,unsigned char *msg)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_m_geterr

asm_esx_m_geterr:

   ; enter : de = uint16_t error (from "asm_esx_m_execcmd")
   ;         hl = char msg[33]
   ;
   ; exit  : error message stored in msg[33] as zero terminated string
   ;
   ; uses  : af, bc, de, hl, ix
   
   ld a,d
   or e
   
   ld (hl),a                   ; zero terminate if no error
   ret z                       ; if no error

   ex de,hl                    ; de = char *msg, hl = uint16_t error

   inc h
   dec h
   jr z, have_error_code       ; canned esxdos error in a = l
   
   xor a                       ; custom error in hl

IF __SDCC_IY
   push hl
   pop iy
ELSE
   push hl
   pop ix
ENDIF

have_error_code:

   push de                     ; save char *msg
   
   ld b,1
   
   rst __ESX_RST_SYS
   defb __ESX_M_GETERR
   
   pop hl
   
   ; find end of message and zero terminate
   
   ld a,$7f

loop:

   cpi
   jp p, loop
   
   ld (hl),0
   dec hl
   
   res 7,(hl)  
   ret


; ***************************************************************************
; * M_GETERR ($93) *
; ***************************************************************************
; Entry:
; A=esxDOS error code, or 0=user defined error from dot command
; if A=0, IX=error message address from dot command
;
; B=0, generate BASIC error report (does not return)
; B=1, return error message to 32-byte buffer at DE
;
; NOTES:
; Dot commands may use this call to fetch a standard esxDOS error message
; (with B=1), but must not use it to generate an error report (with B=0) as
; this would short-circuit the tidy-up code.
; User programs may use the call to generate any custom error message (and not
; just a custom message returned by a dot command). To do this, enter with
; A=0 and IX=address of custom message, where IX>=$4000.
; Custom error messages must be terminated with bit 7 set on the final
; character.
