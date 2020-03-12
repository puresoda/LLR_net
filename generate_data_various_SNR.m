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
function [X_train, X_valid, X_test, y_train, y_valid, y_test] = generate_data_various_SNR(train_valid_test_sizes, SNR_range, modulation_scheme)
    
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
    
    X_train = zeros(2,train_valid_test_sizes(1)*length(SNR_range));
    X_valid = zeros(2,train_valid_test_sizes(2)*length(SNR_range));
    X_test  = zeros(2,train_valid_test_sizes(3)*length(SNR_range));
    
    y_train = zeros(m,train_valid_test_sizes(1)*length(SNR_range));
    y_valid = zeros(m,train_valid_test_sizes(2)*length(SNR_range));
    y_test  = zeros(m,train_valid_test_sizes(3)*length(SNR_range));
    
    num_symbols = 2^m;
    
    for ii=1:length(SNR_range)
        for i=1:length(train_valid_test_sizes)
            
            % Generate the random signal based on modulation order
            bit_vec = randi([1,num_symbols], 1, train_valid_test_sizes(i));
            constellation_vec = constellation_map(bit_vec);
            
            % Assuming average symbol energy of 1, convert SNR to N0
            noise_var = 0.5*10^(-1*SNR_range(i)/10);
            
            % Generate the noise
            noise_vec = normrnd(0, sqrt(noise_var), 1, train_valid_test_sizes(i)) + ...
                        normrnd(0, sqrt(noise_var), 1, train_valid_test_sizes(i))*1j;

            recieved_vec = constellation_vec + noise_vec;

            % Calculate the LLRs
            y_out = calculate_LLR_full_precision(modulation_scheme, recieved_vec, noise_var);

            % Get values for x_out
            x_out = zeros(2,train_valid_test_sizes(i));
            x_out(1,:) = real(recieved_vec);
            x_out(2,:) = imag(recieved_vec);

            switch(i)
                case 1
                    X_train(:,1+ train_valid_test_sizes(1)*(ii-1): train_valid_test_sizes(1)*ii) = x_out;
                    y_train(:, 1+ train_valid_test_sizes(1)*(ii-1): train_valid_test_sizes(1)*ii) = y_out;
                case 2
                    X_valid(:,1+ train_valid_test_sizes(2)*(ii-1): train_valid_test_sizes(2)*ii) = x_out;
                    y_valid(:, 1+ train_valid_test_sizes(2)*(ii-1): train_valid_test_sizes(2)*ii) = y_out;
                case 3
                    X_test(:,1+ train_valid_test_sizes(3)*(ii-1): train_valid_test_sizes(3)*ii) = x_out;
                    y_test(:, 1+ train_valid_test_sizes(3)*(ii-1): train_valid_test_sizes(3)*ii) = y_out;
                otherwise
                    error("First argument should be an array of size 3!");
            end
        end
    end
    
    if(save_flag == 1)
        X_train_file_name = MODULATION + "_X_" + "train" + "_SNRs_" + num2str(SNR_range(1)) + "_" + num2str(SNR_range(end)) + ".csv";
        y_train_file_name = MODULATION + "_y_" + "train" + "_SNRs_" + num2str(SNR_range(1)) + "_" + num2str(SNR_range(end)) + ".csv";
        
        X_valid_file_name = MODULATION + "_X_" + "valid" + "_SNRs_" + num2str(SNR_range(1)) + "_" + num2str(SNR_range(end)) + ".csv";
        y_valid_file_name = MODULATION + "_y_" + "valid" + "_SNRs_" + num2str(SNR_range(1)) + "_" + num2str(SNR_range(end)) + ".csv";
        
        X_test_file_name = MODULATION + "_X_" + "test" + "_SNRs_" + num2str(SNR_range(1)) + "_" + num2str(SNR_range(end)) + ".csv";
        y_test_file_name = MODULATION + "_y_" + "test" + "_SNRs_" + num2str(SNR_range(1)) + "_" + num2str(SNR_range(end)) + ".csv";
        
        writematrix(X_train, X_train_file_name);
        writematrix(y_train, y_train_file_name);
        
        writematrix(X_valid, X_valid_file_name);
        writematrix(y_valid, y_valid_file_name);
        
        writematrix(X_test, X_test_file_name);
        writematrix(y_test, y_test_file_name);
    end
end
