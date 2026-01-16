/*
 * An ANSI-fication of the qsort implementation in
 * K&R second edition page 120.
 * (aralbrec@z88dk.org)
 *
 * This implementation is reported widely on the
 * internet in non-ansi form and some implementation
 * based on it is likely to be used by users who
 * discover qsort() is missing from a compiler's
 * library.
 *
 */
 
void swap(unsigned char *a, unsigned char *b, unsigned int size)
{
   unsigned char t;
   
   while (size--)
   {
         t = *a; 
      *a++ = *b;
      *b++ =  t;
   }
}

void qsort_helper(unsigned char *left, unsigned char *right, unsigned int size, int (*compar)(void *,void *))
{
   unsigned char *i, *last;
   
   if (left >= right)
      return;
   
   swap(left, left + (right-left)/(size*2)*size, size);
   
   last = left;
   for (i = left + size; i <= right; i += size)
      if ((*compar)(i, left) < 0)
            swap(last+=size, i, size);
   
   swap(left, last, size);
   qsort_helper(left, last - size, size, compar);
   qsort_helper(last + size, right, size, compar);
}


void qsort(void *base, unsigned int nmemb, unsigned int size, void *compar)
{
   unsigned int gross = nmemb*size;
   
   if (gross) qsort_helper(base, (unsigned char *)base + gross - size, size, compar);
}
