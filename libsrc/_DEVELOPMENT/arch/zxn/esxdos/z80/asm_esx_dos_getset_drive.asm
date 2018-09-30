; unsigned char esx_dos_get_drive(void)
; unsigned char esx_dos_set_drive(unsigned char drive)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_dos_get_drive
PUBLIC asm_esx_dos_set_drive

EXTERN __esxdos_error_mc

IF __ZXNEXT

asm_esx_dos_get_drive:

   ld l,$ff

asm_esx_dos_set_drive:

   ; enter :  l = drive 'A'..'P'
   ;
   ; exit  : success
   ;
   ;            hl = drive 'A'..'P'
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : all except af', iy

   ld a,l
   
   ld de,__NEXTOS_DOS_SET_DRIVE
   ld c,7
   
   rst __ESX_RST_SYS
   defb __ESX_M_P3DOS

   ld l,a
   ld h,0

   ccf
   ret nc
   
   jp __esxdos_error_mc

ELSE

asm_esx_dos_get_drive:
asm_esx_dos_set_drive:

   ld a,__ESX_ENONSENSE
   jp __esxdos_error_mc

ENDIF
