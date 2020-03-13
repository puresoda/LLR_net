% Generate a noisy signal given a random seed, length, and noise variance (Assuming symbol energy = 1)
% Returns:
%   x_out: Noisy symbol vector, this will have shape [2,num_transmissions], 1st row is real part, 2nd is imaginary
%   y_out: Actual LLRs calculated, this will have shape [m, num_transmissions]
% Note that this function will only handle modulation schemes with two orthogonal basis funtions
% modulation_scheme can take on the following values which correspond to the following:
%   0: 2-PSK
%   1: 4-QAM
%   2: 8-QAM
%   3: 8-PSK
%   4: 16-QAM
function [x_out, y_out] = generate_data_fading_single_SNR(train_valid_test_sizes, snr, fade_var, modulation_scheme)
    
    save_flag = 1;
    load_modulations;
              
    % Set the RNG seed if wanted
    % seed = 0;
    % rng(seed, 'twister')
    
    % Determine how many symbols we have given the modulation scheme
    switch(modulation_scheme)
        case 0
            m = 1;
            constellation_map = BPSK_modulation;
            MODULATION = "BPSK";
        case 1
            m = 2;
            constellation_map = QPSK_modulation;
            MODULATION = "QPSK";
        case 2
            m = 3;
            constellation_map = eight_QAM_modulation;
            MODULATION = "8_QAM";
        case 3
            m = 3;
            constellation_map = eight_PSK_modulation;
            MODULATION = "8_PSK";
        case 4
            m = 4;
            constellation_map = sixteen_QAM_modulation;
            MODULATION = "16_QAM";
        otherwise
            error("Incorrect Modulation Scheme Value (must be between 0 and 4)");
    end
    
    num_symbols = 2^m;
    noise_var = 0.5*10^(-snr/10);
    
    for i=1:length(train_valid_test_sizes)
        % Generate the random signal based on modulation order
        bit_vec = randi([1,num_symbols], 1, train_valid_test_sizes(i));
        constellation_vec = constellation_map(bit_vec);

        % Generate the noise
        noise_vec = normrnd(0, sqrt(noise_var), 1, train_valid_test_sizes(i)) + ...
                       normrnd(0, sqrt(noise_var), 1, train_valid_test_sizes(i))*1j;
        
        % Generate fading
        fade_vec = raylrnd(fade_var,1,train_valid_test_sizes(i)) .* exp(2*pi*1j*rand(1,train_valid_test_sizes(i)));
        
        recieved_vec = fade_vec.*constellation_vec + noise_vec;

        % Calculate the LLRs
        y_out = calculate_LLR_full_precision(modulation_scheme, recieved_vec, noise_var);

        % Get values for x_out
        x_out = zeros(2,train_valid_test_sizes(i));
        x_out(1,:) = real(recieved_vec);
        x_out(2,:) = imag(recieved_vec);
        
        switch(i)
            case 1
                set = "train";
            case 2
                set = "valid";
            case 3
                set = "test";
            otherwise
                error("First argument should be an array of size 3!");
        end
        % Save values to csv files
        if(save_flag == 1)
            X_file_name = MODULATION + "_X_" + set + "_snr_" + num2str(snr) + "_fade_var_" + num2str(fade_var) + ".csv";
            y_file_name = MODULATION + "_y_" + set + "_snr_" + num2str(snr) + "_fade_var_" + num2str(fade_var) +  ".csv";

            writematrix(x_out, X_file_name);
            writematrix(y_out, y_file_name);
        end
    end
end
