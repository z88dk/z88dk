
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC sms_01_output_terminal_tty_z88dk_23_atr

sms_01_output_terminal_tty_z88dk_23_atr:

   ; atr dx,dy
   
   ; de = parameters *
   
   ex de,hl
   
   ld d,(hl)                   ; d = dy
   dec d
   inc hl
   ld e,(hl)                   ; e = dx
   dec e
   
   ex de,hl

   ld e,(ix+14)                ; e = x
   ld d,(ix+15)                ; d = y
   
   ld a,l
   add a,e
   ld e,a                      ; e = x + dx
   
   ld a,h
   add a,d
   ld d,a                      ; d = y + dy

   ld (ix+14),e                ; store x coord
   ld (ix+15),d                ; store y coord
   
   ret
