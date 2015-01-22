function STD_DEV = findGaussianWidth(REGION_LENGTH, EFFECTIVE_LENGTH, AREA_ERROR_TOLERANCE)
% FINDGAUSSIANWIDTH determines the standard deviation of a normalized Gaussian function whose
% area is approximately equal to that of a top-hat function of the desired
% effective window resolution. 
% 
% John says that the volume under a this Gaussian window will not be
% exactly the volume under the square window. Check into this.
% 
% INPUTS
%      REGION_LENGTH = Length of the domain in pixels
%
%      EFFECTIVE_LENGTH = Effective window resolution in pixels
%
%       AREA_ERROR_TOLERANCE (optional) = Maximum allowable difference 
%           (in pixels) between the integrated area of the Gaussian
%           function and the area of a rectangular unit tophat function
%           whose length extends over REGION_LENGTH pixels.
%           Theh default value of AREA_ERROR_TOLERANCE to 1E-5.
% 
% OUTPUTS
%       STD_DEV = standard deviation of a normalized Gaussian function 
%           whose area, integrated over the domain (REGION_LENGTH), is 
%           equal (to within AREA_ERROR_TOLERANCE) to that of a unit tophat
%           function whose length extends over REGION_LENGTH pixels.
%           The units of STD_DEV are pixels.
% 
% EXAMPLE
%       REGION_LENGTH = 128;
%       EFFECTIVE_LENGTH = 64;
%       STD_DEV = findGaussianWidth(REGION_LENGTH, EFFECTIVE_LENGTH);
% 
% SEE ALSO
%   trapz

% Default to an area error tolerance of 1E-5.
if nargin < 3
    AREA_ERROR_TOLERANCE = 1E-5;
end

% Initialize the guess of the Gaussian standard deviaiton.
STD_DEV = 50 * EFFECTIVE_LENGTH;

% Generate the domain over which the Gaussian function will be evaluated.
x = - REGION_LENGTH / 2 : REGION_LENGTH / 2;

% Generate normalized zero-mean Gaussian window 
gaussian_function = exp(-(x).^2 / (2 * STD_DEV^2));

% Calculate areas under gaussian curves
gaussian_area = trapz(x, gaussian_function);

% Proceed only if the specified effective length is less than the 
% area of the equivalent tophat function; otherwise preserve the 
% original (large) guess of the Gaussian standard deviation. 
if EFFECTIVE_LENGTH < gaussian_area

    % Calculate initial errors of Gaussian windows with respect to desired
    % effective window resolution
    area_error = abs(1 - gaussian_area / EFFECTIVE_LENGTH);

    % Initialize max and min values of standard deviation
    % for the Gaussian function
    std_dev_max = 100 * REGION_LENGTH;
    std_dev_min = 0;
    
    % Iteratively calculate the standard deviation that gives the desired
    % effective Gaussian area
    
    % Loop while the error of area under curve is above the specified error tolerance
    while area_error > AREA_ERROR_TOLERANCE
        
        %  If the area under the Gaussian curve is less than that of the top-hat window
        if gaussian_area < EFFECTIVE_LENGTH
            % Increase the lower bound on the standard deviation
            std_dev_min = std_dev_min + (std_dev_max - std_dev_min) / 2;
        else
            % Otherwise, increase the upper bound on the standard deviation
            std_dev_max =  std_dev_min + (std_dev_max - std_dev_min) / 2;
        end

        % Set the standard deviation to halfway between its lower and upper bounds
        STD_DEV = std_dev_min + (std_dev_max - std_dev_min) / 2;

        % Generate a Gaussian curve with the specified standard deviation
        gaussian_function = exp(-(x).^2 / (2 * STD_DEV^2));

        % Calculate the area under this Gaussian curve via numerical
        % integration using the Trapezoidal rule
        gaussian_area = trapz(x, gaussian_function);

        % Calculate the error of the area under the Gaussian curve with
        % respect to the desired area 
        area_error = abs(1 - gaussian_area / EFFECTIVE_LENGTH);
    
    end % end "while area_error > AREA_ERROR_TOLERANCE" 
    
end % End "if EFFECTIVE_LENGTH < gaussian_area" 

end % End of function








