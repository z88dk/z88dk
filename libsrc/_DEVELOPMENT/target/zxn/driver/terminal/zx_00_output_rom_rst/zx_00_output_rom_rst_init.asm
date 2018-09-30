SECTION code_crt_init

PUBLIC zx_00_output_rom_rst_init

zx_00_output_rom_rst_init:

   ld a,2                      ; upper screen
   call 5633                   ; open channel
