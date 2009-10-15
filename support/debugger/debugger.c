
/** Only for debugging of debugger ;-) */
#include <stdio.h>

#include "debugger.h"
#include "cmds.h"



/** Protocol like this:
    Query (from host)
 *  <LEN> <CMD> <Byte> <Byte> ... <Bytes>  
 *
    Reply (from target)
 *  <LEN> <STATUS> <Byte> <Byte> ... <Bytes>  

 * STATUS = 0 if all went well
  
 */

/** Put errors here as they are introduced :-) */
#define CMD_OK 0
/** If we have wrong length from register_set (i.e. not ==22) */
#define CMD_ERROR_REGISTER_LEN 1
/** Package not received correctly */
#define CMD_ERROR_PACKAGE 2
#define CMD_ERROR_UNKNOWN_COMMAND 3


/** The <reserved=0> byte is intended for possible use with > 64K mem targets */
/** N>=1 */

#define CMD_RUN 0
#define CMD_SET_BREAK 1
#define CMD_REGISTER_SET 2
#define CMD_REGISTER_GET 3
#define CMD_MODIFY 4
#define CMD_READ 5

void printhex1(char hexch)
{
  if (hexch>9)
    {
      printf("%c", hexch + 'A'-10);
    }
  else
    {
      printf("%c", hexch + '0');
    }
}

void printhex(unsigned char* str)
{
  int i;
  for (i=0;i<str[0];i++)
    {
      printhex1(str[i]/16);
      printhex1(str[i]%16);
    }

  printf("\n");
  
}


void debugger()
{
  
  /** This must be at least 255 bytes!!! */
  unsigned char str[256];
  unsigned char cmd;

  int len,i;

  /** Fix a status command saying everything is alright initially */

  str[0]=2;
  str[1]=CMD_OK;

  while (1)
    {
      /** send and wait here for ever for a command */

      len=debugger_exchange_str(str, str[0]);

      if (len!=str[0])
	{
	  printf("debugger.c, Error in length of string, got: %d expected %d\n", len, str[0]);
	  printf("str[0]=%d\n", str[0]);
	  printf("str[1]=%d\n", str[1]);
	  printf("str[2]=%d\n", str[2]);

	  str[0]=2;
	  str[1]=CMD_ERROR_PACKAGE;


	  
	  continue;
	}
      
      cmd=str[1];
   
      switch (cmd)
	{
	  
	  /** The <reserved=0> byte is intended for possible use with > 64K mem targets */
	  /** N>=1 */
	  
	case CMD_RUN:
	  {
	    /**
	       2 0
	       2 0
	    **/
	    
	    /** Here we find out which command to issue,
		the Run command will simply return from this function and
		continue execution.
		
		Other commands will render us a new turn in the loop
	    */
	    
	    /** Reply will be sent when we reenter debugger procedure again */
	    
	    return;
	  }
	    
	case CMD_SET_BREAK:
	  {
	    /**
	       Target (we) know which opcode(s) make up a breakpoint (usually one-byter)
	       
	       NOTE! To remove breakpoint we use an ordinary modify command
	       
	       5 1 <addrlo> <addrhi> <reserved=0>
	       
	       The opcodes here are the ones replaced by the breakpoint, usually just one byte
	       N+2 0 <opcode1> [<opcode2>] ... [<opcodeN>] 
	    **/
	    unsigned char *addr=str[2];
	    unsigned n=debugger_num_break_bytes();
	    
	    addr|=(str[3]<<8);

	    str[0]=n+2;
	    str[1]=0;
	    /** save original byte(s) */
	    for (i=0;i<n;i++)
	      {
		str[i+2]=*(addr+i);
	      }
	    
	    debugger_set_break(addr);

	    break;
	  }
	  
	case CMD_REGISTER_SET:
	  {
	    /**
	       N should always be 22 (decimal) for a pure vanilla Z80
	       N+2 2 <regbyte1> .. <regbyteN>
	       
	       2 0
	    **/
	    unsigned n;

	    /** From crt0, it should have saved away the registers here, when entering breakpoint */
	    unsigned char *addr=debugger_get_registers();
	    
	    n=str[0]-2;

	    for (i=0;i<24;i++)
	      {
		*(addr+i)=str[2+i];
	      }

	    str[0]=2;

	    str[1]=(n==24 ? CMD_OK : CMD_ERROR_REGISTER_LEN);

	    break;
	  }
	  
	case CMD_REGISTER_GET:
	  {
	    /**
	       2 3
	       
	       N+2 0 <regbyte1> .. <regbyteN>
	    **/
	    
	    /** From crt0 */
	    unsigned char *addr=debugger_get_registers();

	    for (i=0;i<24;i++)
	      {
		str[2+i]=*(addr+i);
	      }
	    
	    str[0]=26;
	    str[1]=CMD_OK;

	    break;
	  }
	  
	case CMD_MODIFY:
	  {
	    /**
	       N+5 4 <addrlo> <addrhi> <reserved=0> <byte1> ... <byteN>
	       
	       2 0
	    **/
	    unsigned char *addr=str[2] | (str[3]<<8);
	    
	    unsigned n=str[0]-5;

	    for (i=0;i<n;i++)
	      {
		*(addr+i)=str[5+i];
	      }
	    
	    str[0]=2;
	    str[1]=CMD_OK;

	    break;
	  }
	  
	case CMD_READ:
	  {
	    /**
	       6 5 <addrlo> <addrhi> <reserved=0> <num bytes>
	       
	       N+2 0 <byte1> ... <byteN>
	    **/
	        
	    /** From crt0 */
	    unsigned char *addr=str[2] | (str[3]<<8);
	    
	    unsigned n=str[5];

	    str[0]=n+2;
	    str[1]=CMD_OK;
	    
	    for (i=0;i<n;i++)
	      {
		str[2+i]=*(addr+i);
	      }

	    break;
	  }
	default:
	  {
	    str[0]=2;
	    str[1]=CMD_ERROR_UNKNOWN_COMMAND;
	    
	    break;
	  }

	}
  
    }

}
