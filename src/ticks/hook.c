#include "ticks.h"

#include <stdio.h>
#include <stdlib.h>

static hook_command  hooks[256];

void PatchZ80(void)
{
    int   val;

    // CP/M Emulation bodge
    if ( pc == 7 ) {
       if ( c == 0x02 ) {
           fputc(e, stdout);
	   fflush(stdout);
       } else if ( c == 0x09 ) {
           // Print string
           int addr = d << 8 | e;
           int tp;
           while ( ( tp = *get_memory_addr(addr)) ) {
               if ( tp == '$' ) break;
               fputc(tp, stdout);
		addr++;
           }
	   fflush(stdout);
      }
       return;
    }

    if ( hooks[a] != NULL ) {
        hooks[a]();
    } else {
        printf("Unknown code %d\n",a);
        exit(1);
    }
}


static void cmd_exit(void)
{
	printf("\nTicks: %llu\n",st);
    exit(l);
}

void hook_init(void)
{
    hooks[CMD_EXIT] = cmd_exit;
    hook_io_init(hooks);
    hook_misc_init(hooks);
    hook_console_init(hooks);
}
