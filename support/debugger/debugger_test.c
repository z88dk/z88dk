
#include "debugger.h"
#include "cmds.h"

/** TODO: We ideally want this to be the symbol ._dbg_registers in
    test_crt0.asm but that seems to give wrong result
    compiler bug???
*/
static unsigned char* kludge_dbg_registers=0x3A;

unsigned char* debugger_get_registers()
{
  return kludge_dbg_registers;
}

static int cmd_debug_as_int=CMD_DBG;


extern unsigned* dbg_registers;


void debugger_set_break(unsigned char* addr)
{
  /** rst 10h for this platform (test) */
  (*addr)=0xd7;
}

int debugger_num_break_bytes()
{
  return 1;  /** So we know how many bytes to save */
}

int debugger_exchange_str(void *ptr, int len)
{
#asm
  pop bc ; save return ;
  pop de ; len ;
  pop hl ; pointer to string ;

  push hl ; balance stack
  push de ;


  ld a,(_cmd_debug_as_int) ; CMD_DBG ;

  rst 8 ;

  /** Result string in ptr and len in return value, HL */
  ld h,0 ;
  ld l,e ;
    
  push bc ;

#endasm
}

