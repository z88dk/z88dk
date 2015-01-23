; int __FASTCALL__ fflush(FILE *stream)
; 07.2009 aralbrec

PUBLIC fflush
PUBLIC ASMDISP_FFLUSH

EXTERN stdio_success_znc, l_jpix
EXTERN _stdio_filetbl

INCLUDE "../stdio.def"

.fflush

   push hl
   pop ix

.asmentry

   ld a,ixl
   or ixh
   jr nz, flushfile            ; if not fflush(NULL)

   ; fflush(NULL) means flush all open files
   
   ld hl,_stdio_filetbl - 6    ; include stdin / stdout / stderr
   ld b,STDIO_NUMFILE + 3
   
.loop

   ; hl = current position in open file tbl
   ; b = number of remaining file entries
   
   ld c,(hl)
   ld ixl,c
   inc hl
   ld a,(hl)
   ld ixh,a                    ; ix = FILE *
   inc hl
   or c
   
   exx
   call nz, flushfile          ; flush if FILE* not zero
   exx
   
   djnz loop
   jp stdio_success_znc

.flushfile

   ; first we flush any unread (buffered) input
   ;
   ; flushing input means we move back the device
   ; file position by the number of bytes sitting
   ; unread in the buffers.
   ;
   ; ix = FILE *

   bit 2,(ix+3)                ; is this file open for input?
   jr z, flushout

   ld c,STDIO_FLUSH_INBUF      ; flush input buffers further down stream
   ld a,STDIO_MSG_FLSH
   call l_jpix
   
   bit 0,(ix+3)                ; unget char available?
   jr z, flushout

   ld c,STDIO_SEEK_CUR         ; move file position back 1 char
   ld hl,-1
   ld e,l
   ld d,h
   ld a,STDIO_MSG_SEEK
   call l_jpix
   
   res 0,(ix+3)                ; unget char is gone now

.flushout

   ; next we flush any buffered writes to the driver
   ;
   ; note that this is not the same as an fsync -- an fsync tells the
   ; driver to dump its buffers to the device whereas this tells
   ; any higher level stream buffers to dump their data to the driver
   ;
   ; ix = FILE *

   bit 1,(ix+3)                ; is this file open for output?
   jp z, stdio_success_znc

   ld c,STDIO_FLUSH_OUTBUF     ; flush any output buffers in this stream
   ld a,STDIO_MSG_FLSH
   call l_jpix

   jp stdio_success_znc

defc ASMDISP_FFLUSH = # asmentry - fflush
