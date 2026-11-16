# AI FPGA

A SystemVerilog implementation of core convolutional neural-network operations for an iCE40 FPGA. The project is designed around small, quantized grayscale images and includes convolution, ReLU activation, and max-pooling modules, plus simulation and FPGA build targets.

## Design assumptions

- Inputs are quantized grayscale values represented in the range `-127..127`.
- Images are currently modeled as square, single-channel images, such as MNIST's `28x28` images.
- Filter weights and biases use 8-bit signed values.
- Accumulation uses signed 32-bit values.
- Convolution supports square kernels, configurable stride, and zero padding support in the supporting modules.

## Repository layout

- `conv2d.sv`, `relu.sv`, `maxpool2d.sv` - CNN processing modules.
- `memory.sv` - initialization of test image data.
- `top.sv` - example top-level integration.
- `top_tb.sv` - simulation testbench.
- `png_to_txt.py` - converts grayscale PNG pixels to signed hexadecimal input data.
- `test_imgs/` - sample images and generated input data.
- `common/iceBlinkPico.pcf` - FPGA pin constraints.
- `Makefile` - simulation, synthesis, programming, and cleanup targets.

## Requirements

For simulation, install Icarus Verilog and GTKWave. For FPGA builds, install Yosys, nextpnr-ice40, and icepack. The `png_to_txt.py` utility requires Python and Pillow.

## Simulate

```sh
make test
```

This compiles `top_tb.sv`, runs the simulation, and opens the generated waveform in GTKWave.

## Build and program

```sh
make build
make prog
```

The build targets synthesize the `top` module for an iCE40 UP5K device in an SG48 package. Check the pin constraints and programmer configuration before programming hardware.

## Convert an input image

```sh
python png_to_txt.py test_imgs/test_img.png
```

The command writes a same-name `.txt` file containing one signed pixel value per line in two's-complement hexadecimal form.

## Status

This is an experimental hardware implementation and should be treated as a starting point for extending the supported network dimensions, data layouts, and hardware interfaces.