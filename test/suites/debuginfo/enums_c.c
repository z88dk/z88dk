/* A module without enums: a name that two enums define (RED) resolves to the
 * enum with the smallest key, F<file>$<tag>, here enums_a.c's colour. */
int gc_int = 3;

int fc(void)
{
    return gc_int;      /* <-- check_enums.sh BREAK LINE C */
}
