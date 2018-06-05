; unsigned char esx_disk_stream_end(void)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_disk_stream_end

EXTERN __esx_stream_card_flags

EXTERN error_mnc
EXTERN __esxdos_error_zc

asm_esx_disk_stream_end:

   ; enter : none
   ;
   ; exit  : success
   ;
   ;            hl = -1
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = 0
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl
   
   ld a,(__esx_stream_card_flags)
   
   rst __ESX_RST_SYS
   defb __ESX_DISK_STRMEND
   
   jp nc, error_mnc
   jp __esxdos_error_zc


; ***************************************************************************
; * DISK_STRMEND ($87) *
; ***************************************************************************
; Stop current streaming operation.
; Entry: A=card flags
; Exit (success): Fc=0
; Exit (failure): Fc=1, A=esx_edevicebusy
;
; NOTES:
; This call must be made to terminate a streaming operation.
; Please see example application code, stream.asm, for full usage information
; (available separately or at the end of this document).
