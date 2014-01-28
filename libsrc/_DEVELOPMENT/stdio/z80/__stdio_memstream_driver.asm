
XLIB __stdio_memstream_driver

LIB __stdio_file_close
LIB l_jphl, l_minu_bc_hl, l_add_long_exx, l_ltu_hl_bc, l_ltu_hl_de
LIB l_neg_hl, asm_memset, asm_memcpy, asm_free, asm__galloc
LIB error_enotsup_zc, error_efbig_mc, error_erange_zc, error_mc

__stdio_memstream_driver:

   ; stdio driver for memstreams
   ;
   ; enter : ix = FILE *
   ;          a = STDIO_MSG_*
   ;         exx, hl contain parameters
   ;
   ; uses  : all except ix, iy

   cp STDIO_MSG_PUTC
   jr z, PUTC
   
   cp STDIO_MSG_WRIT
   jr z, WRIT
   
   cp STDIO_MSG_EATC
   jr z, EATC
   
   cp STDIO_MSG_READ
   jr z, READ
   
   cp STDIO_MSG_GETC
   jr z, GETC
   
   cp STDIO_MSG_SEEK
   jr z, SEEK
   
   cp STDIO_MSG_FLSH
   jr z, FLSH

   cp STDIO_MSG_CLOS
   jr z, CLOS

   ; message not implemented
   
   jp error_enotsup_zc

PUTC:

   ; write single char multiple times
   ;
   ; enter :  e' = char
   ;         bc'= number > 0
   ;         hl = number > 0
   ;
   ; exit  : hl = num bytes successfully written
   ;         carry set if error, errno = EFBIG

   bit 1,(ix+13)                     ; append or write ?
   call z, mem_get_file_position
   call nz, mem_get_append_position

   ld c,l
   ld b,h
   
   ; bc = number
   ; de = position
   
   call mem_make_space
   call c, error_efbig_mc      ; set errno if error with allocation
   
   ; bc = number (maybe reduced)
   ; de = position
   ; carry set if sufficient space not available
   
   push af                     ; save error indicator
      
   call mem_make_pointer       ; hl = pointer(de)

   push bc
   push hl
   
   exx
   
   pop hl
   pop bc
   
   call asm_memset
   
   exx
   
   ; bc = number
   ; de = position
   ; stack = error indicator
   
   ex de,hl
   add hl,bc
   ex de,hl                    ; de = new position
   
   bit 1,(ix+13)               ; append or write ?
   call nz, mem_set_append_position
   call z, mem_set_file_position
   
   ld l,c
   ld h,b                      ; hl = number of bytes successfully output
   
   pop af                      ; carry set if insufficient space
   ret


WRIT:

   ; write buffer
   ;
   ; enter : hl'= void *buffer
   ;         bc'= length > 0
   ;         hl = length > 0
   ;
   ; exit  : hl = num bytes successfully written
   ;         carry set if error, errno = EFBIG

   bit 1,(ix+13)                     ; append or write ?
   call z, mem_get_file_position
   call nz, mem_get_append_position

   ld c,l
   ld b,h
   
   ; bc = number
   ; de = position
   
   call mem_make_space
   call c, error_efbig_mc      ; set errno if error with allocation
   
   ; bc = number (maybe reduced)
   ; de = position
   ; carry set if sufficient space not available
   
   push af                     ; save error indicator

   call mem_make_pointer       ; hl = pointer(de)

   push bc
   push hl
   
   exx
   
   pop de
   pop bc
   
   call asm_memcpy
   
   exx
   
   ; bc = number
   ; de = position
   ; stack = error indicator
   
   ex de,hl
   add hl,bc
   ex de,hl                    ; de = new position
   
   bit 1,(ix+13)               ; append or write ?
   call nz, mem_set_append_position
   call z, mem_set_file_position
   
   ld l,c
   ld h,b                      ; hl = number of bytes successfully output
   
   pop af                      ; carry set if insufficient space
   ret


EATC:

   ; remove qualifier chars from stream
   ;
   ; enter : bc'= reserved do not change
   ;         de'= reserved do not change
   ;         hl'= & qualify function
   ;         hl = length >= 0 = max number of chars to remove
   ;
   ; exit  : bc = num bytes removed from stream
   ;         hl = next char on stream or eof
   ;         carry set on eof

   call mem_get_file_position  ; de = position
   
   ld c,l
   ld b,h                      ; bc = length
   
   call mem_avail_data         ; hl = amount of available data
   jr z, _read_buffer_empty

   call l_minu_bc_hl           ; hl = min(avail,length)
   
   push af                     ; save carry if avail < length
   push de                     ; save position
   
   ld c,l
   ld b,h
   inc bc                      ; bc = max chars to read + 1
   
   call mem_make_pointer
   dec hl                      ; hl = void *src - 1

   ld de,$ffff                 ; de = number of chars read - 1

