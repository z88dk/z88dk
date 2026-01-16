; void *esx_disk_stream_bytes(void *dst,uint16_t len)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_disk_stream_bytes

EXTERN _esx_stream_io_port

EXTERN asm_esx_disk_stream_sectors

asm_esx_disk_stream_bytes:

   ; enter : hl = void *dst
   ;         de = uint16_t len > 0
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

   ; read whole sectors first
   
   ld a,d
   and $fe

   jr z, partial_sector

whole_sector:

   push de

   rra
   ld e,a                      ; e = num whole sectors
   
   call asm_esx_disk_stream_sectors

   pop de

   ret c                       ; if error
   
   ld a,d
   and $01
   ld d,a

   or e
   ret z

   ; read last partial sector

partial_sector:

   ld a,(_esx_stream_io_port)
   ld c,a

read_256:

   dec d
   jr nz, read_bytes

IF __NEXTOS_CONFIG_STREAM_UNROLL

   EXTERN l_ini_256
   call   l_ini_256

ELSE

   ld b,d
   inir

ENDIF

read_bytes:

   ld b,e
   inir

   ret
