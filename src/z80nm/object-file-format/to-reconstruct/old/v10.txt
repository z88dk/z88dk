z80asm File formats (v10)
=========================

This document describes the object and libary formats used by *z80asm*
versions *2.6.x*. 

The object and library files are stored in binary form as a set of 
contiguous objects, i.e. each section follows the previous one without 
any end-markers. 

The files start with a signature that includes a version number and is 
verified by the assembler before trying to parse the file.

A set of file pointers at the start of the object file point to the 
start of each section existing the in the file, or contain *0xFFFFFFFF* 
(-1) if that section does not exist.

The following object types exist in the file:

* *char* :	one byte containing an ASCII character;

* *byte* :	one 8-bit value;

* *word* :	one 16-bit value, stored in low byte - high byte order 
  (Little endian format - Z80/Intel notation);

* *long* :	one 32-bit value, stored in low byte - high byte order, 
containing the file position where the corresponding 
section starts; the value is *0xFFFFFFFF* (-1) if the section 
does not exist;

* *string*:	one byte containing the string length followed by the 
characters of the string;

* *lstring*: one word containing the string length followed by the 
characters of the string.


Object file format
------------------

The format of the object file is as follows:

    |Addr | Type   | Object                                                 |  
    +-----+--------+--------------------------------------------------------+  
    |   0 | char[8]| 'Z80RMF10' (file signature and version)                |  
    |   8 | long   | File pointer to *Module Name*, always the last section |  
    |  12 | long   | File pointer to *Expressions*, may be -1               |  
    |  16 | long   | File pointer to *Module Names*, may be -1              |  
    |  20 | long   | File pointer to *External Names*, may be -1            |  
    |  24 | long   | File pointer to *Machine Code*, may be -1              |  
    |  28 |        | *Expressions*                                          |  
    |     |        | ...                                                    |  
    |     |        | *Module Names*                                         |  
    |     |        | ...                                                    |  
    |     |        | *External Names*                                       |  
    |     |        | ...                                                    |  
    |     |        | *Module Name*                                          |  
    |     |        | *Machine Code*                                         |  


* *Expressions* : contains a set of expressions up to an end marker (*type* = 0). Each expression has the following
format:

  * *type* (char) : defines the resulting evaluation type range:   
     *  0  : end marker 
     * 'U' : 8-bit integer (0 to 255)  
     * 'S' : 8-bit signed integer (-128 to 127)  
     * 'C' : 16-bit integer (-32768 to 65535)  
     * 'L' : 32-bit signed integer     
     * '=' : computed name at link time

  * *sourcefile* (lstring) : source file name where expression was defined,
  to be used in error messages. May be an empty string, signalling that
  the previous *sourcefile* of the previous expression should be used.

  * *line_number* (long) : line number in source file where 
  expression was defined, to be used in error messages.

  * *section* (string) : source file section name where expression 
  was defined. 

  * *ASMPC* (word) : defines the relative module code address of the 
  start of the assembly instruction to be used as *ASMPC* during
  expression evaluation.

  * *patchptr* (word) : defines the relative module code patch pointer to 
  store the result of evaluating the expression.

  * *target_name* (string) : contains the name of the symbol that receives
  the result of evaluating the expression, only used for '=' type expressions,
  empty string for the other types.
	
  * *expression* (lstring) : contains the expression text as parsed from the 
  source file, in the standard C-like expression syntax.

* *Module Names* : contains a set of names defined in this module 
up to the next existing section. Each name has the following format:

  * *scope* (char) : defines the scope of the name:
     *  0  : end marker
     * 'L' is local,  
     * 'G' is global,  

  * *type (char) : defines whether it is a: 
     * 'A' relocatable address,   
     * 'C' a constant.
     * '=' a symbol computed at link time, the corresponding
     expression is in the *Expressions* section.

  * *section* (string) : source file section name where name 
  was defined. 

  * *value* (long) : contains the absolute value for a constant, or the
  relative address to the start of the code block for a relocatable
  address.
	
  * *name* (string) : contains the name.

  * *filename* (string) : contains the source file name where the symbol was defined.

  * *line_nr* (long) : contains the source line number where the symbols was defined.


* *External Names* : contains a set of external names referred 
  by this module up to the next existing section. Each name has the 
  following format:
  
	* *name* (string) : contains the name.   

* *Module Name* (string) : contains the module name.

* *Machine Code* : contains the binary code of the module with the 
following format:

  * *length* (long) : defines the total code lenght, and contains -1
  to signal the end.

  * *section* (string) : source file section name. 
 
  * *ORG Address* (long) : contains the user defined ORG address for 
  the start of this section, -1 for no ORG address was defined, or 
  -2 to split section to a different binary file. 
  If multiple setions are given with an ORG address each, the 
  assembler generates one binary file for each section with a defined 
  ORG, followed by all sections without one.

  * *ALIGN* (long) : defines the address alignment of this section, -1 if not defined. The previous section is padded to align the start address of this section.

  * *code* (byte[length]) : contains the binary code.


Library file format
-------------------

The library file format is a sequense of object files with additional
structures.

    |Addr | Type   | Object                                                 |
    +-----+--------+--------------------------------------------------------+
    |   0 | char[8]| 'Z80LMF10' (file signature and version)                |
    |   8 | word   | *Object File Block*                                    |
    |     |        | ...                                                    |

* *Object File Block* : contains the following format: 

  * *next* (long) : contains the file pointer of the next object file 
  in the library, or *-1* if this object file is the last in the library.

  * *length* (long) : contains the length of this object file, 
  or *0* if this object files has been marked "deleted" and will not be used.


History
-------

* version *01* : original z80asm version
* version *02* : allow expressions to use standard C operators instead of the original (legacy) z80asm
specific syntax. 
* version *03* : include the address of the start of the assembly instruction in the object file, so 
that expressions with ASMPC are correctly computed at link time; remove type 'X' symbols (global library), 
no longer used.
* version *04* : include the source file location of expressions in order to give meaningful link-time 
error messages.
* version *05* : include source code sections.
* version *06* : incomplete implementation, fixed in version *07*
* version *07* : include *DEFC* symbols that are defined as an expression using other symbols and are computed 
at link time, after all addresses are allocated.
* version *08* : include a user defined ORG address per section.
* version *09* : include the file and line number where each symbol was defined.
* version *10* : allow a section alignment to be defined.

