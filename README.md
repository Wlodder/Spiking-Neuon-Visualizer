# Spiking-Neuon-Visualizer
A Leaky integrate and Fire spiking neuron visualizer on an FPGA(ICE40) 

Check configuration files for extra details.

Using NANDLAND GO BOARD as FPGA base using VGA output to external monitor to display output.

The idea of the project was to give a slowed down real time approximation of a LIF Spiking neuron model using digital hardware. 
There are still more features that can be added:
* LED output on board to indicate when spike has been fired
* Different current injection methods (currently only constant current and spike can be simulated by hand), e.g. sinusodal
* Extra details for the UI

We are able to simulate fairly accurately when compared to the Brian2 packages LIF model however there is still a way to go. Due to the ability to only represent < 640 quantized
levels of membrane potential of the neuron the model is still inaccurate however using a different higher resolution output will yield to better results
