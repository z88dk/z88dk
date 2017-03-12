#include "ticks.h"

#include <stdio.h>
#include <stdlib.h>

static hook_command  hooks[256];

void PatchZ80(void)
{
    int   val;

    if ( hooks[a] != NULL ) {
        hooks[a]();
    } else {
        printf("Unknown code %d\n",a);
        exit(1);
    }
}


static void cmd_exit(void)
{
    exit(l);
}

void hook_init(void)
{
    hooks[CMD_EXIT] = cmd_exit;
    hook_io_init(hooks);
    hook_misc_init(hooks);
    hook_console_init(hooks);
}