_eatc_loop:

   inc de

   ; bc = max chars to read + 1
   ; de = number of chars read
   ; hl = char *s - 1
   ; stack = avail < length, original position

   cpi                         ; hl++, bc--
   
   ld a,(hl)                   ; a = next char to consume
   jp po, _eatc_max_reached    ; if max chars to consume reached

   exx
   call l_jphl                 ; qualify the char
   exx

   jr nc, _eatc_loop           ; if char qualifies

_eatc_unqualified:

   ;  a = next char to consume
   ; de = number of chars read
   ; stack = junk, original position

   pop hl                      ; hl = original position
   pop bc                      ; clear junk

_eatc_unqualified_0:

   add hl,de

   ex de,hl                    ; de = new position, hl = num chars read
   call mem_set_file_position_unchecked
   
   ld c,l
   ld b,h                      ; bc = num chars read
   
   ld l,a
   ld h,0                      ; hl = next unconsumed char

   or a                        ; carry reset
   ret

_eatc_max_reached:

   ;  a = next char to consume
   ; de = number of chars read
   ; stack = avail < length, original position

   ld c,a

   pop hl
   pop af

   ld a,c
   
   jr z, _eatc_eof
   jr nc, _eatc_unqualified_0  ; if chars are still available in the stream
   
_eatc_eof:

   call _eatc_unqualified_0
   jp error_mc                 ; indicate eof


READ:

   ; read to buffer
   ;
   ; enter : de'= void *buffer = destination address
   ;         bc'= length > 0
   ;         hl = length > 0
   ;
   ; exit  : bc = num bytes successfully read
   ;         de'= void *buffer_ptr = address of byte following last written
   ;         carry set on eof with hl=eof

   call mem_get_file_position  ; de = position
   
   ld c,l
   ld b,h                      ; bc = length
   
   call mem_avail_data         ; hl = amount of available data
   jr z, _read_buffer_empty
   
   call l_minu_bc_hl           ; hl = min(avail,length)

   push af                     ; save carry if avail < length
   push de                     ; save position
   push hl                     ; save num bytes to copy
   
   push hl                     ; push num bytes to copy
   
   call mem_make_pointer       ; hl = pointer(de)
   
   push hl                     ; push void *src
   
   exx
   
   pop hl                      ; hl = void *src
   pop bc                      ; bc = uint length
   
   ldir
   
   exx
   
   pop bc                      ; bc = num bytes copied
   pop hl                      ; hl = old position
   
   add hl,bc
   ex de,hl                    ; de = new position
   
   call mem_set_file_position_unchecked
   
   pop af                      ; carry set if request was not satisfied
   ret nc
   
   jp error_mc                 ; indicate eof

_read_buffer_empty:

   ld c,l
   ld b,h                      ; bc = 0 = number of bytes read
   
   jp error_mc                 ; indicate eof


GETC:

   ; read one char from stream
   ;
   ; enter : none
   ;
   ; exit  : hl = char or eof
   ;         carry set on eof

   call mem_get_file_position  ; de = position
   
   call mem_avail_data
   jp z, error_mc              ; if no data available, return eof
   
   call mem_make_pointer       ; hl = pointer(de)
   
   ld l,(hl)
   ld h,0                      ; hl = char
   
   inc de
   jp mem_set_file_position_unchecked  ; carry is reset


SEEK:

   ; seek to position
   ;
   ; enter :    c = STDIO_SEEK_SET, STDIO_SEEK_CUR, STDIO_SEEK_END
   ;         dehl'= offset
   ;
   ; exit  : dehl = updated file position
   ;         carry set if error, errno = ERANGE

   ; not allowed to seek beyond existing buffer
         
   dec c
   jr z, _seek_cur
   
   dec c
   jr z, _seek_end

_seek_set:

   ld hl,0
   jr _seek

_seek_end:

   call mem_get_append_position
   ex de,hl

   jr _seek

_seek_cur:

   call mem_get_file_position
   ex de,hl

_seek:

   ld de,0                     ; dehl = current position
   call l_add_long_exx         ; dehl = new position
   
   ; dehl = new file position
   
   ld a,d
   or e
   jr nz, _seek_error

   ex de,hl                    ; de = new position
   
   call mem_avail_data
   jr c, _seek_error
   
   call mem_set_file_position_unchecked
   
   ex de,hl
   ld de,0                     ; dehl = updated position
   
   ret                         ; carry reset

_seek_error:

   call mem_get_file_position
   call error_erange_zc
   
   ex de,hl                    ; dehl = current position
   ret


FLSH:

   ; flush buffers
   ; in this context means write buffer info to pointers
   ;
   ; enter : none
   ;
   ; exit  : carry reset

   ld l,(ix+18)
   ld h,(ix+19)                ; hl = char *buffer
   
   bit 0,(ix+13)               ; can buffer grow ?
   jr z, _flsh_no_change

   ; buffer can change so store location and size for caller
   
   ex de,hl                    ; de = char *buffer
   
   ld l,(ix+16)
   ld h,(ix+17)                ; hl = size_t *sizep

   ld c,(ix+20)
   ld b,(ix+21)                ; bc = uint end   
   inc bc                      ; bc = end + 1 = size

   ld (hl),c
   inc hl
   ld (hl),b                   ; *sizep = size
   
   ld l,(ix+14)
   ld h,(ix+15)                ; hl = char **bufp
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; *bufp = buffer
   
   ex de,hl                    ; hl = char *buffer

