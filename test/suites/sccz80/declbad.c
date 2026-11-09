/* Diagnostics for declaration specifiers. Each one must be reported.
   A block typedef must not be visible after its function. */

__preserves_regs(a,b) static int pr(void);

static static int twice;

int param(static int x);

void loop(void)
{
    for (static int i = 0; i < 1; i++)
        ;
}

void hide(void)
{
    typedef int Tloc;
}

Tloc leaked;
