# ai-fpga

What are the assumptions that we are making: 

1) Model has been quantized, this means that numbers are all integer
2) Image are black and white!, in theory, this doenst matter just you jsut add a dimesinon but yea..
3) Weights and biases are int8
4) Accumulant values are 32 bit signed intergers
5) Assume working with nmist digits data(28*28) images with square convolutions (support for zero paddign)
6) Images are -127 to 127 insyead of 128, this way zero is a mid point
