#include "ticks.h"

#include <stdio.h>
#include <stdlib.h>

static hook_command  hooks[256];

void PatchZ80(void)
{
    int   val;

    // CP/M Emulation bodge
    if ( pc == 7 ) {
        hook_cpm();
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
