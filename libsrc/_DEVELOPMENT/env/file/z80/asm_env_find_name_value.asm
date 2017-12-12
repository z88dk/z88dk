SECTION code_env

PUBLIC asm_env_find_name_value

EXTERN error_znc, error_mnc, l_inc_sp, l_jpix, l_jpiy
EXTERN asm_env_name_sm, asm_env_value_sm, asm_env_value_sm_count
EXTERN asm_im2_push_registers, asm_im2_pop_registers

asm_env_find_name_value:

   ; Using the provided buffer space, load a window of the environment
   ; file and locate the name-value pair in the file
   ;
   ; enter : ix = char *name (valid)
   ;         de = &buffer
   ;         bc = bufsize
   ;         hl = env file size (max 65535)
   ;         iy = function that loads bc bytes to address hl, carry set if error
   ;
   ; exit  : if name-value found
   ;
   ;           hl = file offset to start of line
   ;           bc = file offset to start of value string
   ;           de = length of value string
   ;
   ;           carry set
   ;
   ;        if not found in env file
   ;
   ;           hl = 0
   ;           carry reset
   ;
   ;        if disk error
   ;
   ;           hl = -1
   ;           carry reset
   ;
   ; uses  : all

   push ix
   
   exx
   
   pop de                      ; de' = char *name
   
   ld bc,0
   push bc                     ; stack = offset of current line
   
   dec bc                      ; bc = offset of current char (-1 now)
   
   exx

   ld ix,asm_env_name_sm       ; start of name state machine
   
locate_name:

   ; fill buffer from disk

   ; hl = remaining bytes in file
   ; bc = bufsize
   ; de = &buffer
   
   ; stack = offset of current line

   ld a,h
   or l
   jp z, error_znc - 1         ; if end of file
   
   xor a
   sbc hl,bc

   jr nc, load_it

   add hl,bc

   ld c,l
   ld b,h                      ; bc = num remaining bytes in file
   
   ld hl,0                     ; no more bytes left

load_it:

   pop af
   push de                     ; &buffer
   push bc                     ; buflen
   push hl                     ; remaining
   push af                     ; offset of current line
   
   ; de = &buffer
   ; bc = num bytes
   
   call asm_im2_push_registers  ; save all registers
   
   ex de,hl                    ; hl = &buffer
   call l_jpiy                 ; fill buffer from disk
   
   jr c, disk_error
   
   call asm_im2_pop_registers  ; pop all registers
   
   ex de,hl

locate_name_loop:

   ; hl = &buffer
   ; bc = len remaining
   
   ld a,(hl)
   
   exx
   
   call l_jpix                 ; name match state machine
   inc bc                      ; increase file offset to current char
   
   exx
   
   jr c, locate_value          ; if name is matched
   
   ld a,'\n'
   cpi                         ; hl++, bc--

   jr nz, loop
   
   ; start of a new line
   
   inc sp
   inc sp
   
   exx
   
   inc bc
   push bc                     ; record offset of start of line
   dec bc
   
   exx

loop:

   jp pe, locate_name_loop
   
   pop af
   pop hl
   pop bc
   pop de
   push af
   
   jr locate_name              ; re-load buffer

disk_error:
   
   call asm_im2_pop_registers  ; pop all registers
   
   ; stack = &buffer, buflen, remaining, offset of current line
   
   pop hl
   jp error_mnc - 3

locate_value:

   ; name found, examine value
   
   ; hl = &buffer
   ; bc = len remaining
   
   ; bc' = offset of start of value string
   ; stack = &buffer, buflen, remaining, offset of current line
   
   ld a,(hl)
   
   exx
   
   call asm_env_value_sm
   
   exx
   
   jr c, name_value_found
   
locate_value_loop:

   ; hl = &buffer
   ; bc = len remaining
   
   cpi                         ; hl++, bc--
   jp po, load_it_2

locate_value_loop_enter:

   ld a,(hl)
   
   exx
   
   call asm_env_value_sm_count
   
   exx
   
   jr nc, locate_value_loop

name_value_found:

   ; name-value pair found
   
   ; bc' = offset to start of value string
   ; de' = length of value string
   ; stack = &buffer, buflen, remaining, offset of current line
   
   exx
   
   pop hl
   
   scf
   jp l_inc_sp - 6

load_it_2:

   ; re-load buffer from disk
   
   pop af
   pop hl
   pop bc
   pop de
   push af
   
   ; hl = remaining
   ; bc = buflen
   ; de = &buffer
   ; stack = offset of current line
   
   ld a,h
   or l
   jr z, name_value_found_2

   xor a
   sbc hl,bc

   jr nc, load_it_3

   add hl,bc

   ld c,l
   ld b,h                      ; bc = num remaining bytes in file
   
   ld hl,0                     ; no more bytes left

load_it_3:

   pop af
   push de                     ; &buffer
   push bc                     ; buflen
   push hl                     ; remaining
   push af                     ; offset of current line
   
   ; de = &buffer
   ; bc = num bytes
   
   call asm_im2_push_registers  ; save all registers
   
   ex de,hl                    ; hl = &buffer
   call l_jpiy                 ; fill buffer from disk
   
   jr c, disk_error
   
   call asm_im2_pop_registers  ; pop all registers
   
   ex de,hl
   jr locate_value_loop_enter

name_value_found_2:

   ; name-value pair found
   
   ; bc' = offset to start of value string
   ; de' = length of value string
   ; stack = offset of current line
   
   exx
   
   pop hl
   
   scf
   ret
