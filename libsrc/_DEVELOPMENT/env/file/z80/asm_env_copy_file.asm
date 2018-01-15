SECTION code_env

PUBLIC asm_env_copy_file

EXTERN error_mc
EXTERN l_jpix_12, l_jpix_15

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
   ; uses   : af, bc, hl

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

   ; de = buf
   ; bc = num bytes to copy
   ; hl = num bytes left

   ex de,hl
   call l_jpix_12              ; read bc bytes into buffer hl
   
   ; hl = buf
   ; bc = num bytes to copy
   ; de = num bytes left

   push iy
   ex (sp),ix                  ; ix = disk io block for write
   
   ; stack = disk io block for read
   
   jr c, disk_error_rd

   call l_jpix_15              ; write bc bytes from buffer hl
   
   jr c, disk_error_wr
   
   pop ix                      ; ix = disk io block for read
   
   ex de,hl
   jr copy_loop

disk_error_rd:

   xor a
   jr disk_error

disk_error_wr:

   ld a,1

disk_error:

   pop ix
   
   ex de,hl
   jp error_mc
