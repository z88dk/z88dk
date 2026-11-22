; unsigned char esx_ide_bank_free(unsigned char banktype, unsigned char page)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_ide_bank_free
PUBLIC l0_asm_esx_ide_bank_free

EXTERN error_znc, __esxdos_error_mc

IF __ZXNEXT

asm_esx_ide_bank_free:

   ; deallocate page
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
   ld l,__nextos_rc_bank_free

l0_asm_esx_ide_bank_free:

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
   
   jp c, error_znc             ; if no error
   jp __esxdos_error_mc

ELSE

asm_esx_ide_bank_free:
l0_asm_esx_ide_bank_free:

   ld a,__ESX_ENONSENSE
   jp __esxdos_error_mc

ENDIF
