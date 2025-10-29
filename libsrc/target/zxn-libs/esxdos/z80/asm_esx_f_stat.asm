; unsigned char esx_f_stat(unsigned char *filename,struct esx_stat *es)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_f_stat

EXTERN error_znc
EXTERN __esxdos_error_mc

asm_esx_f_stat:

   ; enter : hl = char *filename
   ;         de = struct esx_stat *es
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
   defb __ESX_F_STAT

   jp nc, error_znc
   jp __esxdos_error_mc


; ***************************************************************************
; * F_STAT ($ac) *
; ***************************************************************************
; Get unopened file information/status.
; Entry:
; A=drive specifier (overridden if filespec includes a drive)
; IX=filespec, null-terminated
; DE=11-byte buffer address
; Exit (success):
; Fc=0
; Exit (failure):
; Fc=1
; A=error code
;
; NOTES:
; The following details are returned in the 11-byte buffer:
; +0(1) drive specifier
; +1(1) $81
; +2(1) file attributes (MS-DOS format)
; +3(2) timestamp (MS-DOS format)
; +5(2) datestamp (MS-DOS format)
; +7(4) file size in bytes
