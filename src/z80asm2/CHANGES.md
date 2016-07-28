Z88DK Z80 Module Assembler Change Log
=====================================

2016
----

- 2016-07-28

  Utility module and tests to read lines with any EOL terminator (CR, LF, CR-LF)
  and search for a file in a lookup-path.

- 2016-07-23

  Command line parser based on re2c. Parse option --help. Read file list
  from argv[], recursively expanding '@'-lists. Handle any type of newline
  (LF, CR, CR-LF) in '@'-lists. Accept empty lines and comment lines 
  started by '#' or ';' in '@'-lists. Tests.
  
  Add --verbose option and tests.

- 2016-07-19

  main() skeleton with help options. Message file with all output text.
  Test copyright and usage options.
