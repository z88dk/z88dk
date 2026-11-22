; unsigned char esx_f_opendir(unsigned char *dirname)
; unsigned char esx_f_opendir_ex(unsigned char *dirname,uint8_t mode)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_f_opendir
PUBLIC asm_esx_f_opendir_ex

EXTERN __esxdos_error_mc

asm_esx_f_opendir:

   ; enter : hl = dirname
   
   ld b,0

asm_esx_f_opendir_ex:

   ; enter : hl = dirname
   ;          b = mode
   ;
   ; exit  : success
   ;
   ;            h = 0
   ;            l = dir handle
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
   defb __ESX_F_OPENDIR
   
   ld l,a
   ld h,0
   
   ret nc
   jp __esxdos_error_mc


; ***************************************************************************
; * F_OPENDIR ($a3) *
; ***************************************************************************
; Open directory.
; Entry:
; A=drive specifier (overridden if filespec includes a drive)
; IX=directory, null-terminated
; B=access mode (only esx_mode_use_header and esx_mode_use_lfn matter)
; any/all of:
; esx_mode_use_lfn $10 return long filenames
; esx_mode_use_header $40 read/write +3DOS headers
; Exit (success):
; A=dir handle
; Fc=0
; Exit (failure):
; Fc=1
; A=error code
;
; NOTES:
; Access modes determine how entries are formatted by F_READDIR.
