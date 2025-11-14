
; ===============================================================
; Feb 2014
; ===============================================================

SECTION code_driver
SECTION code_driver_memstream

PUBLIC __stdio_memstream_driver

EXTERN STDIO_MSG_PUTC, STDIO_MSG_WRIT, STDIO_MSG_EATC, STDIO_MSG_READ
EXTERN STDIO_MSG_GETC, STDIO_MSG_SEEK, STDIO_MSG_FLSH, STDIO_MSG_CLOS

EXTERN asm_memset, asm_free, __stdio_file_destroy, l_long_add_exx
EXTERN __array_at, __vector_make_room_best_effort_extra
EXTERN l_minu_bc_hl, l_jphl, asm_b_vector_read_block, asm_b_vector_write_block_extra
EXTERN error_enotsup_zc, error_efbig_zc, error_erange_zc, error_mc, error_znc

__stdio_memstream_driver:

   ; stdio driver for memstreams
   ; implements the i/o portion of the vfs
   ;
   ; enter : ix = FILE *
   ;          a = STDIO_MSG_
   ;         registers set with message parameters
   ;
   ; uses  : all except ix, iy

   cp STDIO_MSG_PUTC
   jp z, PUTC
   
   cp STDIO_MSG_WRIT
   jp z, WRIT
   
   cp STDIO_MSG_EATC
   jr z, EATC
   
   cp STDIO_MSG_READ
   jr z, READ
   
   cp STDIO_MSG_GETC
   jr z, GETC
   
   cp STDIO_MSG_SEEK
   jp z, SEEK
   
   cp STDIO_MSG_FLSH
   jp z, FLSH

   cp STDIO_MSG_CLOS
   jp z, CLOS
   
   ; message not implemented
   
   jp error_enotsup_zc

; =============================================================

