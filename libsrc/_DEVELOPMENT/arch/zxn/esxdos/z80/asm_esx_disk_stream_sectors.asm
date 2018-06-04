; void *esx_disk_stream_sectors(void *dst,uint8_t sectors)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_disk_stream_sectors

EXTERN _esx_stream_io_port
EXTERN _esx_stream_protocol

EXTERN __esx_stream_card_flags
EXTERN __esx_stream_protocol_sectors
EXTERN __esx_stream_protocol_address

EXTERN __esxdos_error_zc

asm_esx_disk_stream_sectors:

   ; enter : hl = void *dst
   ;          e = uint8_t sectors > 0
   ;
   ; exit  :  c = device port
   ;          b = 0
   ;
   ;         success
   ;
   ;            hl = void *dst (next address)
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = 0
   ;            carry set, errno = ESX_EIO
   ;
   ; note  : no error checking is done to ensure that
   ;         sectors are not read past the end of the span 
   ;
   ; uses  : af, bc, de, hl

   ld a,(_esx_stream_io_port)
   
   ld c,a
   ld b,0
   
   ld d,e
   
   ld a,(_esx_stream_protocol)
   
   or a
   jr nz, ide_read_sector

sd_read_sector:

IF __NEXTOS_CONFIG_STREAM_UNROLL

   EXTERN l_ini_512
   call   l_ini_512

ELSE

   inir
   inir

ENDIF

   ; skip crc
   
   in a,(c)
   nop

   in a,(c)
   nop
   
   ; wait for token
   
token:

   in a,(c)
   
   inc a
   jr z, token
   
   inc a
   jr nz, error_sd

   ; loop count
   
   dec d
   jr nz, sd_read_sector

update_filemap:

   ;  d = 0
   ;  e = number of sectors read
   ; hl = next dst address
   
   push hl

   ; update internal filemap entry (num sectors)
   
   ld hl,(__esx_stream_protocol_sectors)
   
   xor a
   sbc hl,de
   
   ld (__esx_stream_protocol_sectors),hl
   
   ; update internal filemap entry (card address)
   
   ld a,(__esx_stream_card_flags)
   
   and $02
   jr nz, block_addressing

byte_addressing:

   ld a,e
   add a,a
   ld e,d
   ld d,a

block_addressing:

   ld hl,(__esx_stream_protocol_address)
   add hl,de
   ld (__esx_stream_protocol_address),hl
   
   jr nc, exit

   ld hl,(__esx_stream_protocol_address + 2)
   inc hl
   ld (__esx_stream_protocol_address + 2),hl
   
   or a

exit:
   
   pop hl
   ret

ide_read_sector:

IF __NEXTOS_CONFIG_STREAM_UNROLL

   EXTERN l_ini_512
   call   l_ini_512

ELSE

   inir
   inir

ENDIF
   
   dec d
   jr nz, ide_read_sector
   
   jr update_filemap

error_sd:

   dec d

   ld a,e
   sub d
   ld e,a                      ; e = number of sectors read
   ld d,0
   
   call update_filemap

   ld a,__ESX_EIO
   jp __esxdos_error_zc
