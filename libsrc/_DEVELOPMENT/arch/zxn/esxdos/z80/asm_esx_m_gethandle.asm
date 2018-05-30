; unsigned char esx_m_gethandle(void)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_m_gethandle

asm_esx_m_gethandle:

   ; MAY NOT BE EQUIVALENT TO ESXDOS FUNCTION
   ;
   ; enter : none
   ;
   ; exit  : hl = file handle (no error checking)
   ;
   ; uses  : af, bc, de, hl
   
   rst  __ESX_RST_SYS
   defb __ESX_M_GETHANDLE
   
   ld l,a
   ld h,0
   
   ret


; ***************************************************************************
; * M_GETHANDLE ($8d) *
; ***************************************************************************
; Get the file handle of the currently running dot command
; Entry:
; -
; Exit:
; A=handle
; Fc=0
;
; NOTES:
; This call allows dot commands which are >8K to read further data direct
; from their own file (for loading into another memory area, or overlaying
; as required into the normal 8K dot command area currently in use).
; On entry to a dot command, the file is left open with the file pointer
; positioned directly after the first 8K.
; This call returns meaningless results if not called from a dot command.
