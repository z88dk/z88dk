# ZX Spectrum Development with Z88DK - Some Details

This is the sixth document in the series which describes how to get started
writing ZX Spectrum programs using Z88DK. As before, it concerns itself only
with the newer, more standards compilant zsdcc C compiler. Neither the original
sccz80 compiler nor the classic library is discussed.

This document relates specifically to the 48K Spectrum. Other models have more
complex memory management and are not covered here.

## Assumptions

It is assumed the reader has worked through the earlier installments of this
series and is continuing on from [installment 5](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_05_MultipleFiles.md).

If you would like to jump to the beginning, click on [installment 1](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_01_GettingStarted.md).

## Z88DK's Memory Map, Stack, and Other Details

In previous installments we've looked at how to get started writing C programs
for the ZX Spectrum using Z88DK. As things are inevitably getting more complex,
it's time to take a step back and try to understand a few details of what's
happening under the covers. We're not going to look at all the complexities,
just the ones which will be useful to know as we move forward.

