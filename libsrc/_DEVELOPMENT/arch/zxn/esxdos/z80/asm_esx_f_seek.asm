; uint32_t esx_f_seek(unsigned char handle, uint32_t distance, unsigned char whence)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_f_seek

EXTERN __esxdos_error_mc

asm_esx_f_seek:

   ; enter :    a = handle
   ;            l = whence
   ;         bcde = seek value   
   ;
   ; exit  : success
   ;
   ;            dehl = new file position
   ;            carry reset
   ;
   ;         fail
   ;
   ;            dehl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, ix
   
IF __SDCC_IY
   push hl
   pop iy
ELSE
   push hl
   pop ix
ENDIF

   rst __ESX_RST_SYS
   defb __ESX_F_SEEK

   ld l,c
   ld h,b
   
   ex de,hl
   ret nc
   
   ld de,-1
   jp __esxdos_error_mc


; ***************************************************************************
; * F_SEEK ($9f) *
; ***************************************************************************
; Seek to position in file.
; Entry:
; A=file handle
; BCDE=bytes to seek
; IXL=seek mode:
; esx_seek_set $00 set the fileposition to BCDE
; esx_seek_fwd $01 add BCDE to the fileposition
; esx_seek_bwd $02 subtract BCDE from the fileposition
; Exit (success):
; Fc=0
; BCDE=current position
; Exit (failure):
; Fc=1
; A=error code
;
; NOTES:
; Attempts to seek past beginning/end of file leave BCDE=position=0/filesize
; respectively, with no error.
