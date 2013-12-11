
;; struct obstack
;; {
;;    void *fence;
;;    void *object;
;;    void *end;
;;    char mem[0];
;; }
;;
;; must not reorder members

defvars 0
{
   __ob_fence    ds.w 1     ;; next address to allocate from
   __ob_object   ds.w 1     ;; address of currently growing object
   __ob_end      ds.w 1     ;; address of byte following obstack
   __ob_mem                 ;; free bytes follow
}
