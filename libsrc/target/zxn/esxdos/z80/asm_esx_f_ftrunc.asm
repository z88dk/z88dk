; unsigned char esx_f_ftrunc(unsigned char handle, uint32_t size)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_f_ftrunc

EXTERN error_znc
EXTERN __esxdos_error_mc

asm_esx_f_ftrunc:

   ; enter :    a = handle
   ;         bcde = size
   ;
   ; exit  : success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl

   rst __ESX_RST_SYS
   defb __ESX_F_FTRUNCATE

   jp nc, error_znc
   jp __esxdos_error_mc


; ***************************************************************************
; * F_FTRUNCATE ($a2) *
; ***************************************************************************
; Truncate/extend file.
; Entry:
; A=file handle
; BCDE=new filesize
; Exit (success):
; Fc=0
; Exit (failure):
; Fc=1
; A=error code
;
; NOTES:
; Sets the filesize to precisely BCDE bytes.
; If BCDE<current filesize, the file is trunctated.
; If BCDE>current filesize, the file is extended. The extended part is erased
; with zeroes.
; The file position is unaffected. Therefore, if truncating, make sure to
; set the file position within the file before further writes (otherwise it
; will be extended again).
; +3DOS headers are included as part of the filesize. Truncating such files is
; not recommended.
