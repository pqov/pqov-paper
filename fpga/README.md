# OV processor

## Prerequisites

### Hardware environment

- We test `SL1-p` and `SL1-s` on a AVNET Zedboard Zynq-7000 Development Board, XC7Z020
- We test `SL3` and `SL5` on a Digilent Nexys Video Artix-7 FPGA, XC7A200T.

### Software

- Python 3.10 with packages `numba pycryptodome pyfinite libconf`
- Vivado v2022.1 on Ubuntu 18.04
- RTL simulation tools: `ncverilog`, `vcs` or `iverilog`

## Folder structure

```
├── test_files            // Hardware configuration files
├── Makefile              // Used for simulation
├── onboard               // Tickle files to generate the system
├── scripts               // Scripts for simulation and sythesis
│
├── gen_processor.py      // Use this python code to config and generate verilog codes
├── simulator             // Python simulator providing behavior simulation
├── rtl                   // Verilog codes
├── gen_processor_v2.py   // Use this python code to config and generate verilog codes (v2)
├── simulator_v2          // Python simulator providing behavior simulation (v2)
└── rtl_v2                // Verilog codes (v2)
```

## Usage

- RTL simulation (may take a while)

```
python gen_processor.py test_files/one-round-aes/gauss-10round-aes/SL1-p/classic.cfg  // configuration for 1p classic with 1round AES
./scripts/csh_run_sim                                                                 // This script includes csh file to use vcs or ncverilog, modify it to the path your computer
```

- Vivado synthesis

```
python gen_processor.py test_files/one-round-aes/gauss-10round-aes/SL1-p/classic.cfg
./scripts/run_synthesis
// It will generate a folder "test_files_one-round-aes_gauss-10round-aes_SL1-p_classic_cfg"

// Get the hardware result
vivado -mode tcl -source ./scripts/report.tcl -tclargs "test_files_one-round-aes_gauss-10round-aes_SL1-p_classic_cfg"
```

- Run simulation and sythesis for all configuration files in a path

```
python scripts/run_all_simulation.py test_files/one-round-aes/                     // Run simulation
python scripts/run_all_synthesis.py test_files/one-round-aes/gauss-10round-aes/    // Run synthesis and generate xsa file
./scripts/hardware_result                                                          // Report all synthesized results
```

- Test version 2

```
python gen_processor_v2.py test_files/v2/1p-classic.cfg
./scripts/csh_run_sim
./scripts/run_synthesis
```

## Others

### Python simulator

- We also provide python simulator to perform behavioral simulation.

	```
	python simulator/codegen.py -n 16 -v 68 -o 44 -g 8 -m classic -r 10  -e        // Generate test.data and simulate
	python simulator/codegen.py -h                                                 // See the meaning of parameters
	```

### The configuration file

- Sepcify the variables in this file
- Example:

	```
	N = 16;
	V = 68;
	O = 44;
	GF_bit = 8;
	row_layout = [8, 8];
	col_layout = [4, 4, 4, 4];
	right_delay_every_X_resource_unit = 1;
	mode = "classic";
	aes_round = 10;
	use_inversion = false;
	use_tower_field = false;
	use_pipelined_aes = false;
	platform = "zedboard";
	```
