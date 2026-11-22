
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_fzx_proc_check_scroll

console_01_output_fzx_proc_check_scroll:

   ; enter : ix = struct fzx_state *
   ;         hl = y coord
   ;
   ; exit  : scroll required
   ;
   ;            hl = scroll amount in pixels
   ;            carry reset
   ;
   ;         scroll not required
   ;
   ;            carry set
   ;
   ; uses  : f, de, hl

   ld e,(ix+15)
   ld d,(ix+16)                ; de = paper.height
   
   or a
   sbc hl,de                   ; y - paper.height
   
   ret c                       ; if y < paper.height
   
   inc hl                      ; hl = required scroll amount in pixels
   ret
