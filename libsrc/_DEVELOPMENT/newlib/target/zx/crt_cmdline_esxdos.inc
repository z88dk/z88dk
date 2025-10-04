   ; complete esxdos command line implementation
   ;
   ;   0 = no command line
   ;   1 = on stack empty argc,argv
   ;   2 = unprocessed command line len,cmdline
   ;   3 = on stack argc,argv
   ;   4 = on stack unprocessed command line 0-terminated len,cmdline

   ; hl = command line
   
   IF __crt_enable_commandline = 1
   
      ; empty argc,argv
      
      include "../crt_cmdline_empty.inc"
      
      push hl   ; argv
      push bc   ; argc
   
   ENDIF

   IF __crt_enable_commandline = 2
   
      ; unprocessed esxdos command line

      push hl   ; command line
      push hl   ; length
      
      ld a,h
      or l
      
      jr z, end_command_line
      
      pop hl
      
      include "crt_cmdline_esxdos_len.inc"
   
      push bc   ; length

   end_command_line:

   ENDIF

   IF __crt_enable_commandline = 3
   
      ; parse into argc,argv
      
      IF __crt_enable_commandline_ex & 0x80

         include "crt_cmdline_esx_argv.inc"
      
      ELSE
      
         include "crt_cmdline_esxdos_argv.inc"
      
      ENDIF
      
      push hl   ; argv
      push bc   ; argc
   
   ENDIF

   IF __crt_enable_commandline >= 4
   
      ; copy unprocessed esxdos command line to stack

      ld a,h
      or l
      
      jr nz, yes_command_line
   
   no_command_line:
   
      push hl   ; command line
      push hl   ; length
      
      jr end_command_line
      
   yes_command_line:
   
      ld e,l
      ld d,h
      
      include "crt_cmdline_esxdos_len.inc"
      
      inc bc                   ; include terminator in length
      
      ld hl,128
      
      EXTERN l_minu_bc_hl
      call l_minu_bc_hl        ; place a cap on the length of the command line
      
      ld c,l
      ld b,h

      ld a,h
      or l
      
      jr z, no_command_line
      
      EXTERN l_neg_hl
      call l_neg_hl
      
      add hl,sp
      ld sp,hl
      
      push hl   ; command line
      push bc   ; length
      
      ex de,hl
      ldir
      
      dec de
      
      xor a
      ld (de),a                ; replace terminator with 0

   end_command_line:

   ENDIF