_flsh_no_change:

   call mem_get_append_position
   add hl,de
   
   xor a
   ld (hl),a                   ; zero terminate the buffer
   ret


CLOSE:

   ; close file
   ; flush, free buffers if applicable and free FILE*
   ;
   ; enter : none

   call FLSH
   
   bit 7,(ix+13)               ; free buffer on close ?
   jr z, _close_no_free

   ld l,(ix+18)
   ld h,(ix+19)                ; hl = char *buffer
   
   call asm_free               ; free the buffer

_close_no_free:

   ld e,ixl
   ld d,ixh
   
   push de
   ex de,hl
   
   call __stdio_file_close
   
   pop hl
   jp asm_free


mem_avail_data:

   ; return number of bytes available for reading from position
   ;
   ; enter : de = uint position
   ;
   ; exit  : de = uint position
   ;         hl = amount of data available
   ;
   ;         z flag set if no data available
   ;
   ; uses  : f, hl
   
   ld l,(ix+24)
   ld h,(ix+25)                ; hl = uint append
   
   or a
   sbc hl,de                   ; hl = append - position

   ret

mem_make_space:

   ; make space available for writing @ position
   ;
   ; enter : bc = number of bytes
   ;         de = uint position
   ;
   ; exit  : de = uint position
   ;
   ;         if carry reset
   ;
   ;            bc = number of bytes
   ;            sufficient space available
   ;
   ;         if carry set
   ;
   ;            bc = max number of bytes (reduced)
   ;            insufficient space available
   ;
   ;         char *buffer and uint end may change if realloc occurs
   ;
   ; uses  : af, bc, hl
   
   ld l,(ix+20)
   ld h,(ix+21)                ; hl = uint end
   
   or a
   sbc hl,de                   ; hl = end - position = available bytes
   
   call l_ltu_hl_bc
   ret nc                      ; if avail >= number

   ; attempt to realloc more memory
   ; all or nothing here, should we also aim for smaller
   ; growth to capture more stream output ?
   
   bit 0,(ix+13)
   jr z, growth_denied         ; if buffer cannot be realloced

   push bc                     ; save number of bytes
   push de                     ; save position
   push hl                     ; save available space
   
   or a
   sbc hl,bc
   call l_neg_hl               ; hl = number - available = shortage

   ld c,l
   ld b,h                      ; bc = growth size
   
   ld e,(ix+18)
   ld d,(ix+19)                ; de = char *buffer
   
   call asm__galloc            ; attempt to grow buffer
   jr c, growth_failed
   
   ; hl = new char *buffer
   ; bc = new block size
   ; stack = num bytes, position, avail space

   ld (ix+18),l
   ld (ix+19),h                ; store new char *buffer
   
   dec bc
   ld (ix+20),c
   ld (ix+21),b                ; store new end
   
   pop de
   pop de                      ; de = position
   pop bc                      ; bc = number bytes
   
   ret                         ; carry reset for success

growth_failed:

   pop hl                      ; hl = avail space
   pop de                      ; de = position
   pop bc                      ; bc = number

growth_denied:

   ld c,l
   ld b,h                      ; return available space

   ret                         ; carry is set

mem_get_file_position:

   ; return file position
   ;
   ; exit : de = uint position
   ;
   ; uses : de

   ld e,(ix+22)
   ld d,(ix+23)
   
   ret

mem_set_file_position_unchecked:

   ; set new file position, assume it is valid, assume append is larger
   ;
   ; enter : de = new uint position
   ;
   ; exit  : de = new uint position
   ;
   ; uses  : none

   ld (ix+22),e
   ld (ix+23),d                ; write new position

   ret

mem_set_file_position:

   ; set new file position, assume it is valid
   ;
   ; enter : de = new uint position
   ;
   ; exit  : de = new uint position
   ;
   ; uses  : af, hl

   call mem_set_file_position_unchecked
   
   ; if file position is > append position also need to update append
   
   ld l,(ix+24)
   ld h,(ix+25)                ; hl = uint append
   
   call l_ltu_hl_de
   ret p                       ; if hl >= de return
   
   ; fall through to mem_set_append_position

mem_set_append_position:

   ; set new append position, assume it is valid
   ;
   ; enter : de = new uint append
   ;
   ; exit  : de = new uint append
   ;
   ; uses  : none

   ld (ix+24),e
   ld (ix+25),d
   
   ret

mem_get_append_position:

   ; return append position
   ;
   ; exit : de = uint append
   ;
   ; uses : de
   
   ld e,(ix+24)
   ld d,(ix+25)
   
   ret

mem_make_pointer:

   ; return pointer into buffer corresponding to a position
   ;
   ; enter : de = uint position
   ;
   ; exit  : de = uint position
   ;         hl = char *buffer_ptr
   ;
   ; uses  : f, hl
   
   ld l,(ix+18)
   ld h,(ix+19)                ; hl = char *buffer
   
   add hl,de
   ret
