      ; command line parsing for esxdos dot commands

      ; hl = pointer to args or 0 if no args

      ld a,h
      or l
      jr nz, cmdline_present

   cmdline_missing:

      include "../crt_cmdline_empty.inc"
      jr cmdline_end

   cmdline_present:

      ; hl is typically pointing directly to a basic line,
      ; so for end marker you should check for $0D, ":" as well as 0.
      
      ld e,l
      ld d,h                   ; de = & command line
      
      ld bc,0
      
   cmdline_len:
      
      ld a,(hl)
      
      or a
      jr z, cmdline_len_end
      
      cp ':'
      jr z, cmdline_len_end
      
      cp 0x0d
      jr z, cmdline_len_end
      
      inc hl
      inc bc
      
      jr cmdline_len

   cmdline_len_end:
      
      ; copy command line words from basic program to stack

      EXTERN l_command_line_parse
      call   l_command_line_parse
      
      ; esxdos does not supply program name in command line
      ; so place empty string in argv[0] instead
      
      ; bc = int argc
      ; hl = char *argv[]
      ; de = & empty string
      ; bc'= num chars in redirector
      ; hl'= char *redirector
      
      push de                  ; empty string added to front of argv[]
      
      dec hl
      dec hl                   ; char *argv[] adjusted to include empty string at index 0
      
      inc c                    ; argc++

   cmdline_end:

      ; hl = char **argv
      ; bc = int    argc
