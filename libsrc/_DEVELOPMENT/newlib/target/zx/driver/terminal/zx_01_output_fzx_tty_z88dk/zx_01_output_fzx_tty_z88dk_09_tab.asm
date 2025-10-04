
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_fzx_tty_z88dk_09_tab

EXTERN l_offset_ix_de, console_01_output_fzx_proc_linefeed
EXTERN console_01_output_fzx_proc_putchar_scroll

zx_01_output_fzx_tty_z88dk_09_tab:

   ; tab to next multiple of eight column
   
   ; should we be printing spaces to the next tab ??
   
   ld a,(ix+36)
   or a
   jr nz, linefeed
   
   ld a,(ix+35)                ; a = x coord
   
   and $c0
   add a,$40
   
   jr c, linefeed
   
   ld (ix+35),a                ; store new x coord
   
   cp (ix+41)
   ret c                       ; if x < width
   
   ld a,(ix+42)
   or a
   ret nz

linefeed:

   ; move to next line
   
   ld hl,30
   call l_offset_ix_de
   
   push hl
   ex (sp),ix                  ; ix = struct fzx_state *
   
   call console_01_output_fzx_proc_linefeed
   
   pop ix
   ret c                       ; if scroll unnecessary
   
   jp console_01_output_fzx_proc_putchar_scroll
