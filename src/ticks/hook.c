#include "ticks.h"

#include <stdio.h>
#include <stdlib.h>

static hook_command  hooks[256];

void PatchZ80(void)
{
    // CP/M Emulation bodge
    if ( pc == 7 ) {
        hook_cpm();
        return;
    }

    if ( rc2014_mode && (pc == 0x08 + 2 || pc == 0x10 + 2|| pc == 0x18 + 2) ) {
        hook_rc2014();
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
