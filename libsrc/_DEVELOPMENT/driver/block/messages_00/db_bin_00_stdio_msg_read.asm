
PUBLIC db_bin_00_stdio_msg_read

EXTERN FILE_MSG_FP_TO_EOF, FILE_FP_RECORD_INFO, FILE_MSG_POINTER_FP
EXTERN BUFFER_MSG_PIN_RECORD, BUFFER_MSG_UNPIN_RECORD, BUFFER_MSG_UNPIN_ACTIVE_RECORD, BUFFER_MSG_READ_RECORD

EXTERN l_jpix, error_mc, error_zc, l_minu_bc_dehl, l_long_inc_mhl, l_long_add_mhl_bc

db_bin_00_stdio_msg_read:

   ; read stream characters into a buffer
   ;
   ; enter:
   ;
   ;   IX = FILE *
   ;    A = STDIO_MSG_READ
   ;   DE'= void *buffer = byte destination
   ;   BC'= max_length > 0
   ;   HL = max_length > 0
   ;
   ; return:
   ;
   ;   BC = number of bytes successfully read
   ;   DE'= void *buffer_ptr = address of byte following last written
   ;   carry set on error (HL=0) or eof (HL=-1)

   push hl
   push hl                     ; create space for L_record_num
   
   push hl                     ; save max_len
   
   ld a,FILE_MSG_FP_TO_EOF
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
   
   ld a,FILE_FP_RECORD_INFO
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
   
   ld a,BUFFER_MSG_PIN_RECORD
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
   
   ld a,BUFFER_MSG_UNPIN_ACTIVE_RECORD
   jr c, read_initial_record   ; if num bytes remaining < bytes in record
   ld a,BUFFER_MSG_UNPIN_RECORD

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
   
   ld a,BUFFER_MSG_READ_RECORD
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
   
   ld a,BUFFER_MSG_PIN_RECORD
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
   
   ld a,BUFFER_MSG_UNPIN_ACTIVE_RECORD
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
   
   ld a,FILE_MSG_POINTER_FP
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
