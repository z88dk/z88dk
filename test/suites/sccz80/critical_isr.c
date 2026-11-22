int x;

void isr_bare(void) __interrupt
{
    __critical {
        x = 1;
    }
}

void isr_num(void) __interrupt(0)
{
    __critical {
        x = 1;
    }
}

void isr_crit_num(void) __critical __interrupt(0)
{
    __critical {
        x = 1;
    }
}

void isr_crit_bare(void) __critical __interrupt
{
    __critical {
        x = 1;
    }
}
