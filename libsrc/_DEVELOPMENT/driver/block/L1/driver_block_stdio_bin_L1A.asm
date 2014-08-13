
; =============================================================
; Aug 2014
; =============================================================

; Base Class for all binary block devices.
;
; Consumes stdio stream messages and generates block messages
; that are interpretted by classes derived from this one.
; 
; Effectively converts char oriented i/o requests into
; block i/o requests.  The class that derives from this one
; is intended to be a buffer manager that holds images of
; the block device's records in memory.
;
; There is one unfortunate dependency on the buffer manager's
; data structure in "eatc_entire_record_1".  The word following
; "& record->flags" must hold the address of the buffer in memory
; ("& record->data").


PUBLIC driver_block_stdio_bin_L1A

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EXTERN STDIO_MSG_PUTC, STDIO_MSG_WRIT, STDIO_MSG_EATC, STDIO_MSG_READ
EXTERN STDIO_MSG_GETC, STDIO_MSG_SEEK, STDIO_MSG_FLSH, STDIO_MSG_CLOS

EXTERN BLOCK_MSG_FP_TO_EOF, BLOCK_MSG_FP_TO_MAX, BLOCK_MSG_EOF_TO_MAX
EXTERN BLOCK_MSG_FP, BLOCK_MSG_EOF
EXTERN BLOCK_MSG_FP_RECORD, BLOCK_MSG_EOF_RECORD
EXTERN BLOCK_MSG_READ_RECORD, BLOCK_MSG_WRITE_RECORD, BLOCK_MSG_WRITE_MODE
EXTERN BLOCK_MSG_PIN_RECORD, BLOCK_MSG_CREATE_RECORD
EXTERN BLOCK_MSG_UNPIN_RECORD, BLOCK_MSG_UNPIN_DIRTY_RECORD
EXTERN BLOCK_MSG_UNPIN_RECORD_ACTIVE, BLOCK_MSG_UNPIN_DIRTY_RECORD_ACTIVE

EXTERN l_jpix, l_long_load_mhl, l_long_addus_exx, error_mc, error_zc
EXTERN l_long_inc_mhl, l_minu_bc_dehl, l_jphl, l_long_add_mhl_bc
EXTERN l_long_cmpu_mde_mhl, asm_memset, error_enotsup_zc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

driver_block_stdio_bin_L1A:

   cp STDIO_MSG_EATC
   jr z, eatc
  
   cp STDIO_MSG_WRIT
   jr z, writ

   cp STDIO_MSG_GETC
   jr z, getc

   cp STDIO_MSG_READ
   jr z, read
  
   cp STDIO_MSG_PUTC
   jr z, putc
    
   cp STDIO_MSG_CLOS
   ret z                        ; nothing to do for close here
  
   cp STDIO_MSG_FLSH
   ret z                        ; nothing to do for flush here
   
   cp STDIO_MSG_SEEK
   jp nz, error_enotsup_zc      ; hl = 0 puts stream in error state except for ICTL
  
   ; fall through

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

seek:

   ; set file pointer to new position
   ; 
   ;    A = STDIO_MSG_SEEK
   ;    C = STDIO_SEEK_SET (0), STDIO_SEEK_CUR (1), STDIO_SEEK_END (2)
   ; DEHL'= file offset
   ;    C'= STDIO_SEEK_SET (0), STDIO_SEEK_CUR (1), STDIO_SEEK_END (2)
   ;
   ; return:
   ;
   ; DEHL = updated file position
   ; carry set on error (file position out of range)

   dec c
   jr z, seek_cur
   
   dec c
   jr z, seek_end

seek_set:

   exx
   jr seek_setfp               ; dehl = new file pointer

seek_end:

   ld a,BLOCK_MSG_EOF           ; eof file pointer
   jr seek_getfp

seek_cur:

   ld a,BLOCK_MSG_FP            ; current file pointer

seek_getfp:

   call l_jpix                 ; hl = & file pointer
   call l_long_load_mhl        ; dehl = *hl = file pointer
   
   exx
   
   ; dehl = signed file offset
   ; dehl'= unsigned file pointer
   
   call l_long_addus_exx       ; dehl = new file pointer
   
seek_setfp:

   ; dehl = new file pointer
   
   push hl                     ; save LSW
   push de                     ; save MSW
   
   ex de,hl                    ; de = LSW
   
   ld a,BLOCK_MSG_FP
   call l_jpix                 ; hl = & file pointer
   
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   
   pop de                      ; de = MSW
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; file pointer = new file pointer
   
   pop hl                      ; hl = LSW
   
   or a
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

getc:

   ; read a single character from the stream
   ; 
   ; return: HL = char
   ;         carry set on error (HL=0) or eof (HL=-1)

   ld a,BLOCK_MSG_FP_TO_EOF
   call l_jpix                 ; determine if at EOF
   
   jp c, error_mc              ; if at EOF
   
   push hl
   push hl                     ; create L_record_num
   
   ld hl,0
   add hl,sp
   ex de,hl                    ; de = L_record_num *
   
   ld a,BLOCK_MSG_FP_RECORD
   call l_jpix                 ; get info on record containing file pointer
   
   ; de = L_record_num *
   ; hl = offset into record
   ; bc = num bytes remaining in record
   ; stack = L_record_num
   
   push bc                     ; save bytes remaining in record
   push hl                     ; save record offset
   
   ex de,hl                    ; hl = L_record_num *
   
   ld a,BLOCK_MSG_PIN_RECORD
   call l_jpix                 ; bring record into memory
   
   pop bc                      ; bc = record offset
   jp c, error_zc - 3          ; if i/o error
   
   ; hl = & record->flags
   ; de = & record->data
   ; bc = record offset
   ; stack = L_record_num, bytes remaining in record
   
   ex de,hl                    ; de = & record->flags

   add hl,bc                   ; hl = void *src
   ld l,(hl)                   ; l = char
   
   ex (sp),hl                  ; hl = bytes remaining in record
   
   dec hl
   ld a,h
   or l                        ; bytes remaining in record now zero ?
   
   ex de,hl                    ; hl = & record->flags
   
   ; hl = & record->flags
   ; stack = L_record_num, char
   
   ld a,BLOCK_MSG_UNPIN_RECORD_ACTIVE
   jr nz, getc_unpin           ; if more bytes are available in record
   ld a,BLOCK_MSG_UNPIN_RECORD