EATC:

   ; remove matching chars from the stream
   ;
   ; enter : bc'= reserved do not change
   ;         de'= reserved do not change
   ;         hl'= & qualify function
   ;         hl = length >= 0 = max number of chars to remove
   ;
   ; exit  : bc = num bytes removed from stream
   ;         hl = next char on stream or eof
   ;         carry set on eof

   call get_file_pointer       ; bc = fp_idx
   
   push bc                     ; save fp_idx
   push hl                     ; save length
   
   call get_vector             ; hl = vector *
   
   call __array_at
   jr c, _eatc_at_eof

   ; hl'= qualify function
   ; hl = & vector.array[fp_idx

   ; de = vector.size
   ; bc = fp_idx
   ; stack = fp_idx_old, length

   ex de,hl                    ; hl = vector.size, de = & vector[fp_idx

   sbc hl,bc                   ; hl = num bytes avail in vector

   pop bc                      ; bc = length
   call l_minu_bc_hl           ; hl = min(length, bytes avail)
   
   push af                     ; save flag(avail - length)

   ld c,l
   ld b,h
   inc bc                      ; bc = max chars to read + 1
   
   ex de,hl
   dec hl                      ; hl = & vector[fp_idx] - 1b
   
   ld de,-1                    ; de = number of chars read - 1

_eatc_loop:

   inc de
   
   ; bc = max chars to read + 1
   ; de = number of chars read
   ; hl = char *src - 1
   ; stack = fp_idx_old, flag(avail - length)

   cpi                         ; hl++, bc--
   
   ld a,(hl)                   ; a = char to consume
   jp po, _eatc_max_reached    ; if max read length reached
   
   exx
   call l_jphl                 ; qualify the char
   exx
   
   jr nc, _eatc_loop           ; if char qualifies

_eatc_unqualified:

   ;  a = next char to consume
   ; de = number of chars read
   ; stack = fp_idx_old, flag(avail - length)

   pop hl                      ; junk item
   pop hl                      ; hl = fp_idx_old

_eatc_unqualified_0:

   add hl,de                   ; hl = fp_idx_new
   call set_file_pointer

   ld l,a
   ld h,0                      ; hl = next unconsumed char
   
   ld c,e
   ld b,d                      ; bc = number of chars read
   
   or a
   ret

_eatc_max_reached:

   ;  a = next char to consume
   ; de = number of chars read
   ; stack = fp_idx_old, flag(avail - length)

   ld c,a
   
   pop af                      ; f = flag(avail - length)
   pop hl                      ; hl = fp_idx_old

   ld a,c

   jr z, _eatc_eof             ; if avail == length
   jr nc, _eatc_unqualified_0  ; if avail > length

_eatc_eof:

   call _eatc_unqualified_0
   jp error_mc                 ; indicate eof

_eatc_at_eof:

   pop hl
   pop hl                      ; junk two items on stack

_eatc_at_eof_2:

   ld bc,0                     ; no bytes consumed
   jp error_mc                 ; indicate eof

; =============================================================

READ:

   ; read stream characters into a buffer
   ;
   ; enter : de'= void *buffer = destination address
   ;         bc'= max_length > 0
   ;         hl = max_length > 0
   ;
   ; exit  : bc = number of bytes successfully read
   ;         de'= void *buffer_ptr = address of byte following last written
   ;         carry set on eof with hl = -1

   push hl                     ; save length
   
   call get_vector             ; hl = vector *
   call get_file_pointer       ; bc = fp_idx_old
   
   pop de                      ; de = length
   
   call asm_b_vector_read_block
   jr c, _eatc_at_eof_2        ; if at eof
   
   ; hl = number of bytes read
   ; bc = fp_idx_old
   ; de'= void *buffer_ptr
   
   push hl                     ; save number of bytes read
   
   add hl,bc                   ; hl = fp_idx_new
   call set_file_pointer
   
   pop bc                      ; bc = number of bytes successfully read
   ret

; =============================================================

GETC:

   ; read a single character from the stream
   ;
   ; enter : none
   ;
   ; exit  : hl = char
   ;         carry set on eof with hl = -1

   call get_file_pointer       ; bc = fp_idx_old
   call get_vector             ; hl = vector *
   
   call __array_at
   jp c, error_mc              ; if at eof
   
   inc bc
   call set_file_pointer_bc    ; increment file pointer
   
   ld l,(hl)
   ld h,0                      ; hl = char
   
   ret

; =============================================================

WRIT:

   ; write the buffer to the stream
   ;
   ; enter : bc'= length > 0
   ;         hl'= void *buffer = byte source
   ;         hl = length > 0
   ;
   ; exit  : hl = number of bytes successfully output
   ;         hl'= void *buffer + num written
   ;         carry set if error

   push hl                     ; save length
   
   call get_vector             ; hl = vector *
   
   bit 2,(ix+13)
   call z, get_file_pointer    ; if writing, bc = fp_idx_old
   call nz, get_append_pointer ; if appending, bc = vector.size

   pop de                      ; de = length

   ; hl = vector *
   ; bc = idx
   ; de = length
   ; hl'= void *src
   
   push bc                     ; save idx
   
   exx
   ld de,1                     ; if vector grows, add one extra byte for zero terminator
   exx

   call asm_b_vector_write_block_extra
   
   pop bc                      ; bc = idx
   jp c, error_efbig_zc        ; if error prevented any bytes from being written

   ; hl'= void *buffer + num
   ; de'= & vector.array[idx+num

   ; hl = num bytes written
   ; bc = idx
   ; a = realloc_status = 0 if realloc was performed, -1 if could not write all bytes
   
   bit 2,(ix+13)
   jr nz, _write_no_fp         ; if appending

   ; adjust the file pointer
   
   ld e,l
   ld d,h                      ; de = num bytes written
   
   add hl,bc                   ; hl = fp_idx_new = fp_idx_old + num
   call set_file_pointer
   
   ex de,hl                    ; hl = num bytes written

_write_no_fp:
   
   ; examine realloc_status
      
   inc a
   jr z, _write_incomplete
   
   dec a
   ret nz                      ; if complete write was possible

_write_realloc_performed:

   ; the vector was grown via realloc
   
   exx
   
   xor a
   ld (de),a                   ; zero terminate the buffer
   
   exx
   jp dec_capacity             ; return after hiding the zero terminator

_write_incomplete:

   ; only some of the bytes were written to the vector
   
   ex de,hl
   call error_efbig_zc         ; indicate file too big error
   ex de,hl
   
   ret

; =============================================================

PUTC:

   ; write single char multiple times
   ;
   ; enter :  e' = char
   ;         bc'= number > 0
   ;         hl = number > 0
   ;
   ; exit  : hl = num bytes successfully written
   ;         carry set if error, errno = EFBIG

   push hl                     ; save n
   
   call get_vector             ; hl = vector *
   
   bit 2,(ix+13)
   call z, get_file_pointer    ; if writing, bc = fp_idx_old
   call nz, get_append_pointer ; if appending, bc = vector.size

   pop de                      ; de = n

   inc hl
   inc hl
   
   ex de,hl
   
   ; de = & vector.size
   ; bc = idx
   ; hl = n
   ;  e'= char
   
   push bc                     ; save idx
   
   exx
   ld c,e                      ; c = char
   ld de,1                     ; if vector grows, add one extra byte for zero terminator
   exx
   
   call __vector_make_room_best_effort_extra
   jp c, error_efbig_zc - 1    ; idx out of range should not happen

   ; bc = num bytes available at idx
   ; hl = & vector.array[idx

   ;  a = realloc_status = 0 if realloc performed, -1 if num bytes < n
   ; stack = idx

   push af                     ; save realloc_status
   
   push bc
   push hl
   
   exx
   
   ld e,c                      ; e = char
   pop hl                      ; hl = & vector
   pop bc                      ; bc = num bytes
   
   call asm_memset
   
   pop af                      ; a = realloc status
   
   or a
   jr nz, _putc_no_realloc
   
   ; realloc was performed
   
   ld (de),a                   ; zero terminate the vector
   call dec_capacity           ; hide the zero terminator
   
_putc_no_realloc:

   exx
   
   ; bc = num bytes successfully written
   ;  a = realloc_status = 0 if realloc performed, -1 if num bytes < n
   ; stack = idx

   pop hl                      ; hl = idx

   bit 2,(ix+13)
   jr nz, _putc_no_fp          ; if appending
   
   ; file pointer needs to be adjusted
   
   add hl,bc                   ; hl = fp_idx_new = fp_idx_old + num_bytes
   call set_file_pointer

_putc_no_fp:

   ld l,c
   ld h,b                      ; hl = num bytes written
   
   inc a
   ret nz                      ; if all bytes were written
   
   jr _write_incomplete

; =============================================================

SEEK:

   ; seek to position
   ;
   ; enter :    c = STDIO_SEEK_SET (0), STDIO_SEEK_CUR (1), STDIO_SEEK_END (2)
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
   jr __seek

_seek_end:

   call get_append_pointer
   jr _seek_0

_seek_cur:

   call get_file_pointer

_seek_0:

   ld l,c
   ld h,b

__seek:

   ld de,0                     ; dehl = current position
   
   ; dehl = current position (start, current, end)
   ; dehl'= offset

   call l_long_add_exx         ; dehl = dehl + dehl' = new_position

   ld a,d
   or e
   jr nz, _seek_error          ; if dehl > 64k

   call get_append_pointer     ; bc = buffer size

   sbc hl,bc
   jr nc, _seek_error          ; if new_position >= buffer size
   
   add hl,bc
   call set_file_pointer       ; fp = new_position
   
   or a
   ret

_seek_error:

   call error_erange_zc
   
   ex de,hl                    ; de = 0
   call get_file_pointer

   ld l,c
   ld h,b                      ; dehl = current file pointer
   
   ret

; =============================================================

FLSH:

   ; flush
   ;
   ; write buffer address and size to supplied memory addresses
   ; zero terminate the buffer if size < capacity
   ;
   ; enter : none
   ;
   ; exit  : carry reset

   bit 5,(ix+13)               ; write buffer info ?
   jr z, _flush_terminate      ; if not writing buffer info

   push ix
   pop de                      ; de = FILE *
   
   ld hl,14
   add hl,de                   ; hl = & FILE.bufp
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = char *bufp
   inc hl

   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = size_t *sizep
   inc hl

   ; de = char *bufp
   ; bc = size_t *sizep
   ; hl = & FILE.vector.array
   
   ldi
   ldi                         ; *bufp = vector.array
   
   ld e,c
   ld d,b
   
   inc de
   inc de                      ; de = size_t *sizep
   
   ldi
   ldi                         ; *sizep = vector.size
   
_flush_terminate:

   ; next zero terminate the buffer if size < capacity

   call get_vector             ; hl = vector *

   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = vector.array
   inc hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = vector.size
   inc hl
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = vector.capacity
   
   scf
   sbc hl,de                   ; hl = vector.capacity - vector.size - 1
   jp c, error_znc             ; if size >= capacity do not zero terminate
   
   ; zero terminate
   
   ex de,hl                    ; hl = vector.size
   add hl,bc                   ; hl = & vector.array[size

   
   ld (hl),0                   ; zero terminate the buffer
   ret

; =============================================================

CLOS:

   ; close file
   ;
   ; flush, free buffers if applicable
   ;
   ; enter : none

;;;   call FLSH
;;;   flush always preceeds close message
   
   bit 7,(ix+13)               ; free buffer on close ?
   ret z
   
   ; free the vector array
   
   ld l,(ix+18)
   ld h,(ix+19)                ; hl = vector.array
   
   jp asm_free

; =============================================================

get_file_pointer:

   ; enter : none
   ;
   ; exit  : bc = file pointer index
   ;
   ; uses  : bc

   ld c,(ix+26)
   ld b,(ix+27)
   
   ret

get_append_pointer:

   ; enter : none
   ;
   ; exit  : bc = append pointer index
   ;
   ; uses  : bc

   ld c,(ix+20)
   ld b,(ix+21)
   
   ret


set_file_pointer:

   ; enter : hl = new file pointer index
   ;
   ; uses  : none
   
   ld (ix+26),l
   ld (ix+27),h
   
   ret


set_file_pointer_bc:

   ; enter : bc = new file pointer index
   ;
   ; uses  : none
   
   ld (ix+26),c
   ld (ix+27),b
   
   ret


get_vector:

   ; enter : none
   ;
   ; exit  : hl = vector *
   ;         de = FILE *
   ;
   ; uses  : f, de, hl

   push ix
   pop de

   ld hl,18
   add hl,de
   
   ret


dec_capacity:

   ; enter : none
   ;
   ; exit  : bc = new capacity
   ;
   ; uses  : bc
   
   ld c,(ix+22)
   ld b,(ix+23)
   
   dec bc
   
   ld (ix+22),c
   ld (ix+23),b
   
   ret
