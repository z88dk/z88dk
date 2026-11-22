; unsigned char esx_disk_stream_start(struct esx_filemap_entry *entry)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_disk_stream_start

EXTERN __esx_stream_protocol
EXTERN __esx_stream_protocol_address
EXTERN __esx_stream_protocol_sectors
EXTERN __esx_stream_card_flags

EXTERN error_mnc, __esxdos_error_zc

asm_esx_disk_stream_start:

   ; enter : hl = struct esx_filemap_entry *
   ;
   ; exit  : success
   ;
   ;            hl = -1
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = 0
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, ix
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl

   push bc
   
   ld c,(hl)
   inc hl
   ld b,(hl)
   
   pop hl
   
IF __SDCC_IY
   push hl
   pop iy
ELSE
   push hl
   pop ix
ENDIF

   ld (__esx_stream_protocol_address),de
   ld (__esx_stream_protocol_address + 2),hl
   
   ld (__esx_stream_protocol_sectors),bc

   ; ixde = card address
   ;   bc = sectors
   
   ld a,(__esx_stream_card_flags)
   
   rst __ESX_RST_SYS
   defb __ESX_DISK_STRMSTART

   jp c, __esxdos_error_zc
   
   ld (__esx_stream_protocol),bc
   jp error_mnc


; ***************************************************************************
; * DISK_STRMSTART ($86) *
; ***************************************************************************
; Start reading from the card in streaming mode.
; Entry: IXDE=card address
; BC=number of 512-byte blocks to stream
; A=card flags
; Exit (success): Fc=0
; B=0 for SD/MMC protocol, 1 for IDE protocol
; C=8-bit data port
; Exit (failure): Fc=1, A=esx_edevicebusy
;
; NOTES:
; On the Next, this call always returns with B=0 (SD/MMC protocol) and C=$EB
; When streaming using the SD/MMC protocol, after every 512 bytes you must read
; a 2-byte CRC value (which can be discarded) and then wait for a $FE value
; indicating that the next block is ready to be read.
; Please see example application code, stream.asm, for full usage information
; (available separately or at the end of this document).
