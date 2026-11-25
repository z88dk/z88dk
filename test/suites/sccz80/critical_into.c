/* A jump into a statement __critical is rejected. Nested statement
   __critical stays a compiler error. */

void into_goto(void)
{
    goto inside;
    __critical {
    inside:
        ;
    }
}

void into_back(void)
{
    __critical {
    inside:
        ;
    }
    goto inside;
}

void into_case(int n)
{
    switch (n) {
    case 0:
        __critical {
        case 1:
            break;
        }
        break;
    default:
        break;
    }
}

void into_default(int n)
{
    switch (n) {
    case 0:
        __critical {
        default:
            break;
        }
        break;
    }
}

void nest(void)
{
    __critical {
        __critical {
            ;
        }
    }
}
