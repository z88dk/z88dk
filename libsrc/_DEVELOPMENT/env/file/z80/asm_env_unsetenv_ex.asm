; int unsetenv(char *envfile, char *name)





   ; enter : hl = char *name
   ;         de = buf
   ;         bc = bufsz > 0
   ;
	;         hl'= char *env_filename (0 to use system environment)
	;
   ;         disk io block for env file
	;
   ;         ix+15 = jp write (write bc>0 bytes from address hl, carry if error)
   ;         ix+12 = jp read (read bc>0 bytes to address hl, carry if error)
   ;         ix+ 9 = jp size (return dehl = file size, carry if error)
   ;         ix+ 6 = jp seek (seek to position bc, carry if error)
   ;         ix+ 3 = jp close (close file)
   ;         ix+ 0 = jp open (open file, hl = char *filename, CREAT|READ|WRITE|EXCL, carry if error)
   ;
	;         disk io block for tmp file
	;
	;         iy+18 = jp unlink (erase file, already closed, carry if error)
   ;         iy+15 = jp write (write bc>0 bytes from address hl, carry if error)
   ;         iy+12 = jp read (read bc>0 bytes to address hl, carry if error)
   ;         iy+ 9 = jp size (return dehl = file size, carry if error)
   ;         iy+ 6 = jp seek (seek to position bc, carry if error)
   ;         iy+ 3 = jp close (close file)
   ;         iy+ 0 = jp open (open file, hl = char *filename, CREAT|READ|WRITE|EXCL, carry if error)

   ; qualify name string
   
   push hl
   
   call asm_env_qualify_name
   
   pop hl
   jp nc, error_einval_zc      ; if name disqualified

   ; close env file on exit
   
   call setup_stack
   
   push af
   push hl
   
   ld a,(ix-1)
   or (ix-2)
   
   call nz, l_jpix_03          ; close env file
   
   pop hl
   pop af
   
   ret

setup_stack:

   ; set up stack

   push iy                     ; disk io block tmp file
   
   push bc                     ; bufsz
   push de                     ; buf
   push hl                     ; char *name
   
   exx

   ; open env file
   
   ld a,h
   or l
   jr nz, open_env_file
   
   ld hl,__ENV_FILE            ; use global env file

open_env_file:

   ld (ix-1),h
   ld (ix-2),l                 ; store env filename in disk io block
   
   call l_jpix_00              ; jp open
   jr nc, size_env_file        ; if open successful

   xor a                       ; ensure file is not closed at exit
   ld (ix-1),a
   ld (ix-2),a
   
open_failed:

   pop hl
   jp error_ebadf_zc - 3

size_env_file:

   ; gather size of env file
   
   call l_jpix_09              ; dehl = size of env file
   jr c, open_failed

   ld a,d
   or e
   jr nz, cap_env_size
   
   ld a,h
   and l
   inc a
   jr nz, env_find_name

cap_env_size:

   ld hl,0xfffe                ; hl = size of env file, max 65534

env_find_name:

   ; locate name in env file
   
   exx
   pop de                      ; de'= char *name
   exx
   
   pop de                      ; de = buf
   pop bc                      ; bc = bufsz
   
	push hl
	
   ; stack = disk io tmp, env filesize
   
   call asm_env_find_name_value
   jp nc, error_zc - 1         ; if not found

   ; hl = file offset to start of line
   ; iy = file offset to next line
	; ix = disk io env file
   ; stack = disk io tmp, env filesize


	; create tmpfile
	
	ld hl,0
	
	call asm_env_tmpnam
	jr c, ...notmpfile
	
;; must remove tmpfile
	
	call l_jpix_00              ; jp open
	jr c, ..notmpfile


   ; de = buf
	; bc = bufsz
	; hl = offset to start of line
	; ix = disk io env
	; iy = disk io tmp
	
	call asm_env_copy_file
	jr c, fail
	
	
	; bc = offset to next line
	
	call l_jpix_06              ; seek to next line
	jr c, fail
	
	; de = buf
	; bc = bufsz
	; hl = num bytes to end of env file
	; ix = disk io env
	; iy = disk io tmp
	
	call asm_env_copy_file
	jr c, fail
	
	; success
	
	
	







   ; destination buffer = 0 indicates return of value string length
   
   pop hl
   
   ld a,h
   or l
   jr nz, seek_env_file
   
   pop hl
   ex de,hl
   ret                         ; return length of value string

seek_env_file:

   push hl
   push de

   ; bc = file offset to start of value string
   ; stack = value_bufsz, value_buf, length of value string

   call l_jpix_06              ; seek to bc
   jp c, error_ebadf_zc - 3    ; if seek error
   
   ; compute min(value_bufsz,value_string_len)
   
   pop bc                      ; bc = len value string
   pop hl
   ex (sp),hl                  ; hl = value_bufsz
   
   call l_minu_bc_hl
   
   ld c,l
   ld b,h

   ; read value string into destination buffer
   
   pop hl
   
   ; hl = value_buf
   ; bc = num bytes to read from value string
   
   push hl
   push bc
   
   ld a,b
   or c
   
   call nz, l_jpix_12          ; read bc bytes into address hl
   
   pop bc
   pop hl
   
   jp c, error_ebadf_zc        ; if read error
   
   push hl
   
   add hl,bc
   
   xor a
   ld (hl),a                   ; zero terminate string
   
   pop hl                      ; hl = value_buf
   ret






















   ; qualify name string
	
	push hl
	
	call asm_env_qualify_name
	
	pop hl
	jp nc, error_einval_zc      ; if name disqualified
	
	; remove tmpfile
	
	call acquire_tmpfile
	
	push af
	push hl
	
	ld a,(ix-1)
	or (ix-2)
	
	call nz, l_jpix_18           ; jp unlink
	
	pop hl
	pop af
	
	ret

fail_tmpfile:

   call asm_im2_pop_registers
	jp error_ebadf_zc

   ; acquire tmpfile

acquire_tmpfile:

   call asm_im2_push_registers
	
	ld hl,0                     ; place tmp filename into static buffer
	call asm_env_tmpnam
	
	ld (ix-1),h
	ld (ix-2),l                 ; store filename in disk io block
	
	jr c, fail_tmpfile
	
	call l_jpix_00              ; jp open
	jr c, fail_tmpfile
	
	call asm_im2_pop_registers
	
	; close tmpfile
	
	call open_env_file
	
	push af
	push hl
	
	ld a,(ix-1)
	or (ix-2)
	
	call nz, l_jpix_03           ; jp close

	pop hl
	pop af
	
	ret

	; open env file
	
open_env_file:

   ; hl = char *name
   ; de = buf
   ; bc = bufsz > 0
	; hl'= char *env_filename (0 to use system environment)
	; ix = disk io block for tmpfile
	; iy = disk io block for envfile

	
	
	; open env file

   push bc
	push de
	push hl
	push iy
	
	ld a,h
	or l
	jr nz, open_env_file
	
	ld hl,__ENV_FILE            ; use global env file
	
open_env_file:

   ld (ix-1),h
	ld (ix-2),l                 ; store env file name in disk io block
	
	call l_jpix_00              ; jp open
	jr nc, 
	


