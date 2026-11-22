; unsigned char esx_f_trunc(unsigned char *filename,uint32_t size)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_f_trunc

EXTERN error_znc
EXTERN __esxdos_error_mc

asm_esx_f_trunc:

   ; enter :   hl = char *filename
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
   ; uses  : af, bc, de, hl, ix
   
   ld a,'*'
   
IF __SDCC_IY
   push hl
   pop iy
ELSE
   push hl
   pop ix
ENDIF

   rst __ESX_RST_SYS
   defb __ESX_F_TRUNCATE

   jp nc, error_znc
   jp __esxdos_error_mc


; ***************************************************************************
; * F_TRUNCATE ($ae) *
; ***************************************************************************
; Truncate/extend unopened file.
; Entry:
; A=drive specifier (overridden if filespec includes a drive)
; IX=source filespec, null-terminated
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
; +3DOS headers are included as part of the filesize. Truncating such files is
; not recommended.
