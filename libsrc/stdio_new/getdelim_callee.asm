; uint __CALLEE__ getdelim_callee(char **lineptr, uint *n, char delimiter, FILE *stream)
; 06.2008 aralbrec

XLIB getdelim_callee
XDEF ASMDISP_GETDELIM_CALLEE

LIB realloc_callee, fgetc, stdio_error_mc, stdio_error_enomem_mc, l_jpix
XREF ASMDISP_REALLOC_CALLEE, ASMDISP_FGETC

INCLUDE "stdio.def"

.getdelim_callee

   pop hl
   pop ix
   pop bc
   pop de
   ex (sp),hl

.asmentry

   ; enter : ix = FILE *
   ;          c = delimeter
   ;         de = uint *n
   ;         hl = char **lineptr
   ; exit  : hl = num bytes written to buffer, carry reset for success
   ;         hl = -1, carry set for fail

   push hl                     ; stack = char **lineptr
   push de                     ; stack = char **lineptr, uint *n
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = char *ptr
   
   push hl                     ; stack = char **lineptr, uint *n, char *ptr
   ex de,hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = bytes remaining in char *ptr
   
   ld a,c
   ld bc,0                     ; bc = size of string thus far
   
   exx
   
   ld c,a                      ; c = delimeter
   
   push bc
   call fgetc + ASMDISP_FGETC  ; get first char possibly the unget char
   pop bc
   ld b,l
   pop hl
   jp c, stdio_error_mc - 2    ; report stream error
   push hl                     ; hl = end of char *ptr

   exx

   ;  ix = FILE *
   ;  de = bytes remaining in char *ptr
   ;  bc = 0 = size of string generated thus far
   ;  hl'= end of char *ptr
   ;   c'= delimeter
   ;   b'= char to write
   ; stack = char **lineptr, uint *n, char *ptr

   ld a,d                      ; make sure there is room for a terminating \0
   or e
   dec de
   jr nz, enterloop

   inc de                      ; de = 0
   call growbuffer             ; since bc=0, calling for two bytes
   jr nc, enterloop            ; get started if successful
   
   ; cant get memory to even get started
   ; just die
   
   pop hl
   jp stdio_error_enomem_mc - 2
   
.loop

   ;  ix = FILE *
   ;  de'= bytes remaining in char *ptr
   ;  bc'= size of string generated thus far
   ;  hl = end of char *ptr
   ;   c = delimeter
   ;   a = char to write
   ; stack = char **lineptr, uint *n, char *ptr

   ld b,a
   exx

.enterloop

   ;  ix = FILE *
   ;  de = bytes remaining in char *ptr
   ;  bc = size of string generated thus far
   ;  hl'= end of char *ptr
   ;   c'= delimeter
   ;   b'= char to write
   ; stack = char **lineptr, uint *n, char *ptr

   ld a,d
   or e
   call z, growbuffer          ; if no more space in buffer, grow buffer
   jr c, exit1                 ; failed to grow buffer so exit

   dec de                      ; space in buffer --   
   inc bc                      ; size of buffer ++
   
   exx
   ld (hl),b                   ; write char into buffer
   inc hl

   ld a,b
   cp c                        ; is it the delimiter?
   jr z, exit0                 ; if so time to stop

   push hl
   push bc
   ld c,STDIO_MSG_GETC
   call l_jpix                 ; read next char from stream
   pop bc
   pop hl
   jp nc, loop

.exit0

   ;  de'= bytes remaining in char *ptr
   ;  bc'= size of string generated thus far
   ;  hl = end of char *ptr
   ; stack = char **lineptr, uint *n, char *ptr

   ld (hl),0                   ; terminate the buffer
   exx

   ;  de = bytes remaining in char *ptr
   ;  bc = size of string generated not including \0
   ; stack = char **lineptr, uint *n, char *ptr

   ld a,d
   or e
   
   pop de                      ; de = char *ptr
   pop hl                      ; hl = uint *n
   
   jr nz, szsame               ; if buffer didnt grow skip
   
   inc bc
   ld (hl),c                   ; write size of buffer in bytes, including \0
   inc hl
   ld (hl),b
   dec bc   
   
.szsame

   pop hl                      ; hl = char **lineptr

   ld (hl),e                   ; write char *ptr
   inc hl
   ld (hl),d

   ld l,c
   ld h,b                      ; return size of string generated
   ret

.exit1

   ;  de = bytes remaining in char *ptr
   ;  bc = size of string generated thus far
   ;  hl'= end of char *ptr
   ;   b'= char to write
   ; stack = char **lineptr, uint *n, char *ptr

   ; have a char from the stream but have no room to store it so push it back
   
   exx
   ld (ix+4),b                 ; store unget char
   set 0,(ix+3)                ; indicate unget char is available
   jp exit0

.growbuffer

   ; grows buffer by one byte
   ; will need a good realloc implementation for this to work well

   ;  ix = FILE *
   ;  de = bytes remaining in char *ptr
   ;  bc = size of string generated thus far
   ;  hl'= end of char *ptr
   ;   c'= delimeter
   ;   b'= char to write
   ; stack = char **lineptr, uint *n, char *ptr, ret

   pop hl
   ex (sp),hl
   push hl                     ; hl = char *ptr

   ; stack = char **lineptr, uint *n, ret, char *ptr

   push de
   push bc
   inc bc
   inc bc                      ; bc = size requested, including space for \0
   call realloc_callee + ASMDISP_REALLOC_CALLEE
   pop bc
   pop de
   ccf
   jr c, nomem                 ; must stop cant get bigger buffer
   
   pop af                      ; trash old char *ptr
   push hl                     ; replace with new char *ptr

   add hl,bc
   push hl
   exx
   pop hl                      ; end of new char *ptr string
   exx   

   inc de
   or a                        ; no carry for success
   
.nomem

   ; stack = char **lineptr, uint *n, ret, char *ptr

   pop hl
   ex (sp),hl
   jp (hl)

defc ASMDISP_GETDELIM_CALLEE = asmentry - getdelim_callee
