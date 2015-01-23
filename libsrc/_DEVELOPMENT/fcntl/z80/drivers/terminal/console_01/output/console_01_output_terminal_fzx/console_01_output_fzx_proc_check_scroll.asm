
SECTION code_fcntl

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
   
   scf
   sbc hl,de                   ; y - paper.height - 1
   
   ret c                       ; if y <= paper.height
   
   inc hl                      ; hl = required scroll amount in pixels
   ret
