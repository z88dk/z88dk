SECTION code_env

PUBLIC asm_env_copy_file

EXTERN error_mc

asm_env_copy_file:

   ; Copy bytes from file in to file out.
   ;
   ; enter : de = buf
   ;         bc = bufsz > 0
   ;         hl = num bytes
   ;
   ;         disk io block for file in, the one being read
   ;
   ;         ix+12 = jp read (read bc>0 bytes to address hl, carry if error)
   ;
   ;         disk io block for file out, the one being written
   ;
   ;         iy+15 = jp write (write bc>0 bytes from address hl, carry if error)
   ;
   ; exit  : if successful
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         if failed on disk read
   ;
   ;             a = 0, hl = -1
   ;             carry set
   ;
   ;         if failed on disk write
   ;
   ;             a = 1, hl = -1
   ;             carry set
   ;
   ; unchanged : de, ix, iy

copy_loop:

   ld a,h
   or l
   ret z                       ; if done
   
   ; determine number of bytes to transfer in this step
   
   ; de = buf
   ; bc = bufsz > 0
   ; hl = num bytes to copy
   
   sbc hl,bc
   jr nc, copy_it
   add hl,bc
   
   ld c,l
   ld b,h                      ; bc = num remaining bytes to copy
   
   ld hl,0                     ; no more bytes left
   
copy_it:

   push hl
   push de
   push bc
   push iy
   push de
   push bc
   
   ; de = buf
   ; bc = num bytes

   ex de,hl
   call l_jpix_12              ; read bc bytes into buffer
   
   pop bc                      ; bc = num bytes to copy
   pop hl                      ; hl = buf
   ex (sp),ix                  ; ix = disk io block for write
   
   jr c, disk_error_rd

   call l_jpix_15              ; write bc bytes from buffer
   
   jr c, disk_error_wr
   
   ex (sp),ix                  ; ix = disk io block for read
   pop iy                      ; iy = disk io block for write
   
   pop bc
   pop de
   pop hl
   
   jr copy_loop

disk_error_rd:

   xor a
   jr disk_error

disk_error_wr:

   ld a,1

disk_error:

   ex (sp),ix
   pop iy
   
   pop bc
   pop de
   pop bc
   
   jp error_mc
