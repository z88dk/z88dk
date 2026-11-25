/* A return inside a statement __critical leaves that statement, then
   the handler epilogue runs. The block leave and the closing epilogue
   follow the return. That return path is the earlier save-cpu fix.
   isr_bare_brk and isr_bare_goto leave by break and goto. A numbered
   handler and a critical handler keep the statement suppressed on a
   cpu that cannot save the flag. */

int x;

void isr_bare_ret(void) __interrupt
{
    __critical {
        x = 1;
        return;
    }
}

void isr_num_ret(void) __interrupt(0)
{
    __critical {
        x = 1;
        return;
    }
}

void isr_crit_bare_ret(void) __critical __interrupt
{
    __critical {
        x = 1;
        return;
    }
}

void isr_crit_num_ret(void) __critical __interrupt(0)
{
    __critical {
        x = 1;
        return;
    }
}

void isr_bare_brk(void) __interrupt
{
    while (x) {
        __critical {
            x = 0;
            break;
        }
    }
}

void isr_bare_goto(void) __interrupt
{
    __critical {
        x = 1;
        goto isr_out;
    }
    x = 2;
isr_out:
    ;
}
