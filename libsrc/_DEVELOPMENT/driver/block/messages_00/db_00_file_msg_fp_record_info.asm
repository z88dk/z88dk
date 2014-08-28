
PUBLIC db_00_file_msg_fp_record_info
PUBLIC _0_db_00_file_msg_fp_record_info

EXTERN BLOCKIO_MSG_RECORD_SIZE
EXTERN db_00_file_msg_pointer_fp

EXTERN l_jpix, l_long_load_mhl, l_andc_hl_bc

db_00_file_msg_fp_record_info:

   ; return information about the record containing file pointer
   ;
   ; enter:
   ;
   ;   ix = FILE *
   ;   de = long *record_number
   ;
   ; return:
   ;
   ;   de = long *record_number (filled in)
   ;   hl = offset into record
   ;   bc = number bytes remaining in record
   ;   z flag set if hl=offset == 0
   ;   carry reset
   
   call db_00_file_msg_pointer_fp  ; hl = & file pointer

_0_db_00_file_msg_fp_record_info:

   ld a,BLOCKIO_MSG_RECORD_SIZE
   call l_jpix                     ; bc = record size, power of two
   
   dec bc                          ; bc = record size - 1 = mask
   
   push de                         ; save long *record_number
   push de                         ; save long *record_number
   
   call l_long_load_mhl            ; dehl = file pointer
   
   pop af                          ; af = long *record_number
   push hl                         ; save file_pointer.L
   push af                         ; save long *record_number
   
   call l_andc_hl_bc               ; hl = record_number.L = fp.L & ~(record size - 1)
   
   ex de,hl
   ex (sp),hl
   
   ; hl = long *record_number
   ; de = record_number.L
   ; bc = record_size - 1
   ; stack = long *record_number, file_pointer.L, file_pointer.H
   
   ld (hl),e                       ; write record number
   inc hl
   ld (hl),d
   inc hl
   
   pop de                          ; de = file_pointer.H = record_number.H
   
   ld (hl),e
   inc hl
   ld (hl),d
   
   pop hl                          ; hl = file_pointer.L
   
   ld a,l
   and c
   ld e,a
   
   ld a,h
   and b
   ld d,a                          ; de = offset_record = file_pointer.L & (record size - 1)
   
   inc bc
   
   ; de = offset into record
   ; bc = record size
   ; stack = long *record_number
   ; carry reset
   
   ld l,c
   ld h,b                          ; hl = record size
   
   sbc hl,de                       ; hl = record size - offset into record
   
   ld c,l
   ld b,h                          ; bc = number bytes remaining in record
   
   ex de,hl                        ; hl = offset into record
   
   pop de                          ; de = long *record_number
   
   ld a,h
   or l                            ; z flag set if hl=offset == 0
   
   ret