getc_unpin:

   call l_jpix                 ; unpin record
   
   ; stack = L_record_num, char
   
   ld a,BLOCK_MSG_FP
   call l_jpix                 ; hl = & file pointer
   
   call l_long_inc_mhl         ; file pointer++
   
   pop hl
   xor a
   ld h,a                      ; hl = char
   
   pop bc
   pop bc                      ; junk item
   
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

eatc:

   ; read chars from the stream until one is disqualified
   ;
   ; HL'= int (*qualify)(char c)
   ; HL = max_length = max number of stream chars to consume >= 0
   ; exx set must not be modified
   ; 
   ; return: BC = number of bytes consumed from stream
   ;         HL = next unconsumed (unmatching) char or EOF

   push hl
   push hl                     ; create space for L_record_num
   
   push hl                     ; save max_len
   
   ld a,BLOCK_MSG_FP_TO_EOF
   call l_jpix                 ; find out number of bytes to EOF
   
   jp c, error_mc - 3          ; if at EOF already (with bc = 0)
   
   ;  dehl = number of bytes to eof
   ;    bc = record size in bytes
   ; stack = L_record_num, max_len
   
   pop af
   push bc
   push af
   pop bc                      ; bc = max_len
   
   call l_minu_bc_dehl         ; hl = min(bc = max_len, dehl = num bytes to eof)
   
   pop bc                      ; bc = record size
   push af                     ; save flag(avail - max_len)
   push hl                     ; save num_bytes_remaining
   push bc                     ; save record size
   
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size

   ld hl,6
   add hl,sp
   ex de,hl                    ; de = L_record_num *
   
   ld a,BLOCK_MSG_FP_RECORD
   call l_jpix                 ; get info on record containing file pointer
   
   ; de = L_record_num *
   ; hl = offset into record
   ; bc = bytes remaining in record
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size

   push hl
   ex de,hl
   
   ; hl = L_record_num *
   ; bc = bytes remaining in record
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, offset into record
   
   jr z, eatc_record_next      ; if offset == 0 start at beginning of record
   push bc                     ; save bytes remaining in record
   
   ld a,BLOCK_MSG_PIN_RECORD
   call l_jpix                 ; bring record into memory
   
   jr c, eatc_error_0          ; if i/o error
   
   ; hl = & record->flags
   ; de = & record->data
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, offset into record, bytes remaining in record

   pop bc                      ; bc = bytes remaining in record
   ex (sp),hl                  ; hl = offset into record
   
   add hl,de                   ; hl = char *src
   push hl
   
   ; bc = bytes remaining in record
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, & record->flags, char *src
   
   ld hl,6
   add hl,sp
   
   ld e,l
   ld d,h
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = num bytes remaining
   
   sbc hl,bc                   ; num bytes remaining -= bytes remaining in record
   jr nc, eatc_entire_record_0 ; if entire record can be consumed
   add hl,bc
   
   ld c,l
   ld b,h                      ; bc = num bytes remaining < bytes remaining in record

eatc_entire_record_0:

   ; hl = updated num bytes remaining
   ; bc = num chars avail in record
   ; de = & num bytes remaining
   ;  f = flag(num bytes remaining - record size)
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, & record->flags, char *src

   ex de,hl
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; update num bytes remaining

   pop hl                      ; hl = char *src
   push af                     ; save flag(num bytes remaining - record size)
   
   ld de,-1

eatc_loop_0:

   dec hl
   inc bc

eatc_loop_1:
   
   inc de
   
   ; bc = num chars avail in record + 1
   ; de = num chars read
   ; hl = char *src - 1
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, & record->flags, flag(num_bytes_remaining - record_size)

   cpi                         ; hl++, bc--
   jp po, eatc_record_end      ; if current record exhausted
   
   ld a,(hl)                   ; a = current char
   
   exx
   call l_jphl                 ; qualify the char
   exx
   
   jp nc, eatc_loop_1          ; if char is accepted
   
eatc_disqualified:

   ; de = num chars read
   ; hl = char *src
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, & record->flags, flag(num_bytes_remaining - record_size)

   pop af                      ; junk item
   
   ld l,(hl)                   ; l = next char
   ex (sp),hl                  ; hl = & record->flags
   
   push de                     ; save num chars read
   
   ld a,BLOCK_MSG_UNPIN_RECORD_ACTIVE
   call l_jpix                 ; unpin record and mark as active

   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, next char, num chars read
   
   pop bc                      ; bc = num chars read
   pop de                      ; e = next char
   
   ld hl,10
   add hl,sp
   ld sp,hl                    ; clear stack

