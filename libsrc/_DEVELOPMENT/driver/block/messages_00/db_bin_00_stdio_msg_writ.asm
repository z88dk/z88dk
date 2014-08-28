
PUBLIC db_bin_00_stdio_msg_writ
PUBLIC __db_bin_00_putc_success_1, __db_bin_00_putc_success_0, __db_bin_00_putc_error_0, __db_bin_00_putc_error_2

EXTERN FILE_MSG_WRITE_MODE, FILE_MSG_FP_TO_MAX, FILE_MSG_EOF_TO_MAX, FILE_MSG_FP_RECORD_INFO
EXTERN FILE_MSG_EOF_RECORD_INFO, FILE_MSG_POINTER_FP, FILE_MSG_POINTER_EOF

EXTERN BUFFER_MSG_PIN_RECORD, BUFFER_MSG_UNPIN_DIRTY_RECORD, BUFFER_MSG_UNPIN_DIRTY_ACTIVE_RECORD
EXTERN BUFFER_MSG_WRITE_RECORD

EXTERN l_jpix, error_zc, error_efbig_zc, l_minu_bc_dehl, l_long_inc_mhl, l_long_add_mhl_bc, l_long_cmpu_mde_mhl

db_bin_00_stdio_msg_writ:

   ; write buffer to stream
   ;
   ; enter:
   ;
   ;   IX = FILE *
   ;    A = STDIO_MSG_WRIT
   ;   HL = length > 0
   ;   BC'= length > 0
   ;   HL'= void *buffer = byte source
   ;
   ; return:
   ;
   ;   HL'= void *buffer + num bytes written
   ;   HL = number of bytes successfully output
   ;   carry set if error

   push hl
   push hl                     ; create L_record_num
   
   ld a,FILE_MSG_WRITE_MODE
   call l_jpix                 ; nz if append mode
   
   push af                     ; save flag(write mode)
   push hl                     ; save max num bytes
      
   ld a,FILE_MSG_FP_TO_MAX
   jr z, writ_mode_0           ; if write mode
   ld a,FILE_MSG_EOF_TO_MAX

writ_mode_0:

   call l_jpix                 ; determine max bytes that can be written
   jp c, error_efbig_zc - 4    ; if file already at max size

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
   
   ld a,FILE_MSG_FP_RECORD_INFO
   jr z, writ_mode_1           ; if write mode
   ld a,FILE_MSG_EOF_RECORD_INFO

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
   
   ld a,BUFFER_MSG_PIN_RECORD
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
   
   ld a,BUFFER_MSG_UNPIN_DIRTY_RECORD
   jr nc, writ_initial_record  ; if num bytes remaining >= bytes in record
   ld a,BUFFER_MSG_UNPIN_DIRTY_ACTIVE_RECORD

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
   
   ld a,BUFFER_MSG_WRITE_RECORD
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
   
   ld a,BUFFER_MSG_PIN_RECORD
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
   
   ld a,BUFFER_MSG_UNPIN_DIRTY_ACTIVE_RECORD
   call l_jpix                 ; unpin dirty record and mark in use

writ_success_1:

   ; de'= void *src
   ; stack = L_record_num, flag(write mode), max num bytes
   
   exx
   ex de,hl                    ; hl'= void *src
   exx

putc_success_1:
__db_bin_00_putc_success_1:

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
   
   ld a,FILE_MSG_POINTER_FP
   call l_jpix                 ; hl = & file pointer
   
   ld e,l
   ld d,h                      ; de = & file pointer
   
   call l_long_add_mhl_bc      ; file pointer += bc
   
   ld a,FILE_MSG_POINTER_EOF
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

   ld a,FILE_MSG_POINTER_EOF
   call l_jpix                 ; hl = & eof pointer

   jp l_long_add_mhl_bc        ; eof pointer += bc

writ_success_0:
putc_success_0:
__db_bin_00_putc_success_0:

   ; hl'= void *src
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining
   
   pop af
   pop af                      ; junk items
   
   jr putc_success_1

writ_error_0:
putc_error_0:
__db_bin_00_putc_error_0:

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
__db_bin_00_putc_error_2:

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
