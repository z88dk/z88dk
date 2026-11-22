; unsigned char esx_ide_bank_avail(unsigned char banktype)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_ide_bank_avail

EXTERN l0_asm_esx_ide_bank_alloc

IF __ZXNEXT

asm_esx_ide_bank_avail:

   ; return number of available 8k pages
   ;
   ; enter : l = 0 (rc_banktype_zx)
   ;             1 (rc_banktype_mmc)
   ;
   ; exit  : success
   ;
   ;             hl = allocated page
   ;             carry reset
   ;
   ;         fail
   ;
   ;             hl = -1
   ;             carry set, errno set
   ;
   ; uses  : all except iy

   ld h,l
   ld l,__nextos_rc_bank_available
   
   jp l0_asm_esx_ide_bank_alloc

ELSE

EXTERN __esxdos_error_mc

asm_esx_ide_bank_avail:

   ld a,__ESX_ENONSENSE
   jp __esxdos_error_mc

ENDIF
