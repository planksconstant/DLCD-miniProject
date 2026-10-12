#!/bin/bash
set -e

echo "Compiling Verilog files..."
iverilog -o serial_adder_sim full_adder.v shift_register.v serial_adder_16bit.v tb_serial_adder.v
echo "Compilation successful! Running simulation..."
./serial_adder_sim
echo "Simulation complete. VCD file generated."
echo "open the *.vcd file in surfer or GTKwave"
