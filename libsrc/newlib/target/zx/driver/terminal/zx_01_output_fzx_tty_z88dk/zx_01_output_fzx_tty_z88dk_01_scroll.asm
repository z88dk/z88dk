
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_fzx_tty_z88dk_01_scroll

EXTERN l_offset_ix_de, __fzx_puts_single_spacing
EXTERN console_01_output_fzx_proc_line_spacing
EXTERN console_01_output_fzx_proc_putchar_scroll

zx_01_output_fzx_tty_z88dk_01_scroll:

   ; scroll window upward one row

   ld hl,30
   call l_offset_ix_de
   
   push hl
   ex (sp),ix                  ; struct fzx_state *

   call __fzx_puts_single_spacing
   call console_01_output_fzx_proc_line_spacing

   ; hl = num pixels to scroll vertically
   
   pop ix                      ; ix = FDSTRUCT.JP *

   jp console_01_output_fzx_proc_putchar_scroll
