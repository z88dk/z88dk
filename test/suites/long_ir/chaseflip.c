/* Two pointer-chase loops inside a counted outer loop. Only the T-state estimate decides
 * whether this function is emitted in its sp form, and it must count the chase loops as
 * nested in the outer one wherever they sit in the text. On the eZ80 the sp form is faster
 * (the chased pointer stays in a register), so the estimator must choose it.
 */
typedef struct node { struct node *next; unsigned int val; } node;

static node nodes[64];

unsigned int list_walk(node *head)
{
    unsigned int chk = 0;
    int r;

    for (r = 0; r < 20; r++) {
        node *p = head;
        while (p) { chk = (chk + p->val) & 0xffffu; p = p->next; }
        p = head;
        while (p) { p->val = (p->val + 3u) & 0xffffu; p = p->next; }
    }
    return chk;
}

int main(void)
{
    int i;

    for (i = 0; i < 63; i++) { nodes[i].next = &nodes[i + 1]; nodes[i].val = i; }
    nodes[63].next = 0;
    return list_walk(nodes) == 0;
}
