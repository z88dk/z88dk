
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; simple keyboard driver ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC __bdoskbd_driver_00

EXTERN l_jphl
EXTERN error_enotsup_zc, error_znc, error_lznc

EXTERN STDIO_SEEK_CUR
EXTERN STDIO_MSG_GETC, STDIO_MSG_EATC, STDIO_MSG_READ
EXTERN STDIO_MSG_SEEK, STDIO_MSG_FLSH, STDIO_MSG_CLOS

__bdoskbd_driver_00:

   cp STDIO_MSG_GETC
   jr z, __bdoskbd_getc
   
   cp STDIO_MSG_EATC
   jr z, __bdoskbd_eatc
   
   cp STDIO_MSG_READ
   jr z, __bdoskbd_read
   
   cp STDIO_MSG_SEEK
   jr z, __bdoskbd_seek
   
   cp STDIO_MSG_FLSH
   jr z, __bdoskbd_flsh
   
   cp STDIO_MSG_CLOS
   jp z, error_znc             ; do nothing, report no error
   
   jp error_enotsup_zc         ; hl = 0 puts stream in error state

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__bdoskbd_getc:

	call    __bdoskbd_getchar
        push    af
        ld      e,a
        ld      c,2
        call    5
        pop     af
	ld		l,a
	ld		h,0
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__bdoskbd_eatc:

   ; HL'= int (*qualify)(char c)
   ; BC'= optional
   ; DE'= optional
   ; HL = max_length = number of stream chars to consume
   ; 
   ; return: BC = number of bytes consumed from stream
   ;         HL = next unconsumed (unmatching) char or EOF
   ;         BC'= unchanged by driver
   ;         DE'= unchanged by driver
   ;         HL'= unchanged by driver

   ld c,l
   ld b,h                      ; bc = max num chars to consume
   
   ld de,-1                    ; de = num chars consumed - 1
   
__bdoskbd_eatc_loop:

   call __bdoskbd_getchar          ; l = char
   inc de                      ; de = num chars consumed
   
   ld a,b
   or c
   jr z, __bdoskbd_eatc_exit       ; if max num reached
   
   ld a,l                      ; a = char
   exx
   call l_jphl                 ; qualify(a)
   exx
   
   jr c, __bdoskbd_eatc_exit       ; if char is disqualified
   
   dec bc                      ; num chars remaining to consume -= 1
   jr __bdoskbd_eatc_loop

__bdoskbd_eatc_exit:

   ; de = num chars consumed from stream
   ;  l = next unconsumed char

   xor a
   ld h,a                      ; hl = next consumed char
   
   ld (ix+6),l                 ; write unconsumed char into ungetc of FILE struct
   set 0,(ix+4)                ; indicate an unget char is present

   ld c,e
   ld b,d                      ; bc = num chars consumed

   ret                         ; carry reset

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__bdoskbd_read:

   ; DE'= void *buffer = byte destination
   ; BC'= max_length > 0
   ; HL = max_length > 0
   ;
   ; return BC = number of bytes successfully read
   ;        DE'= void *buffer_ptr = address of byte following last written
   ;        carry set on error with HL=0 for stream error, -1 for eof

   ; we never have stream errors or eof
   
   exx
   
__bdoskbd_read_loop:

   ld a,b
   or c
   jr z, __bdoskbd_read_exit       ; if no more chars to read
   
   dec bc
   call __bdoskbd_getchar
   
   ld (de),a                   ; write char to buffer
   inc de

   jr __bdoskbd_read_loop

__bdoskbd_read_exit:

   exx
   
   ld c,l
   ld b,h                      ; bc = max_length
   
   ret                         ; carry is reset

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__bdoskbd_seek:

   ; stdio uses seek forward to ignore input chars for %*[n]c
 
   ;    C = STDIO_SEEK_SET (0), STDIO_SEEK_CUR (1), STDIO_SEEK_END (2)
   ; DEHL'= file offset
   ;    C'= STDIO_SEEK_SET (0), STDIO_SEEK_CUR (1), STDIO_SEEK_END (2)
   ;
   ; return DEHL = current position, carry on error

   exx
   
   ld a,c
   
   CP STDIO_SEEK_CUR
   jp nz, error_lznc           ; if not seeking forward, do nothing

   bit 7,d
   jp nz, error_lznc           ; if negative offset, do nothing
   
   ; dehl = number of chars to seek past
   ; if de != 0 the universe will be over before we are done so ignore it

   ex de,hl                    ; de = number of chars to consume

__bdoskbd_seek_loop:

   ld a,d
   or e
   jp z, error_lznc            ; if num chars == 0

   dec de

   call __bdoskbd_getchar
   jr __bdoskbd_seek_loop
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__bdoskbd_flsh:

   and		a
   
   ret                         ; carry reset

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__bdoskbd_getchar:
	push	bc
	push	de
	push	hl
__bdoskbd_getchar_loop:
	ld		c,6
	ld		e,255
	call	5
	and		a
	jr		z,__bdoskbd_getchar_loop
	
	pop		hl
	pop		de
	pop		bc
	ret



