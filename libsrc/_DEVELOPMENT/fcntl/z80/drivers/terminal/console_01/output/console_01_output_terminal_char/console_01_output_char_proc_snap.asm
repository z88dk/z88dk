
SECTION seg_code_fcntl

PUBLIC console_01_output_char_proc_snap

console_01_output_char_proc_snap:

   ; snap coordinates to window
   ;
   ; enter : e = x coord
   ;         d = y coord
   ;
   ; exit  : e = fixed x coord
   ;         d = fixed y xoord
   ;
   ; uses  : af, de
   
check_x:

   ld a,e
   cp (ix+17)
   
   jr nc, fix_x                ; if x >= rect.width

check_y:

   ld a,d
   cp (ix+19)
   
   ret c                       ; if y < rect.height

fix_y:

   add a,a
   jr nc, y_pos

y_neg:

   xor a
   ld d,a                      ; set y = 0

   ret

y_pos:

   ld d,(ix+19)
   dec d                       ; set y = rect.height - 1
   
   ret

fix_x:

   add a,a
   jr nc, x_pos

x_neg:

   ld e,(ix+17)
   
   dec e                       ; x = rect.width - 1
   dec d                       ; y--
   
   call check_y
   
   ret c                       ; if y was ok
   ret nz                      ; if y was positive corrected
   
   ld de,0                     ; top left corner
   ret

x_pos:

   ld e,0                      ; x = 0
   inc d                       ; y++

   call check_y
   
   ret c                       ; if y was ok
   ret z                       ; if y was negative corrected

   ld e,(ix+17)
   dec e                       ; e = rect.with - 1
   
   ret
