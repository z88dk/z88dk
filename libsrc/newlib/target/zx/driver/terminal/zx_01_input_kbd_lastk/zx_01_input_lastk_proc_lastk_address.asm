
SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC zx_01_input_lastk_proc_lastk_address
PUBLIC zx_01_input_lastk_proc_lastk

EXTERN l_offset_ix_de

zx_01_input_lastk_proc_lastk_address:

   ; return & LASTK
   
   ld hl,25
   jp l_offset_ix_de           ; hl = & LASTK

zx_01_input_lastk_proc_lastk:

   ; return LASTK
   
   ; exit : hl = LASTK
   ;        z flag set if hl = 0
   
   call zx_01_input_lastk_proc_lastk_address   ; hl = & LASTK

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a

   or h
   ret
