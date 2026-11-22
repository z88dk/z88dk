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
