#include "ticks.h"
#include "breakpoints.h"

#include <stdio.h>
#include <stdlib.h>

static hook_command  hooks[256];

void PatchZ80(void)
{
    /* RC2014 BASIC traps RST 08/10/18 with ED FE; after the trap pc is
     * 0x0A/0x12/0x1A.  Must be checked before the CP/M bodges below —
     * CP/M uses pc==10 for console status, which collides with RST 08. */
    if ( c_rc2014_mode && (pc == 0x08 + 2 || pc == 0x10 + 2 || pc == 0x18 + 2) ) {
        hook_rc2014();
        return;
    }

    // CP/M Emulation bodge
    if ( pc == 7 ) {
        hook_cpm();
        return;
    } else if ( pc == 10 ) {
       // CPM console status
       a = kbhit() == 1 ? 1 : 0;
       return;
    } else if ( pc == 13 ) {
       // CPM console in
       a = getch();
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
    warn_existing_temp_breakpoints();
    exit(l);
}

void hook_init(void)
{
    hooks[CMD_EXIT] = cmd_exit;
    hook_io_init(hooks);
    hook_cpm_init(hooks);
    hook_misc_init(hooks);
    hook_console_init(hooks);
}