eatc_adjust_fp:

   ; bc = num chars read
   ; e = next char

   ld a,BLOCK_MSG_FP
   call l_jpix                 ; hl = & file_pointer
   
   call l_long_add_mhl_bc      ; file_pointer += bc
   
   ld l,e
   xor a
   ld h,a                      ; hl = next unconsumed char
   
   ret

eatc_record_end:

   ; de = num chars read
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, & record->flags, flag(num_bytes_remaining - record_size)

   pop af                      ; flags(num bytes remaining - record size)
   jr c, eatc_done_active_1    ; if all bytes read and current record is active
   
   pop hl                      ; hl = & record->flags
   push de                     ; save num chars read
   
   ld a,BLOCK_MSG_UNPIN_RECORD
   call l_jpix                 ; unpin record
   
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, num chars read
   
   ld hl,8
   add hl,sp                   ; hl = L_record_num *
   
   ld e,l
   ld d,h                      ; de = L_record_num *
   
   call l_long_inc_mhl         ; L_record_num++
   ex de,hl                    ; hl = L_record_num *

eatc_record_next:

   ; hl = L_record_num *
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, num chars read

   ld a,BLOCK_MSG_PIN_RECORD
   call l_jpix                 ; pin next record in memory
   
   jr c, eatc_error_1          ; if i/o error
   
   ; hl = & record->flags
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, num chars read
   
   pop de                      ; de = num chars read
   pop bc                      ; bc = record size
   ex (sp),hl                  ; hl = num bytes remaining
   
   ld a,h
   or l
   jr z, eatc_done_active_0    ; if all bytes read and current record is active
   
   sbc hl,bc                   ; num bytes remaining -= record size
   jr nc, eatc_entire_record_1 ; if entire record can be consumed
   add hl,bc
   
   ld c,l
   ld b,h                      ; bc = max num bytes to read from record

eatc_entire_record_1:

   ; hl = updated num bytes remaining
   ; de = num chars read
   ; bc = num bytes to read from record
   ;  f = flag(num bytes remaining - record size)
   ; stack = L_record_num, flag(avail - max_len), & record->flags
   
   ex (sp),hl
   push bc
   push hl
   push af
   
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = & record->data
   
   dec de

   ; bc = max chars to read in record
   ; de = num chars read - 1
   ; hl = char *src
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, & record->flags, flag(num_bytes_remaining - record_size)

   jr eatc_loop_0

eatc_done_active_0:

   ; de = num chars read
   ; stack = L_record_num, flag(avail - max_len), & record->flags

   pop hl                      ; hl = & record->flags
   push hl
   push hl
   push hl
   
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a

eatc_done_active_1:

   ; de = num chars read
   ; hl = char *src
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, & record->flags

   ld l,(hl)                   ; l = next char
   ex (sp),hl                  ; hl = & record->flags
   
   push de                     ; save num chars read
   
   ld a,BLOCK_MSG_UNPIN_RECORD_ACTIVE
   call l_jpix                 ; unpin record and mark as active
   
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, next char, num chars read
   
   pop bc                      ; bc = num chars read
   pop de                      ; e = next char
   
   pop af
   pop af
   pop af                      ; flag(avail - max_len) = why stopped here
   
   pop hl
   pop hl                      ; junk item
   
   jr z, eatc_eof              ; if available == max_len requested
   jr nc, eatc_adjust_fp       ; if available >> max_len requested

eatc_eof:

   call eatc_adjust_fp         ; increase file pointer
   jp error_mc                 ; indicate eof

eatc_error_0:

   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, offset into record, bytes remaining in record

   ld hl,14
   add hl,sp
   ld sp,hl                    ; clear stack
   
   ld bc,0                     ; nothing read
   jp error_zc                 ; indicate i/o error

eatc_error_1:

   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, num chars read
   
   pop bc                      ; bc = num chars read
   
   ld hl,10
   add hl,sp
   ld sp,hl                    ; clear stack
   
   call eatc_adjust_fp         ; increase file pointer
   jp error_zc                 ; indicate i/o error

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

read:

   ; read stream characters into a buffer
   ;
   ;  A = STDIO_MSG_READ
   ; DE'= void *buffer = byte destination
   ; BC'= max_length > 0
   ; HL = max_length > 0
   ;
   ; return:
   ;
   ; BC = number of bytes successfully read
   ; DE'= void *buffer_ptr = address of byte following last written
   ; carry set on error (HL=0) or eof (HL=-1)

   push hl
   push hl                     ; create space for L_record_num
   
   push hl                     ; save max_len
   
   ld a,BLOCK_MSG_FP_TO_EOF
   call l_jpix                 ; find number of bytes to EOF
   
   jp c, error_mc - 3          ; if at EOF already (with bc = 0)

   ;  dehl = number of bytes to eof
   ;    bc = record size in bytes
   ; stack = L_record_num, max_len
   
   pop af
   push bc
   push af
   pop bc                      ; bc = max_len
   
   call l_minu_bc_dehl         ; hl = min(bc = max_len, dehl = num bytes to eof)
   
   pop bc                      ; bc = record size
   push hl                     ; save max num bytes (total to transfer)
   push bc                     ; save record size
   push hl                     ; save num bytes remaining (total remaining to transfer)

   ; stack = L_record_num, max_num_bytes, record size, num bytes remaining
   
   ld hl,6
   add hl,sp
   ex de,hl                    ; de = L_record_num *
   
   ld a,BLOCK_MSG_FP_RECORD
   call l_jpix                 ; get info on record containing file pointer
   
   jr z, read_loop_0           ; if file_ptr is at first byte in record
   
   ; file_ptr points into middle of record
   
   ; de = L_record_num *
   ; hl = offset into record
   ; bc = bytes remaining in record
   ; de'= void *dst
   ; stack = L_record_num, max_num_bytes, record_size, num_bytes_remaining
   ; carry reset

   ex (sp),hl                  ; hl = num bytes remaining
   
   sbc hl,bc                   ; num bytes remaining -= bytes remaining in record
   jr nc, read_entire_record
   add hl,bc
   
   ld c,l
   ld b,h                      ; bc = num bytes remaining

