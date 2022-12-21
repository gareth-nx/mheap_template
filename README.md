Fortran code to create a heap data structure containing a user-defined type, using the preprocessor.

See [example_usage.f90](example_usage.f90) for an example of how to use it. Compile with
```
gfortran -cpp example_usage.f90 -o example_usage
./example_usage
```

This was modified by Gareth Davies from [Daniel Pena's mheap
code](https://github.com/trifling/mheap). The latter code supports heap
entries of fixed-size double-precision arrays.
