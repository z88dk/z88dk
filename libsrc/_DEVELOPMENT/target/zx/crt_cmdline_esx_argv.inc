      ; command line parsing for nextos-esx dot commands

      ; hl = pointer to args or 0 if no args

      ld a,h
      or l
      jr nz, cmdline_present

   cmdline_missing:

      include "../crt_cmdline_empty.inc"
      jr cmdline_end

   cmdline_present:

      ld e,l
      ld d,h

      include "crt_cmdline_esxdos_len.inc"
      
      ; copy command line words from basic program to stack

      IF __SDCC_IY && (__NEXTOS_DOT_COMMAND = 0) && (NEXTOS_VERSION = 0)
      
         di
      
      ENDIF

      EXTERN l_command_line_parse
      call   l_command_line_parse

      IF __SDCC_IY && (__NEXTOS_DOT_COMMAND = 0) && (NEXTOS_VERSION = 0)
      
         ld iy,__SYS_IY
         ei
      
      ENDIF

      ; nextos-esx supplies program name in argv[0]
      
      ; bc = int argc
      ; hl = char *argv[]
      ; de = & empty string
      ; bc'= num chars in redirector
      ; hl'= char *redirector

   cmdline_end:

      ; hl = char **argv
      ; bc = int    argc
