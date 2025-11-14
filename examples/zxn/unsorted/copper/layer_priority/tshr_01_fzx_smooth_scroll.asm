SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC tshr_01_output_fzx_smooth_scroll

EXTERN OTERM_MSG_SCROLL

EXTERN tshr_01_output_fzx
EXTERN l_offset_ix_de, asm0_tshr_scroll_wc_up_pix

tshr_01_output_fzx_smooth_scroll:

   cp OTERM_MSG_SCROLL
   jp nz, tshr_01_output_fzx   ; forward to base driver
   
   ; smooth scroll

   ;   enter  :   c = number of rows to scroll
   ;   can use:  af, bc, de, hl
   ;
   ;   Scroll the window upward 'C' character rows.
   
   ; DON'T LET THIS BITE YOU!!
   ; In a clib=sdcc_iy compile ix & iy have been swapped in the library
   ; so library references to ix are actually to iy, including in function names

   ld hl,16
   call l_offset_ix_de         ; hl = window.rect *
   
   push hl
   
   ld a,c
   add a,a
   add a,a
   add a,a
   ld b,a                      ; b = number of vertical pixels to scroll
   
IF __SDCC_IY
   ex (sp),iy
ELSE
   ex (sp),ix                  ; ix = window.rect *
ENDIF

scroll_loop:

   push bc
   
   ld e,1                      ; scroll one pixel
   ld l,0                      ; fill byte
   
   call asm0_tshr_scroll_wc_up_pix
   
   pop bc
   djnz scroll_loop
   
IF __SDCC_IY
   pop iy
ELSE
   pop ix
ENDIF

   ret
