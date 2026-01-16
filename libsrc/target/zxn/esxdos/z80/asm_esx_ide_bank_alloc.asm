; unsigned char esx_ide_bank_alloc(unsigned char banktype)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_ide_bank_alloc
PUBLIC l0_asm_esx_ide_bank_alloc

EXTERN __esxdos_error_mc

IF __ZXNEXT

asm_esx_ide_bank_alloc:

   ; allocate a single page from ram or divmmc memory
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
   ld l,__nextos_rc_bank_alloc

l0_asm_esx_ide_bank_alloc:

IF __SDCC_IY

   push hl
   pop iy

ELSE

   push hl
   pop ix

ENDIF
   
   exx
   
   ld de,__NEXTOS_IDE_BANK
   ld c,7
   
   rst __ESX_RST_SYS
   defb __ESX_M_P3DOS

   jp nc, __esxdos_error_mc
   
   xor a
   
   ld l,e
   ld h,a
   
   ret

ELSE

asm_esx_ide_bank_alloc:
l0_asm_esx_ide_bank_alloc:

   ld a,__ESX_ENONSENSE
   jp __esxdos_error_mc

ENDIF
