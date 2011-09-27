/*
     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
                ZZZZZ      888           888  0000         0000
              ZZZZZ        88888888888888888  0000         0000
            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM

Copyright (C) Gunther Strube, InterLogic 1993-99
*/

/*
 * Z80 Module Assembler       - C version, by Gunther Strube - InterLogic 1992-1999
 *
 * converted from QL SuperBASIC version 0.956. Initially ported to Lattice C then C68 on QDOS.
 */

/*
 * Main Source file - definition of global identifiers etc.
 * 
 * 26.08.91, V0.000: 
 * Work on Draft version of GetIdentifier started.
 *
 * 28.08.91, V0.001: 
 * GetIdentifier tested - working.
 *
 * 31.08.91, V0.002: 
 * Work on Pass 1 - Z80 commands.
 *
 * 13.09.91, V0.003: 
 * Getidentifier() renamed to Getident().
 * Main body of Z80pass1() finished - all parsing of Z80 instructions and assembler directives implemented. CheckCondition()
 * implemented. CheckRegister8() implemented. CheckRegister16() implemented. functions now split up into modules:
 * 
 * 25.02.92, V0.004: 
 * Algortihms for symbol storing & lookup, using hash table and linked lists:
 * 
 * 03.03.92, V0.005: 
 * Algorithms for converting ASCII symbols into integer values implemented:
 * Symbol storing algorithms now changed to infinite numbers of symbol allocation (as long as memory are available). Also,
 * it is now allowed to have identifiers with dynamic length's though only a maximum of 254 chars (maximum length of
 * line minus a dot to indicate a label definition).
 * 
 * 01.05.92, V0.006: 
 * Hashtable array, 'SymPtrIndex', and relative jump address label array, 'JR_address', now created at
 * runtime. This saves 12K of program space!
 * Reporterror() implemented in 'Parseline_c' - all return error in various functions are now standardised.
 * 
 * 17.09.92, V0.007: 
 * Ported to C68 - the Public Domain C compiler for QL. Improved with ANSI C prototyping and function
 * parameters. Minor bugs detected.
 * 
 * 10.02.92, V0.008: 
 * Parsing of numerical expressions rewritten. New operators implemented: /, %, * Expressions now stored
 * in linked lists as postfix expressions. Getident() -> Getsym() (also modified to return an enumerated symbol)
 * Numexpression() removed. 28.10.92  V0.009 Many changes and implementations of Z80 instructions. More Source file
 * modules.
 * 
 * 05.11.92, V0.010: 
 * Parsing & code generation of all Z80 instructions. Command line argument implemented. Simple listing
 * file implemented.
 * 
 * 08.11.92, V0.011: 
 * Removal of parsing information after pass 2. Parsing error system improved.
 * 
 * 09.11.92, V0.12: 
 * List file layout finished (header, datestamp, etc.)
 * 
 * 15.11.92, V0.13: 
 * INCLUDE directive implemented. Improvement on general error handling.
 * 
 * 23.11.92, V0.14: 
 * Sorted symbol table output in listing file - output'ed only if no errors ocurred. The assembler no
 * longer distinguishes upper and lower case identifiers. The source can now be written any mixture of upper and lower
 * case letters.
 * 
 * 26.11.92, V0.15: 
 * Listfile Page Number References included in symbol table output. BINARY directive implemented. Phase 1
 * of Z80 Cross Assembler Completed.
 * 
 * 16.03.93, V0.15b: 
 * Bug in Expression evaluation algorithms fixed: Allocation/Deallocation of memory in ParseNumExpr() and
 * EvalExpr() rewritten.
 * 
 * 24.03.93, V0.15c: 
 * PrsIdent() rewritten. Uses standard ANSI C bsearch function to locate Z80 identifier. (array of
 * structure containing the identifier and a pointer to a function)
 * 
 * 01.04.93, V0.16: 
 * Allocation & search of symbols restructured into AVL tree.
 * 
 * 13.05.93, V0.18b: 
 * Modular assembly processing implemented.
 * 
 * 14.05.93, V0.19: 
 * Date stamp control feature implemented.
 * 
 * 21.05.93, V0.19b: 
 * List file & object file removed if errors encountered in module Error file feature implemented.
 * 
 * 09.06.93, V0.19c: 
 * Bugs in page reference algorithms fixed. Phase 2 of Z80 Cross Assembler Completed.
 * 
 * 22.06.93, V0.19d: 
 * ANSI source ported to Borland C++ V3.1 on the IBM PC. Many small inconsistencies removed to be 100%
 * compilable by Borland C++. ParseIdent() rewritten. A few bugs fixed in Z80asm_c module. 'relocfile' option flag
 * removed - object file is always created. -v option at command line (verbose assembly) implemented.
 * 
 * 24.06.93, V0.19e: 
 * -r option at command line (define ORG) implemented. 27.06.93 file pointer read/write in object
 * standardised to low byte -> high byte order (V0.19d stored internal representation of long) this means that object
 * files are now portable to all computer platforms using the Z80 Module Assembler (Z88, QL, PC, ?)
 * 
 * 06.07.93, V0.19f: 
 * Bug in TestAsmFile() fixed. The assembler now only reports 'file open error' if both source and object
 * file wasn't available.
 * 
 * 20.07.93, V0.19g: 
 * AVLTREE insertion optimized.
 * 
 * 17.08.93, V0.19h: 
 * Symbol values are stored as signed long integers in object file. Symbol table (in listing file) also
 * altered to allow long integer display. Memory now no longer released after completed assembly in QDOS version.
 * 
 * 31.08.93, V0.21: 
 * Bug in mapfile routine fixed: Trying to release the mapfile even if was empty. Symbols, constants and
 * expressions are now all treated as base type long. Name definitions are now also stored as long in the object file.
 * DEFL implemented to store 32bit signed integers in low byte - high byte sequense. FPP implemented to identify a
 * better interface to the OZ floating point package. Map file writes 'None.' if no map item are present.
 * 
 * 02.09.93, V0.22: 
 * Binary operators AND, OR, XOR implemeneted in expression evalution. Constants are now globally
 * accessible, if defined with XDEF. Bug in Z80asm module code loading fixed: There was no check that code was
 * generated at all. Since the fptr_modcode was 0, the file pointer were set to the beginning of the file, and the
 * first two bytes were used as the length id (the 'Z80RMF' !) A check is now made to ensure that machine is available.
 * Assembler function implemented, 'ASMPC' which returns the current assembler PC: This is can be useful during code
 * generation.
 * 
 * 06.09.93, V0.23: 
 * LSTON, LSTOFF directives implemented.
 * 
 * 06.12.93, V0.24: 
 * All expressions may now be specified as logical expressions returning 1 for TRUE and 0 for FALSE.
 * logical operators are: =, <>, <, >, <= and >= .
 * Conditional assembly implemented with #if, #else and #endif. Unlimited nesting of #if expressions allowed.
 * pass1 algorithm optimized and rewritten to facilitate conditional assembly.
 * 
 * 12.12.93, V0.25: 
 * Expression evaluation improved with logical NOT (using '!' in expressions) Some module pointer
 * algorithms rewritten.
 * 
 * 16.12.93, V0.26: 
 * Pass1 parsing now directly read by fgetc() instead of fgets(), since fgets() couldn't handle control
 * characters (tabs, etc.) in the assembler source file. Algorithms to parse expressions have been slightly changed,
 * since the underlying parsing have changed. The object file format has been changed in the expression section: Infix
 * expressions are now terminated with '\0' in stead of length identifier. This is necessary, since expression parsing
 * is also executed directly on the object file (expression). The listing file gets the complete line as usual
 * (directly from the source file).
 * Assembly optimised: Expressions are NOT evaluated if they contain address labels and no listing output is active (no
 * listing file or temporarily switched off).
 * 
 * 18.12.93, V0.27: 
 * Line parsing bugs corrected in both normal and conditional assembly. EOL flag implemented to control
 * linefeed during recursive parsing.
 * 
 * 31.01.94, V0.28: 
 * JP, CALL functions improved with better algorithm interface Bit manipulation functions improved (lack
 * of syntax check). '#IF', '#ELSE', '#ENDIF' changed to 'IF', 'ELSE', 'ENDIF' Listing file now also contains source
 * file line numbers The module code size is now displayed during verbose assembly.
 * 08.02.94  Expression parsing optimised: Factor(), Term(), Expression() & Condition() - redundant pointer reference
 * level removed during parsing. Bug in ParseNumExpr() fixed: pfixhdr wasn't released if there wasn't room for
 * infixexpr area.
 * 14.02.94  Bug in BINARY() fixed: binfile wasn't closed after read process.
 * 17.02.94  Bug in EvalLogExpr() fixed: if syntax error occurred in a logical expression, a random integer were
 * returned, in stead of 0.
 * 18.02.94  Bugs in PushItem() and PopItem() fixed: Logic control were missing to handle a stack with no elements on
 * it!
 *
 * 19.02.94, V0.29: 
 * A help prompt is displayed if no arguments are defined.
 * 
 * 23.02.94, V0.30: 
 * BINARY facility changed to used file name parameter as in INCLUDE. Bug in INCLUDE function fixed:
 * Did'nt set the EOL flag if end of line encoun- tered during reading of file name.
 * Expression evaluation altered: Expression are now evaluated completely, even though a single identifier is not known
 * (making the expression NOT EVALUABLE). The result of the evaluation is returned (but probably incorrect). This
 * allowes specification of several -D symbols in an conditional assembly line, e.g.  "if MSDOS | UNIX", to be
 * evaluated to TRUE if just one symbol is defined (the expression is however detected as UNEVALUABLE).
 * -D symbols now saved separately in new STATIC tree structure, and copied into local symbols during assembly of each
 * module. This fixes the problem of -D used on multi-module-assembly (otherwise the -D symbol is removed after the
 * assembly of the first module). STATICs are first removed after the linking process.
 * The -D symbol is however stored into the object file if it were used in an expression (e.g. in an IF expression). It
 * should not, as it is of a different type of symbol than a CONSTANT or an ADDRESS. This must be fixed in a future
 * version.
 * On execution of the assembler, a unique -D symbol is created to identify the particular platform the assembler is
 * running in:  'QDOS'  : Z80asm running on the QL and compatibles (ANSI C).
 *              'MSDOS' : Z80asm running on the IBM PC and compatibles (ANSI C).
 *              'LINUX' : Z80asm running on the LINUX/UNIX operating system (ANSI C).
 *              'Z88'   : Z80asm running on the Cambridge Z88 portable computer (handwritten machine code application).
 * 
 * 25.02.94  New typ implemented for -D symbols. New keyword implemented: 'define' to execute the equivalent of -D on
 * the command line.
 * 
 * 04.03.94, V0.31: 
 * -lib and -xlib implemented. Major rewrite of module linking routines. New keyword implemented: 'LIB'
 * to declare external library routine (included during linking). New global variable for CURRENTMODULE (previously
 * used as the indirect pointers of the modulehdr structure. The global variable saves time and is more code efficient.
 * 
 * 08.04.94, V0.32: 
 * New keyword for library type declaration implemented: XLIB, define library routine address (also
 * declared as global). The type is stored as 'X' in the names declaration in object files.
 * The new type was needed to distinuish between names during output of a -g list, hence included library routine names
 * may not be in the list.
 * 13.03.94  Bug in ParseLine() fixed: If a label was encountered during non-interpretation of a source line, a syntax
 * error was reported. The should just have been skipped.
 * 
 * 14.03.94, V0.33: 
 * Global definition file algorithm rewritten. The global definitions are now written continously after
 * completion of each module and NOT after linking. This eliminates the problem of not getting a def. file, if linking
 * couldn't be performed due to assembly errors.
 * 
 * 25.03.94, V0.34: 
 * DEFVARS implemented to define variables and records in a more structured design. The old 'DS' renamed
 * to 'DEFS' (define storage). The following DS (define space) are available: ds.b (byte size) ds.w (word size) ds.p
 * (pointer size) ds.l (long word size)
 * 26.03.94  DEFGROUP implemented to allow ENUM - alike symbols to be created just as easy as in C.
 * 06.04.94, V0.35: '-lib' changed to '-i', '-xlib' changed to '-x'. DEFINE algorithm didn't check if a symbol was already
 * defined.
 * 19.04.94  New window interface for QDOS / C68 version. config_h now defines the platform defintions (line feed size,
 * etc.)
 *
 * 25.04.94, V0.36: 
 * enum flag introduced in expression record to identify whether the expression has been stored to
 * the object file or not. Label declarations are now always touched due to problems of forward referencing problems in
 * expressions and identifiers in object files. This had been implemented in an earlier version, but had apparently
 * been removed by accident - The drawback of this is that label declarations, that aren't used in a source file will
 * become redundant in the object file. However, this is rare and will not create more than 5% of additional size in
 * object files in worst case situations.
 * 
 * 03.05.94, V0.37: 
 * Bug fixes in exprprsr_c, z80pass_c and modlink_c: All expression evaluation did a type casting of the
 * evaluated expression before the legal range were examined. This caused illegal ranges to be allowed in expressions.
 * 13.05.94  Bug fixed in LinkModules(): Z80header were null-terminated beyond local array. This made created peculiar
 * crashes occasionally on the QL version. MSDOS-version now running perfectly. Releasing of module & global data
 * structures are now only released by Z80asm running on platforms other than the QL - the allocated data is released
 * automatically when the job is killed.
 * 
 * 15.05.94, V0.38: 
 * Z80RMF level 01 implemented: Infix expression string now also length prefixed. GetModuleSize() improved
 * to check if it is a proper 'Z80RMF01' file that is to be read. Library files now also checked to have the 'Z80LMF01'
 * header.
 * 01.06.94  "DS" has been removed from identifier function call table. DEFVARS() now executes a normal strcmp() to
 * check for the correct "DS" directive.
 * 
 * 07.06.94, V0.39: 
 * Symbol file implemented. This will be created if the user wants the symbol table, but not the listing
 * file. _def, _map and _sym (and in listing file) uses new tabulated space algorithm (to save file storage).
 * 15.06.94  Internal improvement of module & library linking routines.
 *  
 * 17.06.94, V0.40: 
 * DEFVARS origin parameter may now be an expression (with no forward references) Default tabulator
 * distance now set to 8, column width is 4 times t. distance.
 *
 * 16.09.94, V0.41: 
 * Size specifier in DEFVARS variable offset may now be specified as an expression. However, the
 * expression may not contain forward referenced symbols. The algorithm has been re-structurized.
 * 
 * 22.09.94, V0.42: 
 * INCLUDE directive improved: Environment variable "Z80_OZFILES" introduced to read a fixed path of all
 * Z88 OZ definition files. This makes it easier to port source code with regard to fetch the standard OZ files. Each
 * platform just presets the variable and the assembler will automatically expand the system file '#file' with a
 * leading path followed by 'file'.
 * O_BINARY mode included in open() function when creating a library file. This ensures compatibility with MSDOS files.
 * Bug in Z80asm_c fixed: -x option created library file as text file (no binary open mode). The file is now created as a
 * binary file. NB: This is only relevant for MSDOS (and LINUX/UNIX?).
 * 27.09.94  LSTON/LSTOFF bug fixed: During INCLUDE file management, the old line of the previous file was written to
 * the list file when beginning/continuing on a new file. The listing file line is now initially cleared before pass 1
 * is executed.
 *
 * 19.10.94, V0.45: 
 * New option added: -R. This Feature generates relocatable code, i.e. relocates it self before being
 * executed. A standard machine code routine is put in front of the code together wth a relocation table.
 * The generated machine code is self modifying and may only be executed in RAM (e.g.in Z88 BBC BASIC).
 * The help page has been slighty improved.
 *
 * 31.10.94: Relocator & relocation table structure changed. Each entry in the table is now defined as offsets from each
 * relocation address. Since relocation addresses mostly are less than 255 bytes apart, this design saves a lot of space
 * on the relocation header, about 50%. The idea was suggested by Erling Jacobsen who noticed the principle in the C68
 * C compiler.
 * The relocation table contents allowes negative offsets. This may be useful since not all relocation code patch pointers
 * is historically organised. However, if two adjacent patch pointers are more than 32K apart it will not create the
 * proper offset pointer (due to an integer overflow).
 * 01.11.94: -i option opened the library file with unnecessary mode flags. If the specified library file didn't exist, it
 * was automatically created. The routine then made the wrong assumptions of that file.
 *
 * 17.11.94, V0.46: 
 * Expression parsing & evaluation added with ^ (power) operator. Binary XOR now uses the ':' symbol.
 * The power operator is useful it may be necessary to convert bit numbers 0-7 into an 8bit value using: 2^bitnumber.
 *
 * 18.11.94, V0.47: 
 * The following undocumented Z80 instructions have been implemented:
 * SLL instruction (Shift Logical Left). 8Bit LD r,IXh/IXl/IYl/IYh & LD IXh/IXl/IYl/IYh,r . INC/DEC IXl,IXh,IYl,IYh.
 * AND, ADD, ADC, SUB, SBC, CP, OR & XOR IXl/IXh/IYl/IYh .
 *
 * 30.11.94, V0.48: 
 * Library filenames may now be omitted which is interpreted as the standard library filename.
 * Since the standard library is used most of the time it is considerably easier to just specify '-i' or '-x' without
 * a filename.
 * The default library filename is defined in an environment variable 'Z80_STDLIB'.
 *
 * 01.01.95, V0.49: 
 * New feature in expressions implemented: Leading '#' in expressions defines a constant expression.
 * This is necessary when calculating relocatable address offsets and avoiding it to be interpreted as a relocatable
 * address to be manipulated during a -R option.
 * '#ASMPC' changed to 'ASMPC'
 * 05.01.95: Bug in -D option fixed: first character of identifier wasn't converted to upper case.
 * 03.03.95: Evaluation stack algorithms optimized.
 * 12.03.95: Patching on 16bit addresses optimized.
 *
 * 14.03.95, V0.50: 
 * Bug in Condition() fixed: logical NOT algorithm were misplaced. Moved to Factor().
 * 17.03.95: ORG is now only defined from keyboard at the beginning of the linking process, if no ORG
 * were defined during assembly of the first module.
 *
 * 21.04.95, V0.52: 
 * New avltree algorithms used in Z80asm. Many symbol-related routines changed to new interface.
 * Forward-referenced symbols now finally deleted, in stead of being marked SYMREMOVED. FindSymbol() now faster.
 *
 * 24.04.95, V0.53: 
 * 'ASMPC' standard identifier now implemented as part of the global symbol tables. This means that
 * that it is equal to all other created symbols. Both pass1(), pass2() and the linking process use the assembler PC.
 * The explicit code in DefineSymbol() and Factor() are finally removed, which has speeded up the algorithms.
 *
 * 25.04.95, V0.54: 
 * standard avltree move() and copy() now used in stead of CopyTree() and ReorderSymbol().
 *
 * 27.04.95, V0.55: 
 * -c option added, which split the compiled machine code into 16K blocks. Each file is identified
 * with a '_bnx' extension where 'x' defines the blocks 0 (the first) to 3 (total of 64K).
 *
 * 03.05.95, V0.56: 
 * DEFGROUP improved; evaluable expressions may now be used (previously only constants).
 *
 * 03.06.95, V0.57: 
 * compile option messages displayed before processing (response to selected command line option).
 * EvalExpr() slightly optimised: Identifier logic in expressions made faster.
 *
 * 22.06.95, V0.58: 
 * Parsing logic improved, with a bugfix in IF conditional expressions: A comment after a conditional
 * expression wasn't skipped. Getsym() has now been improved to skip the rest of a line of a comment ; is found.
 * This has also lead to various improvements in the parsing logic code of the assembler.
 * Total of lines assembled is now also displayed after successfull compilation.
 *
 * 28.06.95, V0.59: 
 * New Relocator routine implemented. Mapfile now adds relocation header offset to address labels if
 * relocation option, -R, was selected).
 *
 * 13.07.95, V0.60: 
 * Syntax parsing improvement in DEFB, DEFW and DEFL directives.
 *
 * 14.11.95, V1.00: 
 * Last changes before final release:
 * CheckRegister8(): 'F' now returns 6.
 * Syntax check on register mnemonics improved.
 * XLIB improved to issue implicit MODULE definition.
 *
 * 20.02.96, V1.01 (gbs): 
 * Minor bug fixed for signed 8bit operands:
 * If say, LD (IX+$FF),A were used, the assembler gave an error. It shouldn't. The operand is now properly 
 * sign-converted.
 *
 * 20.06.98, V1.0.3 (gbs): 
 * Minor bug fixes in EOF handling in prsline.c, exprprsr.c and asmdrctv.c
 * prsident.c : SUB, AND, OR, XOR and CP instructions improved with "instr [A,]" syntax (allowing to specify "A,"
 * explicitly and thereby avoiding mis-interpretations).
 *
 * 03.09.98, V1.0.4 (gbs): 
 * New command line option added: Use self defined source file extension, -e<ext> in stead of ".asm".
 * DEFVARS functionality extended with -1 which remembers last used offset.
 *
 * 07.03.99, V1.0.5 (dom): 
 * Program terminates with 1 if an error occurs, otherwise 0 (implemented by Dominic Morris djm@jb.man.ac.uk).
 * Minor changes to remove silly warnings.
 *
 * 11.04.99, V1.0.6 (gbs):
 * C sources modified slighly a few lines to eliminate -Wall compiler warnings when using GNU C compiler 
 * on Linux (now truly ANSI C conformant). All sources now reformatted according to GNU C programming style. 
 * New option added: -o<filename> which allowes a different binary outfilename than otherwise based on 
 * project filename.
 *
 * 16.04.99, V1.0.7 (gbs):
 * Assembler parses text files of arbitrary line feed standards; CR, LF or CRLF (OS independant text file parsing).
 * Command line symbol option to identify project files, #, has been changed to @ because # is regarded 
 * as comment line identifier in UNIX shell environments - the result of this means that the file name is 
 * discarded by the command line environment, when trying to compile a z80asm project.
 * Default -v option changed to -nv (verbose mode disabled by default).
 *
 * 30.04.99, V1.0.8 (gbs):
 * Error messages now extended with display of module name, if possible (request by Dominic Morris)
 * Basic file I/O error reported in new error message function to display proper error message.
 *
 * 02.05.99, V1.0.9 (gbs):
 * Directives XDEF, XREF, XLIB and LIB can now be defined arbitrarily in the asm source (before or after
 * the actual symbols names in question). Request by Dominic Morris of SmallC fame.
 * "LINUX" OS ID now changed to generic "UNIX" in compilation, since there's no Linux specifics in the
 * sources. Further, all UNIX's can successfully compile and execute z80asm.
 * Recursive include of same or mutual files now error trapped (new FindFile() function and changes to
 * IncludeFile() function).
 *
 * 04.05.99, V1.0.10 (gbs):
 * Bug fixes related to reading filenames from source files (filenames should not be case converted
 * because some filing systems look at filenames explicitely - with no case independency).
 * During create library, object offset now only displayed in verbose mode. 
 * Filenames may now be specified with .asm at command line (stripped again internally). This is
 * useful since some OS's have true command line expansion, now allowing "z80asm *.asm" to get
 * all assembler source files pre-assembled.
 *
 * 30.05.99, V1.0.11 (gbs):
 * Binary() rewritten due to misbehaving functionality on MSDOS platform.
 * (reported by Keith Rickard, keithrickard@compuserve.com).
 * CreateLib() rewritten to replace the open() low level file I/O with high level
 * fopen() and fread() calls.
 *
 * 06.06.99, V1.0.12 (gbs):
 * MAXCODESIZE define moved to "config.h" where it also is defined for specific platforms.
 * For MSDOS the value is 65532 due to max heap size allocation per malloc() call.
 * (MSDOS BorlandC limitation reported by Dennis Gröning <dennisgr@algonet.se>)
 *
 * DEFB, DEFW, DEFL & DEFM now implemented with proper MAXCODESIZE checking.
 * ReportError() now displays to stderr the actual MAXCODESIZE limit if it has been reached.
 *
 * 30.09.99, V1.0.13 (gbs)
 * CALL_PKG hard coded macro implemented for Garry Lancaster's Package system.
 *
 * 03.10.99, V1.0.13 (gbs)
 * Slight change to CALL_PKG(): 0 (zero) is allowed as parameter.
 *
 * 26.01.2000, V1.0.14 (gbs)
 * Expression range validation removed from 8bit unsigned (redundant) data storage.
 *
 * 28.01.2000, V1.0.15 (dom)
 * Fixed ParseIdent routine (was searching for IF,ELSE,ENDIF at one
 * position below there true place in the table) - this zapped
 * the HALT instruction and caused a Syntax Error report
 *
 * Added the -M flag the change output files to .o from .obj
 *
 * 30.1.2000, V1.0.16 (gbs)
 * Dominic's -M option extended with argument, so that it may be possible
 * to define an arbitrary object file extension (max 3 chars), e.g.
 * -Mo to define .o extension.
 *
 * 26.02.2000, V1.0.17 (djm)
 * Added -C flag to output C source line number instead of asm line number
 * (if defined)
 * Added directive LINE <expr> to enable this
 * Allowed labels to start with an '_'
 *
 * 23.04.2000 (djm) [No version increment]
 * Added auto ENDIAN config if using GNU C
 *
 * 20.01.2001 <x1cygnus@xcalc.org> [No version increment]
 * Added hardcoded macro instruction Invoke and command line ti83plus 
 * to make assembler ti83/83plus compatible 
 *
 * 28.02.2001 V1.0.18 (djm)
 * Added UNDEFINE command to allow undefinition of a DEFINE
 *
 * 21.03.2001 v1.0.19 (djm)
 * Allowed labels to end in ':' and forsake the initial '.'
 *
 * 27.06.2001 [no version increment] (djm)
 * defs now takes a second parameter indicating what the filler byte should be, if not
 * set the defaults to 0
 *
 * 17.01.2001 [no version increment] (djm)
 * 20h is now accepted as a synonym for $20
 *
 * 18.01.2001 [no version increment] (djm)
 * Dropped the requirement for add, sbc, and adc to specify "a," for 8 bit
 * operations
 * Added d and b specifiers for constants - decimal and binary
 * C-style 0x prefix for hex digits is permitted
 *
 * 22.04.2002 [no version increment] (Stefano)
 * IX <-> IY swap option added (-IXIY)
 */
