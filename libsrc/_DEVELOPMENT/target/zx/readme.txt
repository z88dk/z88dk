
=========
BIFROST_H
=========

Multicolour background and sprites engine by Einar Saukas.

=======
DISPLAY
=======

A complete set of functions for manipulating screen addresses and
attribute addresses.

The function naming is systematic to describe what manipulation
is being offered.

For example:

zx_saddr2px() will take a screen address (saddr) and return the
corresponding x pixel coordinate (px).

If you want to convert a screen address (saddr) to an attribute
address (aaddr), you would look for the function zx_saddr2aaddr().

Getting the attribute address corresponding to character coordinate
y,x can be had using zx_cyx2aaddr().

========
GRAPHICS
========

Various drawing primitives.

====
MISC
====

Uncategorized functions.

========
NIRVANAP
========

Multicolour background and sprites engine by Einar Saukas.