read_entire_record:

   ex (sp),hl                  ; hl = offset into record
   
   push af                     ; save flags(num bytes remaining - bytes in record)
   push bc                     ; save num bytes in record
   push hl                     ; save offset
   
   ; de = L_record_num *
   ; de'= void *dst
   ; stack = L_record_num, max_num_bytes, record_size, num_bytes_remaining, flags(num bytes remaining - bytes in record), num_bytes in record, offset
   
   ex de,hl                    ; hl = L_record_num *
   
   ld a,BLOCK_MSG_PIN_RECORD
   call l_jpix                 ; bring record into memory
   
   jr c, read_error_0          ; if i/o error
   
   ; hl = & record->flags
   ; de = & record->data
   ; stack = L_record_num, max_num_bytes, record_size, num_bytes_remaining, flags(num bytes remaining - bytes in record), num_bytes in record, offset

   push de
   
   exx
   
   pop hl                      ; hl = & record->data
   pop bc                      ; bc = offset into record
   
   add hl,bc                   ; hl = char *src
   
   pop bc                      ; bc = num bytes in record
   
   ldir
   
   exx
   
   pop af                      ; flags(num bytes remaining - bytes in record)

   ; hl = & record->flags
   ;  f = flags(num bytes remaining - bytes in record)
   ; stack = L_record_num, max_num_bytes, record_size, num_bytes_remaining
   
   ld a,BLOCK_MSG_UNPIN_RECORD_ACTIVE
   jr c, read_initial_record   ; if num bytes remaining < bytes in record
   ld a,BLOCK_MSG_UNPIN_RECORD

read_initial_record:

   push af                     ; save flags(num bytes remaining - bytes in record)
   call l_jpix                 ; unpin current record
   pop af                      ; flags(num bytes remaining - bytes in record)
   
   ;  f = flags(num bytes remaining - bytes in record)
   ; de'= void *dst
   ; stack = L_record_num, max_num_bytes, record_size, num_bytes_remaining
   
   jr c, read_success_0        ; if num bytes remaining << bytes in record
   jr z, read_success_0        ; if num bytes remaining == bytes in record
   
   ld hl,6
   add hl,sp                   ; hl = L_record_num *
   
   call l_long_inc_mhl         ; L_record_num++

read_loop_0:

   ; de'= void *dst
   ; stack = L_record_num, max_num_bytes, record_size, num_bytes_remaining

   pop hl
   pop bc

read_loop_1:

   ; hl = num bytes remaining
   ; bc = record size
   ; de'= void *dst
   ; stack = L_record_num, max num bytes

   or a
   sbc hl,bc                   ; num bytes remaining -= record size
   
   jr c, read_partial          ; if bytes remaining < record size
   
   push bc                     ; save record size
   
   exx
   
   push de                     ; save void *dst
   
   ld hl,6
   add hl,sp                   ; hl = L_record_num *
   
   ld a,BLOCK_MSG_READ_RECORD
   call l_jpix                 ; read record directly into user memory
   
   pop hl                      ; hl = void *dst
   pop bc                      ; bc = record size
   
   jr c, read_error_1          ; if i/o error (num bytes remaining needs restoration)
   
   add hl,bc                   ; advance destination address
   ex de,hl
   
   ld hl,2
   add hl,sp                   ; hl = L_record_num *
   
   call l_long_inc_mhl         ; L_record_num++
   
   exx
   
   jr read_loop_1

read_partial:

   add hl,bc
   jr z, read_success_1        ; if num bytes remaining == 0
   
   push hl                     ; save num bytes remaining
   
   ; de'= void *dst
   ; stack = L_record_num, max num bytes, num bytes remaining

   ld hl,4
   add hl,sp                   ; hl = L_record_num *
   
   ld a,BLOCK_MSG_PIN_RECORD
   call l_jpix                 ; bring record into memory
   
   jr c, read_error_2          ; if i/o error
   
   ; hl = & record->flags
   ; de = & record->data
   ; de'= void *dst
   ; stack = L_record_num, max num bytes, num bytes remaining
   
   push de
   
   exx
   
   pop hl                      ; hl = & record->data
   pop bc                      ; bc = num bytes remaining
   
   ldir
   
   exx
   
   ; hl = & record->flags
   ; de'= void *dst
   ; stack = L_record_num, max num bytes
   
   ld a,BLOCK_MSG_UNPIN_RECORD_ACTIVE
   call l_jpix                 ; unpin record and mark as in use

read_success_1:

   ; de'= void *dst
   ; stack = L_record_num, max num bytes
   
   pop bc                      ; bc = max num bytes (successfully read them all)
   
   pop hl
   pop hl                      ; junk item
   
read_adjust_fp:

   ; de'= void *dst
   ; bc = num bytes successfully read
   
   ld a,BLOCK_MSG_FP
   call l_jpix                 ; hl = & file pointer
   
   call l_long_add_mhl_bc      ; file pointer += bc
   
   or a
   ret

read_success_0:

   ; de'= void *dst
   ; stack = L_record_num, max_num_bytes, record_size, num_bytes_remaining

   pop bc
   pop bc                      ; junk items
   
   jr read_success_1

