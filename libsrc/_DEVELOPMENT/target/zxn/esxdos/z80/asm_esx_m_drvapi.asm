; unsigned char esx_m_drvapi(struct esx_drvapi *)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_m_drvapi

EXTERN error_znc
EXTERN __esxdos_error_mc

asm_esx_m_drvapi:

   ; enter : hl = struct esx_drvapi *
   ;         (struct has input values set)
   ;
   ; exit  : success
   ;
   ;            hl = 0
   ;            (struct has output values set)
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : all except ix,iy
   
   push hl                     ; save esx_drvapi *

   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   push ix
   push iy

IF __SDCC_IY

   push hl
   pop iy

ELSE

   push hl
   pop ix

ENDIF
   
   rst __ESX_RST_SYS
   defb __ESX_M_DRVAPI
   
   pop iy
   pop ix
   
   jr c, error

   ex (sp),hl                  ; restore esx_drvapi *
   
   ld (hl),c
   inc hl
   ld (hl),b
   inc hl
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   
   pop bc
   
   ld (hl),c
   inc hl
   ld (hl),b
   
   jp error_znc

error:

   pop hl
   
   or a
   jp nz, __esxdos_error_mc
   
   ; driver not found
   
   ld a,__ESX_ENODEV
   jp __esxdos_error_mc


; ***************************************************************************
; * M_DRVAPI ($92) *
; ***************************************************************************
; Access API for installable drivers.
; Entry:
; C=driver id (0=driver API)
; B=call id
; HL,DE=other parameters
; Exit (success):
; Fc=0
; other values depend on API call
; Exit (failure):
; Fc=1
; A=0, driver not found
; else A=driver-specific error code (esxDOS error code for driver API)
; If C=0, the driver API is selected and calls are as follows:
; (Note that these are not really useful for user applications; they are used
; by the .install/.uninstall dot commands).
;
; B=0, query the RTC
; (returns the same results as M_GETDATE)
;
; B=1, install a driver
; D=number of relocations (0-255)
; E=driver id, with bit 7=1 if should be called on an IM1 interrupt
; HL=address of 512-byte driver code followed by D x 2-byte reloc offsets
; Possible error values are:
; esx_eexist (18) driver with same id already installed
; esx_einuse (23) no free driver slots available
; esx_eloadingko (26) bad relocation table
;
; B=2, uninstall a driver
; E=driver id (bit 7 ignored)
;
; B=3, get paging value for driver banks
; C=port (always $e3 on ZXNext)
; A=paging value for DivMMC bank containing drivers (usually $82)
