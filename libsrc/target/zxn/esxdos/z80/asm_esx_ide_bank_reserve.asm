; unsigned char esx_ide_bank_reserve(unsigned char banktype,unsigned char page)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_ide_bank_reserve

EXTERN l0_asm_esx_ide_bank_free

IF __ZXNEXT

asm_esx_ide_bank_reserve:

   ; reserve a specific page
   ;
   ; enter : l = 0 (rc_banktype_zx)
   ;             1 (rc_banktype_mmc)
   ;         h = page number
   ;
   ; exit  : success
   ;
   ;             hl = 0
   ;             carry reset
   ;
   ;         fail
   ;
   ;             hl = -1
   ;             carry set, errno set
   ;
   ; uses  : all except iy

   ld e,h
   
   ld h,l
   ld l,__nextos_rc_bank_reserve
   
   jp l0_asm_esx_ide_bank_free

ELSE

EXTERN __esxdos_error_mc

asm_esx_ide_bank_reserve:

   ld a,__ESX_ENONSENSE
   jp __esxdos_error_mc

ENDIF