read_error_0:

   ; de'= void *dst
   ; stack = L_record_num, max_num_bytes, record_size, num_bytes_remaining, flags(num bytes remaining - bytes in record), num_bytes in record, offset

   ld hl,16
   add hl,sp
   ld sp,hl                    ; clear stack
   
   ld bc,0                     ; nothing read successfully
   jp error_zc                 ; hl = 0, carry set indicates i/o error

read_error_1:

   ; hl'= num bytes remaining (must add record size)
   ; bc'= record size
   ; hl = void *dst
   ; stack = L_record_num, max num bytes

   ex de,hl
   exx
   
   add hl,bc
   push hl

read_error_2:

   ; de'= void *dst
   ; stack = L_record_num, max num bytes, num bytes remaining
   
   pop bc                      ; bc = num bytes remaining
   pop hl                      ; hl = max num bytes
   
   pop de
   pop de                      ; junk item
   
   or a
   sbc hl,bc                   ; hl = num bytes successfully read
   
   ld c,l
   ld b,h                      ; bc = num bytes successfully read

   call nz, read_adjust_fp     ; if bc > 0 adjust file pointer
   jp error_zc                 ; hl = 0, carry set indicates i/o error

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

writ:

   ; write buffer to stream
   ;
   ;  A = STDIO_MSG_WRIT
   ; HL = length > 0
   ; BC'= length > 0
   ; HL'= void *buffer = byte source
   ;
   ; return:
   ;
   ; HL'= void *buffer + num bytes written
   ; HL = number of bytes successfully output
   ; carry set if error

   push hl
   push hl                     ; create L_record_num
   
   ld a,BLOCK_MSG_WRITE_MODE
   call l_jpix                 ; nz if append mode
   
   push af                     ; save flag(write mode)
   push hl                     ; save max num bytes
      
   ld a,BLOCK_MSG_FP_TO_MAX
   jr z, writ_mode_0           ; if write mode
   ld a,BLOCK_MSG_EOF_TO_MAX

writ_mode_0:

   call l_jpix                 ; determine max bytes that can be written
   jp c, error_zc - 4          ; if file already at max size

   ; dehl = max num bytes that can be written
   ;   bc = record size
   ;   hl'= void *src
   ; stack = L_record_num, flag(write mode), max num bytes
   
   pop af
   push bc
   push af
   pop bc                      ; bc = max num bytes
   
   call l_minu_bc_dehl         ; hl = min(bc = max_num_bytes, dehl = max_write)
   
   pop bc                      ; bc = record size
   pop af                      ; f = flag(write mode)
   
   push af                     ; save flag(write mode)
   push hl                     ; save max num bytes
   push bc                     ; save record size
   push hl                     ; save num bytes remaining
   
   ; hl'= void *src
   ;  f = flag(write mode)
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining
   
   ld a,BLOCK_MSG_FP_RECORD
   jr z, writ_mode_1           ; if write mode
   ld a,BLOCK_MSG_EOF_RECORD

writ_mode_1:

   ld hl,8
   add hl,sp
   ex de,hl                    ; de = L_record_num *
   
   call l_jpix                 ; get info on first record to write
   jr z, writ_loop_0           ; if write pointer is at start of record

   ; write pointer is in middle of record

   ; de = L_record_num *
   ; hl = offset into record
   ; bc = num bytes remaining in record
   ; hl'= void *src
   ; carry reset
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining

   ex (sp),hl                  ; hl = num bytes remaining
   
   sbc hl,bc                   ; num bytes remaining -= bytes in record
   jr nc, writ_entire_record   ; if num bytes remaining >= bytes in record
   add hl,bc
   
   ld c,l
   ld b,h                      ; bc = num bytes to write into record

writ_entire_record:

   ex (sp),hl                  ; hl = offset into record
   
   push af                     ; save flag(num bytes remaining - bytes in record)
   push bc                     ; save num bytes in record
   push hl                     ; save offset
   
   ; de = L_record_num *
   ; hl'= void *src
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining, flag(num bytes remaining - bytes in record), bytes in record, offset
   
   ex de,hl                    ; hl = L_record_num *
   
   ld a,BLOCK_MSG_PIN_RECORD
   call l_jpix                 ; bring record into memory
   
   jr c, writ_error_0          ; if i/o error
   
   ; hl = & record->flags
   ; de = & record->data
   ; hl'= void *src
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining, flag(num bytes remaining - bytes in record), bytes in record, offset

   push de
   
   exx
   
   pop de
   ex de,hl                    ; hl = & record->data

   pop bc                      ; bc = record offset
   add hl,bc                   ; hl = void *dst
   
   pop bc                      ; bc = num bytes in record
   ex de,hl                    ; hl = void *src, de = void *dst
   
   ldir
   
   exx
   
   pop af                      ; f = flag(num bytes remaining - bytes in record)
   
   ; hl = & record->flags
   ;  f = flag(num bytes remaining - bytes in record)
   ; hl'= void *src
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining
   
   ld a,BLOCK_MSG_UNPIN_DIRTY_RECORD
   jr nc, writ_initial_record  ; if num bytes remaining >= bytes in record
   ld a,BLOCK_MSG_UNPIN_DIRTY_RECORD_ACTIVE

