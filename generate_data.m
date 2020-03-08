% Generate a noisy signal given a random seed, length, and noise variance (Assuming symbol energy = 1)
% Returns 
% Note that this function will only handle modulation schemes with two orthogonal basis funtions
% modulation_scheme can take on the following values which correspond to the following:
%   0: 2-PSK
%   1: 4-QAM
%   2: 8-QAM
%   3: 8-PSK
%   4: 16-QAM
function [x_out, y_out] = generate_data(seed, num_transmissions, noise_var, modulation_scheme)

    load_modulations;
              
    % Set the RNG seed
    rng(seed, 'twister')
    
    % Determine how many symbols we have given the modulation scheme
    switch(modulation_scheme)
        case 0
            m = 1;
            constellation_map = BPSK_modulation;
        case 1
            m = 2;
            constellation_map = QPSK_modulation;
        case 2
            m = 3;
            constellation_map = eight_QAM_modulation;
        case 3
            m = 3;
            constellation_map = eight_PSK_modulation;
        case 4
            m = 4;
            constellation_map = sixteen_QAM_modulation;
        otherwise
            error("Incorrect Modulation Scheme Value (must be between 0 and 4)");
    end
    
    num_symbols = 2^m;
    
    % Generate the random signal based on modulation order
    bit_vec = randi([1,num_symbols], 1, num_transmissions);
    constellation_vec = constellation_map(bit_vec);
    
    % Generate the noise
    noise_vec = normrnd(0, sqrt(noise_var), 1, num_transmissions) + ...
                   normrnd(0, sqrt(noise_var), 1, num_transmissions)*1j;
    
end
