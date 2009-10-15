
#ifndef DEBUGTARGET__H
#define DEBUGTARGET__H

/** Reset the target */
void debug_target_reset();


/**
 *  Tell the target to load a specific binary file for execution
 */
void debug_target_load_file(const char* binfile);

/** 
 *  Tell the target to terminate (halt?) nicely as soon as possible 
 */
void debug_target_quit_next();

/**
 *  Run until end or breakpoint encountered
 *  
 *  When a breakpoint is called (rst 08h or similar) the crt0 code should contact
 *  the debugger with a status code for the previous operation and then wait for
 *  another command from debugger.
 */
void debug_target_run();


/**
 *  Below instructions only need to be implemented on simulator!! 
 *  *** No need to implement on targets !!! ***
 *  Just define a dummy (preferably with an error message so we know they are not called by misstake)
 */


/**
 *
 * In simulator we use this to obtain the next breakpoint after stepping one instruction
 */
void debug_target_instr(int num_instr);

/**
 *  init and dump regs will transparently pass strings back and forth
 *  from command line of debug bin, we need not limit ourselves to
 *  only one special set of strings, just as long as the user of
 *  dbgbin uses the same format as the receiveing target.
 */
void debug_target_init_regs(const char* regstr);
void debug_target_dump_regs(char *buff, int maxlen);

#endif
