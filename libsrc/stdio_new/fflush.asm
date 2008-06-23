; int __FASTCALL__ fflush(FILE *stream)
; 06.2008 aralbrec

XLIB fflush
LIB stdio_error_ebadf_mc, stdio_error_mc, stdio_success_znc, l_jpix

INCLUDE "stdio.def"

.fflush

   ld a,h                      ; cannot fflush(NULL) since we
   or l                        ; do not keep track of open FILE*
   jp z, stdio_error_ebadf_mc
   
   push hl
   pop ix                      ; ix = FILE *
   
   ; first we flush any unread (buffered) input
   ;
   ; flushing input means we move back the device
   ; file position by the number of bytes sitting
   ; in the buffers.

.flushin

   bit 2,(ix+3)                ; reading from this stream?
   jr z, flushout
   
   bit 0,(ix+3)                ; unget char available?
   jr z, skipunget

   ld b,2                      ; move file position back 1 char
   ld hl,-1
   ld e,l
   ld d,h
   ld c,STDIO_MSG_SEEK
   call l_jpix
   
   res 0,(ix+3)                ; unget char is gone now
   
.skipunget

   ld b,1                      ; flush any input buffers in this stream
   ld c,STDIO_MSG_FLSH
   call l_jpix
   
   ; next we flush any buffered writes to the device
   ;
   ; note that this is not the same as an fsync -- an fsync tells the
   ; driver to dump its buffers to the device whereas this tells
   ; any higher level stream buffers to dump their data to the driver
   
.flushout

   bit 1,(ix+3)                ; writing to this stream?
   jr z, exit

   ld b,2                      ; flush any output buffers in this stream
   ld c,STDIO_MSG_FLSH
   call l_jpix

.exit

   jp c, stdio_error_mc
   jp stdio_success_znc
