from brian2 import *
import matplotlib.pyplot as plt
import numpy as np

start_scope()

tau = 10*ms
I = 10
eqs = '''
dv/dt = (-v + I)/tau : 1
'''

G = NeuronGroup(1,eqs, method='exact', reset="v = 0", refractory=5*ms, threshold="v>9")
M = StateMonitor(G, 'v', record=True)

G.v = 5 # initial voltage

print('Before v = %s' % G.v[0])
run(300*ms)
print('After v = %s' % G.v[0])

plot(M.t/ms, M.v[0])
xlabel("Time (ms)")
ylabel('v')

show()