writ_initial_record:

   push af                     ; save flag(num bytes remaining - bytes in record)
   call l_jpix                 ; unpin dirty record
   pop af                      ; f = flag(num bytes remaining - bytes in record)
   
   ;  f = flag(num bytes remaining - bytes in record)
   ; hl'= void *src
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining

   jr c, writ_success_0        ; if num bytes remaining < bytes in record
   jr z, writ_success_0        ; if num bytes remaining = bytes in record
   
   ld hl,8
   add hl,sp                   ; hl = L_record_num *
   
   call l_long_inc_mhl         ; L_record_num++

writ_loop_0:

   ; hl'= void *src
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining

   pop hl
   pop bc
   
   exx
   ex de,hl
   exx

writ_loop_1:

   ; hl = num bytes remaining
   ; bc = record size
   ; de'= void *src
   ; stack = L_record_num, flag(write mode), max num bytes
   
   or a
   sbc hl,bc                   ; num bytes remaining -= record size
   
   jr c, writ_partial          ; if num bytes remaining < record size
   
   push bc                     ; save record size
   
   exx
   
   push de                     ; save void *src
   
   ld hl,8
   add hl,sp                   ; hl = L_record_num *
   
   ld a,BLOCK_MSG_WRITE_RECORD
   call l_jpix                 ; write record directly to disk
   
   pop hl                      ; hl = void *src
   pop bc                      ; bc = record size
   
   jr c, writ_error_1          ; if i/o error (num bytes remaining needs restoration)
   
   add hl,bc                   ; advance source address
   ex de,hl                    ; de = void *src
   
   ld hl,4
   add hl,sp                   ; hl = L_record_num *
   
   call l_long_inc_mhl         ; L_record_num++
   
   exx
   
   jp writ_loop_1

writ_partial:

   add hl,bc
   jr z, writ_success_1        ; if num bytes remaining == 0
   
   push hl                     ; save num bytes remaining
   
   ; de'= void *src
   ; stack = L_record_num, flag(write mode), max num bytes, num bytes remaining
   
   ld hl,6
   add hl,sp                   ; hl = L_record_num *
   
   ld a,BLOCK_MSG_PIN_RECORD
   call l_jpix                 ; bring record into memory
   
   jr c, writ_error_2          ; if i/o error
   
   ; hl = & record->flags
   ; de = & record->data
   ; de'= void *src
   ; stack = L_record_num, flag(write mode), max num bytes, num bytes remaining
   
   push de
   
   exx
   
   pop hl                      ; hl = void *dst
   pop bc                      ; bc = num bytes remaining
   
   ex de,hl
   ldir
   ex de,hl
   
   exx
   
   ; hl = & record->flags
   ; de'= void *src
   ; stack = L_record_num, flag(write mode), max num bytes
   
   ld a,BLOCK_MSG_UNPIN_DIRTY_RECORD_ACTIVE
   call l_jpix                 ; unpin dirty record and mark in use

writ_success_1:

   ; de'= void *src
   ; stack = L_record_num, flag(write mode), max num bytes
   
   exx
   ex de,hl                    ; hl'= void *src
   exx

putc_success_1:

   ; hl'= void *src
   ; stack = L_record_num, flag(write mode), max num bytes

   pop bc                      ; bc = max num bytes (successfully wrote them all)
   pop af                      ; f = flag(write mode)
   
   pop hl
   pop hl                      ; junk item
   
   push bc                     ; save num bytes written
   
   call writ_adjust_fp
   
   pop hl                      ; hl = num bytes written
   
   or a
   ret

writ_adjust_fp:

   ; bc = num bytes written
   ; hl'= void *src
   ;  f = flag(write mode)

   jr nz, writ_adjust_eof      ; if append mode
   
   ld a,BLOCK_MSG_FP
   call l_jpix                 ; hl = & file pointer
   
   ld e,l
   ld d,h                      ; de = & file pointer
   
   call l_long_add_mhl_bc      ; file pointer += bc
   
   ld a,BLOCK_MSG_EOF
   call l_jpix                 ; hl = & eof pointer
   
   call l_long_cmpu_mde_mhl    ; flags(*de - *hl)
   
   ret c                       ; if file pointer < eof pointer
   ret z                       ; if file pointer == eof pointer
   
   ; de = & file pointer
   ; hl = & eof pointer

   ex de,hl
   
   ldi
   ldi
   ldi
   ldi                         ; eof pointer = file pointer
   
   ret

writ_adjust_eof:

   ; bc = num bytes written
   ; hl'= void *src

   ld a,BLOCK_MSG_EOF
   call l_jpix                 ; hl = & eof pointer

   jp l_long_add_mhl_bc        ; eof pointer += bc

writ_success_0:
putc_success_0:

   ; hl'= void *src
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining
   
   pop af
   pop af                      ; junk items
   
   jr putc_success_1

writ_error_0:
putc_error_0:

   ; hl'= void *src
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining, flag(num bytes remaining - bytes in record), bytes in record, offset

   ld hl,18
   add hl,sp
   ld sp,hl                    ; clear stack
   
   jp error_zc                 ; zero chars written, carry set for error

writ_error_2:

   ; de'= void *src
   ; stack = L_record_num, flag(write mode), max num bytes, num bytes remaining

   exx
   ex de,hl
   exx
   
   jr putc_error_2

writ_error_1:

   ; hl'= num bytes remaining (must add record size for failed write)
   ; bc'= record size
   ; hl = void *src
   ; stack = L_record_num, flag(write mode), max num bytes

   add hl,bc
   push hl

