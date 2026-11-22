; unsigned char esx_disk_filemap(uint8_t handle,struct esx_filemap *fmap)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_disk_filemap

EXTERN __esxdos_error_zc
EXTERN __esx_stream_card_flags

asm_esx_disk_filemap:

   ; enter :  a = handle
   ;         hl = struct esx_filemap *fmap, fmap->mapsz filled in
   ;
   ; exit  : success
   ;
   ;            hl = fmap->mapsz (modified) = number of entries filled in
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = fmap->mapsz = 0
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, ix
   
   push hl
   
   ld e,(hl)
   ld (hl),0                   ; set number of entries returned to zero
   
   inc hl

   ld d,(hl)
   inc hl
   ld h,(hl)
   ld l,d                      ; hl = buffer
   
   ld d,0                      ; de = max entries
   push de                     ; save max entries
   
IF __SDCC_IY
   push hl
   pop iy
ELSE
   push hl
   pop ix
ENDIF

   rst __ESX_RST_SYS
   defb __ESX_DISK_FILEMAP

   pop bc
   pop hl
   jp c, __esxdos_error_zc

   ld (__esx_stream_card_flags),a

   ld a,c
   sub e
   ld e,a

   ld (hl),e                   ; store number of entries returned
   
   ex de,hl
   ret


; ***************************************************************************
; * DISK_FILEMAP ($85) *
; ***************************************************************************
; Obtain a map of card addresses describing the space occupied by the file.
; Can be called multiple times if buffer is filled, continuing from previous.
; Entry:
; A=file handle (just opened, or following previous DISK_FILEMAP calls)
; IX=buffer
; DE=max entries (each 6 bytes: 4 byte address, 2 byte sector count)
; Exit (success):
; Fc=0
; DE=max entries-number of entries returned
; HL=address in buffer after last entry
; A=card flags: bit 0=card id (0 or 1)
; bit 1=0 for byte addressing, 1 for block addressing
; Exit (failure):
; Fc=1
; A=error
;
; NOTES:
; Each entry may describe an area of the file between 2K and just under 32MB
; in size, depending upon the fragmentation and disk format.
; Please see example application code, stream.asm, for full usage information
; (available separately or at the end of this document).
