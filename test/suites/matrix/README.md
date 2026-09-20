# test/suites/matrix — BENCH_MATRIX workflow

`../gen_bench_matrix3.py` is the full matrix generator. It measures 30 benchmarks
across 12 CPUs and prints the compiler columns as a box table.

The generator expects a built tree. It sets `ZCCCFG` and adds `bin/` to `PATH`.
Set `MX_TMP` to choose its temporary directory.

## Generate a snapshot

From the repository root, run:

```sh
python3 test/suites/gen_bench_matrix3.py > /tmp/BENCH_MATRIX.table
```

Pass benchmark names to measure a subset. Run the full generator before you
update the committed table.

## Maintaining the committed snapshot

`../BENCH_MATRIX.txt` is the current committed snapshot. Keep exactly one
complete matrix table there; do not append prior reports or old snapshots.

To update it:

1. Append the outgoing committed table and its measurement notes to the local
   `../BENCH_MATRIX.history.txt` archive before regenerating the table.
2. Run the full generator and save its output as a complete table.
3. Replace the table in `../BENCH_MATRIX.txt` and update its metadata lines.
4. Commit `../BENCH_MATRIX.txt`; keep `../BENCH_MATRIX.history.txt` untracked.

Git history also retains earlier committed versions of the table. The local
archive preserves the prior appended reports and notes without growing the
committed snapshot.
