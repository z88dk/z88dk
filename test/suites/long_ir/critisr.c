/* Interrupt rows. The handlers are linked and not called: reti and
   retn are not C returns. A Rabbit critical handler emits ipset 3
   and ipres around the body. */

static int x;

void isr_bare(void) __interrupt
{
    __critical { x = 1; }
}

void isr_num(void) __interrupt(0)
{
    __critical { x = 2; }
}

void isr_crit_bare(void) __critical __interrupt
{
    x = 3;
}

void isr_crit_num(void) __critical __interrupt(1)
{
    __critical { x = 4; }
}

int main(void)
{
    volatile void *p;

    p = (void *)isr_bare;
    p = (void *)isr_num;
    p = (void *)isr_crit_bare;
    p = (void *)isr_crit_num;
    return p ? 0 : 1;
}
