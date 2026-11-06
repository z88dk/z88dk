/* Shared by floats_a.c and floats_b.c: their T: records have the same key, so a member
 * is read in the format of the object that holds it, not of the record that was kept */
struct pay { float v; };
struct node { struct node *next; struct pay *p; };
struct box { struct pay *items[2]; };
struct tail { float f; int n; };
struct wrap { struct tail t; int k; };
