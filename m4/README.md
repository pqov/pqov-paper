This directory contains the implementation targeting the Arm Cortex-M4. 
In particular, we target the [NUCLEO-L4R5ZI board](https://www.st.com/en/evaluation-tools/nucleo-l4r5zi.html) featuring 2MB of Flash and 640KB of RAM.


## Cloning
Clone this repository with submodules recursively

```
# for a fresh clone
git clone  --recurse-submodules https://github.com/pqov/pqov-paper

# for an existing clone
git submodule update --init --recursive

```


## Getting started (pqm4)

Follow the steps on https://github.com/mupq/pqm4 for setting up all required software and making sure that communication with the board works correctly.
Make sure that the following command works in pqm4 (not in this repository)

```
./test.py -p nucleo-l4r5zi -u /dev/ttyACM0 kyber512
```

It should output
```
DEBUG:platform interface:Found start pattern: b'=========================\n'
INFO:BoardTestCase:Success
```

multiple times.


## Structure of this repository

Core arithmetic is in the assembly files in [m4asm](./m4asm) which is then symlinked into the implementation directories.
Implementation directories is available in [crypto_sign](./crypto_sign).

The core differences to the pqm4 framework are
 - Added support for writing to flash memory in [hal-flash.h](./common/hal-flash.h) and [hal-flash.c](./common/hal-flash.c). This is used for all parameter sets for which the key does not fit in RAM. Implementations are then called `m4f-flash` or `m4f-flash-speed`.
 - Added round-reduced AES for sampling the OV public key. The implementation is based on the [implementation by Stoffelen and Schwabe](https://github.com/Ko-/aes-armcortexm). Our adapted implementation is in [aes4-publicinputs.h](./common/aes4-publicinputs.h), [aes4-publicinputs.c](./common/aes4-publicinputs.c), and [aes4-publicinputs.S](./common/aes4-publicinputs.S).

To get an overview about the core differences between the reference implementation and the optimized implementation, have a look at [blas_matrix_m4f.c](./crypto_sign/ov-Ip/m4f/blas_matrix_m4f.c) and [ov_publicmap_m4f.c](./crypto_sign/ov-Ip/m4f/ov_publicmap_m4f.c).

## Using this repository

This repository works in a similar way as pqm4 via the [`test.py`](./test.py), [`testvectors.py`](./testvectors.py), and [`benchmark.py`](./benchmarks.py) scripts.

To run functional tests, you can use the [`test.py`](./test.py) script:
```
    # to test all implementations of all parameter sets
    ./test.py -p nucleo-l4r5zi -u /dev/ttyACM0

    # for testing only a subset of parameter sets, you can pass the parameter set names
    # parameter sets are ov-Ip  ov-Ip-pkc  ov-Ip-pkc-aes4  ov-Ip-pkc-skc  ov-Ip-pkc-skc-aes4  ov-Is  ov-Is-pkc  ov-Is-pkc-aes4  ov-Is-pkc-skc  ov-Is-pkc-skc-aes4
    ./test.py -p nucleo-l4r5zi -u /dev/ttyACM0 ov-Ip ov-Is
```

To ensure that testvectors are matching between the reference implementation and the optimized implementation, you can use the [`testvectors.py`](./testvectors.py) script:
```
    # to check all implementations of all parameter sets
    ./testvectors.py -p nucleo-l4r5zi -u /dev/ttyACM0

    # for testing only a subset of parameter sets, you can pass the parameter set names
    # parameter sets are ov-Ip  ov-Ip-pkc  ov-Ip-pkc-aes4  ov-Ip-pkc-skc  ov-Ip-pkc-skc-aes4  ov-Is  ov-Is-pkc  ov-Is-pkc-aes4  ov-Is-pkc-skc  ov-Is-pkc-skc-aes4
    ./testvectors.py -p nucleo-l4r5zi -u /dev/ttyACM0 ov-Ip ov-Is
```

For benchmarking, there is the [`benchmarks.py`](./benchmarks.py) script. 
It comes with additional arguments:
 - `-i` : number of iterations for signing and verification (key generation is only run once as it is slower and does not have much runtime variation)
 - `--nostack`: skip the stack benchmarks
 - `--nohashing`: skip the hashing benchmarks
 - `--nosize`: skip the code size benchmarks
 - `--nospeed`: skip the speed benchmarks
```
    # to check all implementations of all parameter sets
    ./benchmarks.py -p nucleo-l4r5zi -u /dev/ttyACM0 -i 10000

    # for testing only a subset of parameter sets, you can pass the parameter set names
    # parameter sets are ov-Ip  ov-Ip-pkc  ov-Ip-pkc-aes4  ov-Ip-pkc-skc  ov-Ip-pkc-skc-aes4  ov-Is  ov-Is-pkc  ov-Is-pkc-aes4  ov-Is-pkc-skc  ov-Is-pkc-skc-aes4
    ./benchmarks.py -p nucleo-l4r5zi -u /dev/ttyACM0 -i 10000 ov-Ip ov-Is
```

To convert the benchmarking results (stored in plaintext in `benchmarks/`), you can use the [`convert_benchmarks.py`](./convert_benchmarks.py) script:
```
    # markdown format
    ./convert_benchmarks.py md

    # csv format
    ./convert_benchmarks.py csv
```


Performing the 10000 benchmarks for the paper has been done with the following commands:
```
#!/bin/bash

./benchmarks.py -p nucleo-l4r5zi -u /dev/ttyACM0 --nohashing --nosize ov-Is ov-Is-pkc ov-Is-pkc-aes4 ov-Is-pkc-skc ov-Is-pkc-skc-aes4 ov-Ip ov-Ip-pkc ov-Ip-pkc-aes4 ov-Ip-pkc-skc ov-Ip-pkc-skc-aes4 -i 10
./benchmarks.py -p nucleo-l4r5zi -u /dev/ttyACM0 --nostack --nohashing --nosize ov-Is ov-Is-pkc ov-Is-pkc-aes4 ov-Is-pkc-skc ov-Is-pkc-skc-aes4 ov-Ip ov-Ip-pkc ov-Ip-pkc-aes4 ov-Ip-pkc-skc ov-Ip-pkc-skc-aes4 -i 990
./benchmarks.py -p nucleo-l4r5zi -u /dev/ttyACM0 --nostack --nohashing --nosize ov-Is ov-Is-pkc ov-Is-pkc-aes4 ov-Is-pkc-skc ov-Is-pkc-skc-aes4 ov-Ip ov-Ip-pkc ov-Ip-pkc-aes4 ov-Ip-pkc-skc ov-Ip-pkc-skc-aes4 -i 1000
./benchmarks.py -p nucleo-l4r5zi -u /dev/ttyACM0 --nostack --nohashing --nosize ov-Is ov-Is-pkc ov-Is-pkc-aes4 ov-Is-pkc-skc ov-Is-pkc-skc-aes4 ov-Ip ov-Ip-pkc ov-Ip-pkc-aes4 ov-Ip-pkc-skc ov-Ip-pkc-skc-aes4 -i 1000
./benchmarks.py -p nucleo-l4r5zi -u /dev/ttyACM0 --nostack --nohashing --nosize ov-Is ov-Is-pkc ov-Is-pkc-aes4 ov-Is-pkc-skc ov-Is-pkc-skc-aes4 ov-Ip ov-Ip-pkc ov-Ip-pkc-aes4 ov-Ip-pkc-skc ov-Ip-pkc-skc-aes4 -i 1000
./benchmarks.py -p nucleo-l4r5zi -u /dev/ttyACM0 --nostack --nohashing --nosize ov-Is ov-Is-pkc ov-Is-pkc-aes4 ov-Is-pkc-skc ov-Is-pkc-skc-aes4 ov-Ip ov-Ip-pkc ov-Ip-pkc-aes4 ov-Ip-pkc-skc ov-Ip-pkc-skc-aes4 -i 1000
./benchmarks.py -p nucleo-l4r5zi -u /dev/ttyACM0 --nostack --nohashing --nosize ov-Is ov-Is-pkc ov-Is-pkc-aes4 ov-Is-pkc-skc ov-Is-pkc-skc-aes4 ov-Ip ov-Ip-pkc ov-Ip-pkc-aes4 ov-Ip-pkc-skc ov-Ip-pkc-skc-aes4 -i 1000
./benchmarks.py -p nucleo-l4r5zi -u /dev/ttyACM0 --nostack --nohashing --nosize ov-Is ov-Is-pkc ov-Is-pkc-aes4 ov-Is-pkc-skc ov-Is-pkc-skc-aes4 ov-Ip ov-Ip-pkc ov-Ip-pkc-aes4 ov-Ip-pkc-skc ov-Ip-pkc-skc-aes4 -i 1000
./benchmarks.py -p nucleo-l4r5zi -u /dev/ttyACM0 --nostack --nohashing --nosize ov-Is ov-Is-pkc ov-Is-pkc-aes4 ov-Is-pkc-skc ov-Is-pkc-skc-aes4 ov-Ip ov-Ip-pkc ov-Ip-pkc-aes4 ov-Ip-pkc-skc ov-Ip-pkc-skc-aes4 -i 1000
./benchmarks.py -p nucleo-l4r5zi -u /dev/ttyACM0 --nostack --nohashing --nosize ov-Is ov-Is-pkc ov-Is-pkc-aes4 ov-Is-pkc-skc ov-Is-pkc-skc-aes4 ov-Ip ov-Ip-pkc ov-Ip-pkc-aes4 ov-Ip-pkc-skc ov-Ip-pkc-skc-aes4 -i 1000
./benchmarks.py -p nucleo-l4r5zi -u /dev/ttyACM0 --nostack --nohashing --nosize ov-Is ov-Is-pkc ov-Is-pkc-aes4 ov-Is-pkc-skc ov-Is-pkc-skc-aes4 ov-Ip ov-Ip-pkc ov-Ip-pkc-aes4 ov-Ip-pkc-skc ov-Ip-pkc-skc-aes4 -i 1000
```