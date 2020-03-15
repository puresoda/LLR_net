% MODULATIONS (each index corresponds to the costellation for a given decimal)
BPSK_modulation = [1, -1];
QPSK_modulation = 1/sqrt(2)*[(1 + 1j), (-1 + 1j), (1 - 1j), (-1 - 1j)];

eight_PSK_modulation = [(1 + 0j), (1 + 1j)/sqrt(2), (-1 + 1j)/sqrt(2), (0 + 1j), (1 -1j)/sqrt(2), (0 - 1j), (-1 + 0j), (-1 -1j)/sqrt(2)];

eight_QAM_modulation = 1/sqrt(6)*[(-3 + 1j), (-3 - 1j), (-1 + 1j), (-1 - 1j), ...
                 (3 + 1j),  (3 - 1j),  (1 + 1j), (1 - 1j)];

sixteen_QAM_modulation = 1/sqrt(10)*[(-3 + 3j), (-1 + 3j), (3 + 3j), (1 + 3j), ...
                  (-3 + 1j), (-1 + 1j), (3 + 1j), (1 + 1j),  ...
                  (-3 -3j),  (-1 -3j),  (3 - 3j), (1 - 3j), ...
                  (-3 -1j),  (-1 -1j),  (3 - 1j), (1 - 1j)];
              
thirtytwo_QAM_modulation = 0;