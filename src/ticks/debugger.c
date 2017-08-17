

#include "ticks.h"


void debugger()
{
    // Called everytime round the instruction loop    
    disassemble(mem + pc, pc);
}
