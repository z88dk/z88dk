Z88DK Z80 Module Assembler Change Log
=====================================

2016
----

- 2016-07-23

  Command line parser based on re2c. Parse option --help. Read file list
  from argv[], recursively expanding '@'-lists. Handle any type of newline
  (LF, CR, CR-LF) in '@'-lists. Accept empty lines and comment lines 
  started by '#' or ';' in '@'-lists. Tests.

- 2016-07-19

  main() skeleton with help options. Message file with all output text.
  Test copyright and usage options.
