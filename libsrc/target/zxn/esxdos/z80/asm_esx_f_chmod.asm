; unsigned char esx_f_chmod(unsigned char *filename, uint8_t attr_mask, uint8_t attr)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_f_chmod

EXTERN error_znc
EXTERN __esxdos_error_mc

asm_esx_f_chmod:

   ; enter : hl = char *filename
   ;          c = attr bits to change
   ;          b = attr
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
   defb __ESX_F_CHMOD

   jp nc, error_znc
   jp __esxdos_error_mc


; ***************************************************************************
; * F_CHMOD ($af) *
; ***************************************************************************
; Modify file attributes.
; Entry:
; A=drive specifier (overridden if filespec includes a drive)
; IX=filespec, null-terminated
; B=attribute values bitmap
; C=bitmap of attributes to change (1=change, 0=do not change)
;
; Bitmasks for B and C are any combination of:
; A_WRITE %00000001
; A_READ %10000000
; A_RDWR %10000001
; A_HIDDEN %00000010
; A_SYSTEM %00000100
; A_ARCH %00100000
;
; Exit (success):
; Fc=0
; Exit (failure):
; Fc=1
; A=error code
