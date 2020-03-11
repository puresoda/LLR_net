% Given a modulation scheme, input vector of complex symbols, and noise variance calculate the LLR of each symbol
% Note that this function will only handle modulation schemes with two orthogonal basis funtions
% modulation_scheme can take on the following values which correspond to the following:
%   0: 2-PSK
%   1: 4-QAM
%   2: 8-QAM
%   3: 8-PSK
%   4: 16-QAM
function llr_vec = calculate_LLR_full_precision(modulation_scheme, symbol_vec, noise_var)
    % Could perhaps add a function to allow for non-uniform source distribution (ie: p(x=1) != p(x=0))
    
    load_modulations;
    
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

    llr_vec = zeros(m, length(symbol_vec));

    % Note that this requires the constellation map to be in ASCENDING BIT ORDER
    % ex: QPSK constellation map is a vector corresponding to 00, 01, 10, and 11 respectively
    for i=1:length(symbol_vec)

        % Calculate LLR for every bit
        for j=1:m

            % Reset num_or_dem, this variable is used to determine whether we are calculating probability of bit 0 or 1 (corresponding to +1 and -1 respectively)
            num_or_dem = 1;
            num_sum = 0;
            dem_sum = 0;

            % Loop through all symbols now, note that we apply the logarithmn at the end 
            for k=1:num_symbols
                
                % Looking at 0 bit
                if(num_or_dem == 1)
                    num_sum = num_sum + exp(-1/(2*noise_var) * (abs(symbol_vec(i) - constellation_map(k)))^2);

                % Looking at 1 bit
                else
                    dem_sum = dem_sum + exp(-1/(2*noise_var) * (abs(symbol_vec(i) - constellation_map(k)))^2);
                end
                
                % Swap whether we are looking at a 0 bit or 1 bit
                % For LSB, swap every symbol
                % For 2nd LSB, swap every 2 symbols
                % For nth LSB, swap every 2^(n-1) symbols
                if(mod(k, 2^(j-1)) == 0)
                    num_or_dem = num_or_dem * -1;
                end
            end

            llr_vec(j,i) = log(num_sum / dem_sum);
        end
    end
end