putc_error_2:

   ; hl'= void *src
   ; stack = L_record_num, flag(write mode), max num bytes, num bytes remaining

   pop bc                      ; bc = num bytes remaining
   pop hl                      ; hl = max num bytes
   
   or a
   sbc hl,bc
   
   ld c,l
   ld b,h                      ; bc = num bytes written
   
   pop af                      ; f = flag(write mode)
   
   pop de                      ; junk item
   ex (sp),hl                  ; save num bytes written
   
   call writ_adjust_fp
   
   pop hl                      ; hl = num bytes written
   
   scf                         ; indicate error
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

putc:

   ; output a single char multiple times on the stream
   ;
   ;  A = STDIO_MSG_PUTC
   ;  E'= char
   ; BC'= number > 0
   ; HL = number > 0
   ;
   ; return:
   ;
   ; HL = number of bytes successfully output
   ; carry set if error

   push hl
   push hl                     ; create L_record_num

   dec l
   jr nz, putc_buf

   ld a,h
   or a
   jr nz, putc_buf

;; common case: output one char ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

putc_ch:

   ld a,BLOCK_MSG_WRITE_MODE
   call l_jpix                 ; nz if append mode
   
   push af                     ; save flag(write mode)
   
   ld a,BLOCK_MSG_FP_TO_MAX
   jr z, putc_ch_mode_0        ; if write mode
   ld a,BLOCK_MSG_EOF_TO_MAX

putc_ch_mode_0:

   call l_jpix                 ; determine if at max file size
   jp c, error_zc - 3          ; if at max file size
   
   ; e' = char
   ; stack = L_record_num, flag(write mode)
   
   pop af                      ; f = flag(write mode)
   push af                     ; save flag(write mode)

   ld a,BLOCK_MSG_FP_RECORD
   jr z, putc_ch_mode_1        ; if write mode
   ld a,BLOCK_MSG_EOF_RECORD

putc_ch_mode_1:

   ld hl,2
   add hl,sp
   ex de,hl                    ; de = L_record_num *
   
   call l_jpix                 ; get info on first record to write

   ; de = L_record_num *
   ; hl = offset into record
   ; bc = num bytes remaining in record
   ; e' = char
   ; stack = L_record_num, flag(write mode)
   
   push bc                     ; save bytes remaining in record
   push hl                     ; save record offset
   
   ex de,hl                    ; hl = L_record_num *
   
   ld a,BLOCK_MSG_PIN_RECORD
   call l_jpix                 ; bring record into memory
   
   pop bc                      ; bc = record offset
   jp c, error_zc - 4          ; if i/o error
      
   ; hl = & record->flags
   ; de = & record->data
   ; bc = record offset
   ; e' = char
   ; stack = L_record_num, flag(write mode), bytes remaining in record
   
   ex de,hl                    ; de = & record->flags
   
   add hl,bc                   ; hl = void *dst

   exx
   ld a,e                      ; a = char
   exx
   
   ld (hl),a                   ; putchar

   pop hl                      ; hl = bytes remaining in record
   
   dec hl
   ld a,h
   or l                        ; bytes remaining in record now zero ?
   
   ex de,hl                    ; hl = & record->flags
   
   ; hl = & record->flags
   ; stack = L_record_num, flag(write mode)
   
   ld a,BLOCK_MSG_UNPIN_DIRTY_RECORD_ACTIVE
   jr nz, putc_ch_unpin        ; if more space in record
   ld a,BLOCK_MSG_UNPIN_DIRTY_RECORD

putc_ch_unpin:

   call l_jpix                 ; unpin record
   
   pop af
   
   ; f = flag(write mode)
   ; stack = L_record_num
   
   ld a,BLOCK_MSG_FP
   jr z, putc_ch_mode_2        ; if write mode
   ld a,BLOCK_MSG_EOF

putc_ch_mode_2:

   call l_jpix                 ; hl = & file pointer
   
   call l_long_inc_mhl         ; file pointer++
   
   pop bc
   pop bc                      ; junk item
   
   ld hl,1                     ; one char output
   
   or a
   ret

;; general case: output more than one char ;;;;;;;;;;;;;;;;;;;;

putc_buf:

   inc l

   ld a,BLOCK_MSG_WRITE_MODE
   call l_jpix                 ; nz if append mode
   
   push af                     ; save flag(write mode)
   push hl                     ; save max num bytes
      
   ld a,BLOCK_MSG_FP_TO_MAX
   jr z, putc_mode_0           ; if write mode
   ld a,BLOCK_MSG_EOF_TO_MAX

putc_mode_0:

   call l_jpix                 ; determine max bytes that can be written
   jp c, error_zc - 4          ; if file already at max size

   ; dehl = max num bytes that can be written
   ;   bc = record size
   ;    e'= memset value
   ; stack = L_record_num, flag(write mode), max num bytes
   
   pop af
   push bc
   push af
   pop bc                      ; bc = max num bytes
   
   call l_minu_bc_dehl         ; hl = min(bc = max_num_bytes, dehl = max_write)
   
   pop bc                      ; bc = record size
   pop af                      ; f = flag(write mode)
   
   push af                     ; save flag(write mode)
   push hl                     ; save max num bytes
   push bc                     ; save record size
   push hl                     ; save num bytes remaining
   
   ;  e'= void *src
   ;  f = flag(write mode)
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining
   
   ld a,BLOCK_MSG_FP_RECORD
   jr z, putc_mode_1           ; if write mode
   ld a,BLOCK_MSG_EOF_RECORD

