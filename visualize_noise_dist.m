% Generates probability contours / surfaces given a modulation scheme and noise_variance
% Note that this function will only handle modulation schemes with two orthogonal basis funtions
% modulation_scheme can take on the following values which correspond to the following:
%   0: 2-PSK
%   1: 4-QAM
%   2: 8-QAM
%   3: 8-PSK
%   4: 16-QAM
function visualize_noise_dist(noise_var, modulation_scheme)

    load_modulations;
              
    % Determine how many symbols we have given the modulation scheme
    switch(modulation_scheme)
        case 0
            m = 1;
            constellation_map = BPSK_modulation;
            modulation_name = "BPSK";
        case 1
            m = 2;
            constellation_map = QPSK_modulation;
            modulation_name = "QPSK";
        case 2
            m = 3;
            constellation_map = eight_QAM_modulation;
            modulation_name = "8-QAM";
        case 3
            m = 3;
            constellation_map = eight_PSK_modulation;
            modulation_name = "8-PSK";
        case 4
            m = 4;
            constellation_map = sixteen_QAM_modulation;
            modulation_name = "16-QAM";
        otherwise
            error("Incorrect Modulation Scheme Value (must be between 0 and 4)");
    end
    
    % Plot up to 4 standard deviations away from min of dataset. Note that
    % we assume that the modulation is symmetric across the origin
    x_lim = max(real(constellation_map)) + 4 * sqrt(noise_var);
    y_lim = max(imag(constellation_map)) + 4 * sqrt(noise_var);
    
    % We would like to keep the data square so we just take the maximum of
    % each dimension
    lim = max(x_lim,y_lim);
    [X,Y] = meshgrid(-lim:0.05:lim, -lim:0.05:lim);
    
    num_symbols = 2^m;
    
    % Plot the surface based on 2D Gaussian noise
    Z = zeros(4,size(X,1), size(X,2));
    for i=1:num_symbols
        Z(i,:,:) = 1/sqrt(2*pi)/sqrt(noise_var).*exp(-1/(2*noise_var)*((X - real(constellation_map(i))).^2 + (Y - imag(constellation_map(i))).^2));
        s = surf(X,Y,squeeze(Z(i,:,:)),'FaceAlpha',0.5);
        s.EdgeColor = 'k';
        s.LineStyle = ':';
        s.FaceLighting = 'gouraud'; 
        hold on; grid on;
        colormap(parula);
        box on;
    end
    
    title(["Conditional Probability Distributions for ", modulation_name]);
    xlabel("In-phase Signal Component");
    ylabel("Quadrature Signal Component");
    zlabel("$p(r|x,\sigma)$",'Interpreter','Latex');
    
    % Plot the contours now
    figure;
    hold on; grid on;
    for i=1:num_symbols
        contour(X,Y,squeeze(Z(i,:,:)),5);
        colormap(flipud(bone))
    end
  
    title(["Conditional Probability Distributions for ", modulation_name]);
    xlabel("In-phase Signal Component");
    ylabel("Quadrature Signal Component");
    zlabel("$p(r|x,\sigma)$",'Interpreter','Latex');
end