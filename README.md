# Traffic-control-using-verilog
The objective of this design is to implement a digital controller for a two-road traffic light 
system with an additional pedestrian crossing phase, using Verilog hardware description 
language and a one-hot encoded finite state machine (FSM). The controller must generate 
the correct sequence of traffic light signals for both roads, respond to a pedestrian push 
button, and insert a pedestrian phase at the next safe transition. During the pedestrian 
phase, both roads must be red for a fixed time interval, and vehicle greens must never 
conflict. The design is verified through simulation and then synthesized on an FPGA to 
analyse resource usage and timing performance. 