putc_mode_1:

   ld hl,8
   add hl,sp
   ex de,hl                    ; de = L_record_num *
   
   call l_jpix                 ; get info on first record to write
   jr z, putc_loop_0           ; if write pointer is at start of record

   ; write pointer is in middle of record

   ; de = L_record_num *
   ; hl = offset into record
   ; bc = bytes remaining in record
   ;  e'= memset value
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining
   ; carry reset

   ex (sp),hl                  ; hl = num bytes remaining
   
   sbc hl,bc                   ; num bytes remaining -= bytes in record
   jr nc, putc_entire_record   ; if num bytes remaining >= bytes in record
   add hl,bc
   
   ld c,l
   ld b,h                      ; bc = num bytes to write into record

putc_entire_record:

   ex (sp),hl                  ; hl = offset into record
   
   push af                     ; save flag(num bytes remaining - bytes in record)
   push bc                     ; save num bytes in record
   push hl                     ; save offset
   
   ; de = L_record_num *
   ;  e'= memset value
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining, flag(num bytes remaining - bytes in record), bytes in record, offset
   
   ex de,hl                    ; hl = L_record_num *
   
   ld a,BLOCK_MSG_PIN_RECORD
   call l_jpix                 ; bring record into memory
   
   jr c, putc_error_0          ; if i/o error
   
   ; hl = & record->flags
   ; de = & record->data
   ;  e'= memset value
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining, flag(num bytes remaining - bytes in record), bytes in record, offset

   push de
   
   exx

   pop hl                      ; hl = & record->data
   pop bc                      ; bc = record offset
   
   add hl,bc                   ; hl = void *dst
   
   pop bc                      ; bc = num bytes in record

   push de                     ; save memset value
   call asm_memset
   pop de                      ; restore memset value
   
   exx
   
   pop af                      ; f = flag(num bytes remaining - bytes in record)
   
   ; hl = & record->flags
   ;  f = flag(num bytes remaining - bytes in record)
   ;  e'= memset value
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining
   
   ld a,BLOCK_MSG_UNPIN_DIRTY_RECORD
   jr nc, putc_initial_record  ; if num bytes remaining >= bytes in record
   ld a,BLOCK_MSG_UNPIN_DIRTY_RECORD_ACTIVE

putc_initial_record:

   push af                     ; save flag(num bytes remaining - bytes in record)
   call l_jpix                 ; unpin dirty record
   pop af                      ; f = flag(num bytes remaining - bytes in record)
   
   ;  f = flag(num bytes remaining - bytes in record)
   ;  e'= memset value
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining

   jr c, putc_success_0        ; if num bytes remaining < bytes in record
   jr z, putc_success_0        ; if num bytes remaining = bytes in record

   ld hl,8
   add hl,sp                   ; hl = L_record_num *
   
   call l_long_inc_mhl         ; L_record_num++

putc_loop_0:

   ;  e'= memset value
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining

   pop hl                      ; hl = num bytes remaining
   pop bc                      ; bc = record size

putc_loop_1:

   ; e' = memset value
   ; hl = num bytes remaining
   ; bc = record size
   ; stack = L_record_num, flag(write mode), max num bytes
   
   or a
   sbc hl,bc                   ; num bytes remaining -= record size
   
   jr c, putc_partial          ; if num bytes remaining < record size
   
   exx
   
   push de                     ; save memset value
   push de                     ; save memset value
   
   ld hl,8
   add hl,sp                   ; hl = L_record_num *
   
   ld a,BLOCK_MSG_CREATE_RECORD
   call l_jpix                 ; create record in memory
   
   ex (sp),hl
   ex de,hl
   
   exx
   
   ; hl = num bytes remaining
   ; bc = record size
   ;  e'= memset value
   ; hl'= & record->data
   ; stack = L_record_num, flag(write mode), max num bytes, memset value, & record->flags
   
   jr c, putc_error_1          ; i/o error (bytes remaining needs adjustment)
   
   push bc                     ; save record size
   
   exx
   
   pop bc                      ; bc = record size
   
   call asm_memset
   
   pop hl                      ; hl = & record->flags
   
   ld a,BLOCK_MSG_UNPIN_DIRTY_RECORD
   call l_jpix                 ; unpin record
   
   ld hl,6
   add hl,sp                   ; hl = L_record_num *
   
   call l_long_inc_mhl         ; L_record_num++
   
   pop de                      ; e = memset value
   
   exx
   
   jr putc_loop_1

putc_partial:

   add hl,bc
   jr z, putc_success_1        ; if num bytes remaining == 0

   push hl

   ; e' = memset value
   ; stack = L_record_num, flag(write mode), max num bytes, num bytes remaining
   
   ld hl,6
   add hl,sp                   ; hl = L_record_num *
   
   ld a,BLOCK_MSG_PIN_RECORD
   call l_jpix                 ; bring record into memory
   
   jr c, putc_error_2          ; if i/o error
   
   ; hl = & record->flags
   ; de = & record->data
   ; e' = memset value
   ; stack = L_record_num, flag(write mode), max num bytes, num bytes remaining

   push de
   
   exx
   
   pop hl                      ; hl = & record->data
   pop bc                      ; bc = num bytes remaining
   
   call asm_memset

   exx
   
   ; hl = & block->flags
   ; stack = L_record_num, flag(write mode), max num bytes
   
   ld a,BLOCK_MSG_UNPIN_DIRTY_RECORD_ACTIVE
   call l_jpix
   
   jr putc_success_1

putc_error_1:

   ; hl = num bytes remaining (need to add record size)
   ; bc = record size
   ; stack = L_record_num, flag(write mode), max num bytes, memset value, & record->flags

   add hl,bc                   ; attempt to transfer last record failed
   
   pop af                      ; junk item
   ex (sp),hl

   jr putc_error_2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

