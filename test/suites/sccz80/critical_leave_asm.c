/* Instruction lock for a leave. break_out and goto_out leave the
   statement, so each has a leave on that path and the block leave.
   break_in and goto_in stay inside, so each has the block leave only.
   suppressed is a critical function. The inner statement adds nothing
   on a cpu that cannot save the enable flag. */

int break_out(int n)
{
    int s = 0;

    while (n) {
        __critical {
            s++;
            break;
        }
        n--;
    }
    return s;
}

int break_in(int n)
{
    int s = 0;

    __critical {
        while (n) {
            s++;
            break;
        }
    }
    return s;
}

int goto_out(int n)
{
    int s = 0;

    __critical {
        s = n;
        goto done;
    }
    s = 2;
done:
    return s;
}

int goto_in(int n)
{
    int s = 0;

    __critical {
        goto inside;
        s = 1;
    inside:
        s = n;
    }
    return s;
}

int suppressed(int n) __critical
{
    int s = 0;

    while (n) {
        __critical {
            s++;
            break;
        }
        n--;
    }
    return s;
}
