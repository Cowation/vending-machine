# Vending Machine

Basic Vivado project scaffold for a Verilog/SystemVerilog vending machine design.

## Setup

Install Xilinx Vivado and make sure the `vivado` command is available from your terminal.

Create or refresh the Vivado project:

```sh
make vivado-project
```

This generates the Vivado project under `build/vivado/`.

To open the generated project in the Vivado GUI:

```sh
make vivado-gui
```

If Vivado is not on your `PATH`, pass the executable path to `make`:

```sh
make VIVADO=/path/to/vivado vivado-project
```

## Adding or Editing Source Files

Design sources go in `rtl/`. Testbench sources go in `tb/`.

After adding a new source file, add its path to the matching file list:

- `filelists/rtl.f` for design files
- `filelists/tb.f` for testbench files

Paths in the file lists are relative to the file list location. For example:

```text
../rtl/top.sv
../tb/top_tb.sv
```

The Vivado setup script currently expects the design top module to be `top` and the simulation top module to be `top_tb`. If those names change, update `scripts/vivado/create_project.tcl`.

## Running Simulation

Run behavioral simulation in batch mode:

```sh
make sim
```

The simulation script creates the Vivado project, launches behavioral simulation, runs it, and exits.

To remove generated build and simulation output:

```sh
make clean
```

## License

This project is licensed under the GNU Affero General Public License v3.0 or later. See `LICENSE` for the full license text.
