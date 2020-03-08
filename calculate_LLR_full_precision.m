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

    % Determine how many symbols we have given the modulation scheme
    switch(modulation_scheme)
        case 0
            llr_vec = calculate_LLR_BPSK(symbol_vec, noise_var);
        case 1
            llr_vec = calculate_LLR_QPSK(symbol_vec, noise_var);
        case 2
            llr_vec = calculate_LLR_eight_QAM(symbol_vec, noise_var);
        case 3
            llr_vec = calculate_LLR_eight_PSK(symbol_vec, noise_var);
        case 4
            llr_vec = calculate_LLR_sixteen_QAM(symbol_vec, noise_var);
        otherwise
            error("Incorrect Modulation Scheme Value (must be between 0 and 4)");
    end
end

% Helper functions to calculate the LLRs for specific modulation schemes
% -----------------------------------------------------------------------

function llr_vec = calculate_LLR_BPSK(symbol_vec)
    llr_vec = zeros(1, length(symbol_vec));
    llr_vec = 2/noise_var * real(symbol_vec); % Discard imaginary component since we don't use it for BPSK
end

function llr_vec = calculate_LLR_QPSK(symbol_vec)
    llr_vec = zeros(2, length(symbol_vec));

end

function llr_vec = calculate_LLR_eight_QAM(symbol_vec)
    llr_vec = zeros(3, length(symbol_vec));

end

function llr_vec = calculate_LLR_eight_PSK(symbol_vec)
    llr_vec = zeros(3, length(symbol_vec));

end

function llr_vec = calculate_LLR_sixteen_QAM(symbol_vec)
    llr_vec = zeros(4, length(symbol_vec));

end