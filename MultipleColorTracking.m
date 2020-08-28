%% MultipleColorTracking.m
% This script based on work done by Alireza Asvadi, MohammadReza Karami and Yasser Baleghi
% is a tracking algorithm for multiple objects using color
%% Original Source
% This code is a Matlab implementation of the tracking algorithm described in:
% 'Object Tracking Using Adaptive Object Color Modeling'
% in Proceedings of the 4th conference on information and knowledge
% technology (IKT2012), Babol, Iran, May 2012.
% Author: Alireza Asvadi, MohammadReza Karami and Yasser Baleghi
%% the options that should be set are:
%  obj (input video address, default is test.avi)                [line 24]
%  sf  (strat frame for tracking, default for test.avi is 1)     [line 26]
%  ef  (end frame for tracking, default for test.avi is 200)     [line 27]
%  Bin (number of bins for each color chanal)                    [line 28]
%  or  (select object region in first frame, default for test.avi is [67,405,43,80]) [line 33]
%  Threshold for Object Model Update (default is (0.05 * 256))   [line 51]
%  mi  (maximum mean-shift iteration, default is 5)              [line 57]
%  Delta (Threshold for centroid movement to consider as a complete convergence,Here less than 2 pixels) [line 71]
%  Object center locations are saved in output.mat               [line 92]
%% clear memory & command window
clc
clear variables
close all
%% initialize
obj = VideoReader('REPLACEME');                         % Select Video File
tfn = get(obj, 'NumFrames');                       % Total Frame Numbers
sf  = 1;                                               % Start Frame For Tracking
ef  = tfn;                                             % End Frame For Tracking
Bin = 8;
img = read(obj, sf);
% img = obj.read();                                    % Get First Frame
output1 = zeros(ef-sf+1, 2);                             % Centroid Locations
output2 = zeros(ef-sf+1, 2);
figure(1); imshow(img)                                 % Show First Frame & Wait Till Select The Object
or1 = round(getrect(figure(1)));                       % Coded Rect [xmin(col),ymin(row),width,height]
or2 = round(getrect(figure(1)));
%or  = [67, 405, 43, 80];
CD1  = round([or1(2)+or1(4)/2 or1(1)+or1(3)/2]);            % Object Centroid
CD2  = round([or2(2)+or2(4)/2 or2(1)+or2(3)/2]);
% close Figure 1
%% object/background separation & tracking

for fn = sf:ef
  img = read(obj, fn);                                    % Read Frame
  [Si1, Sb1, So1] = SearchArea(img, or1);                            % Search Area
  [Si2, Sb2, So2] = SearchArea(img, or2);
  I   = Quantization(img, Bin);                                    % Quantize

  % build & update object model
  if fn == sf                                              % Object Model in First Frame
    SD1  = LogLikelihoodRatio(I, Si1, Sb1, Bin);                                % Object Seeds
    SD2  = LogLikelihoodRatio(I, Si2, Sb2, Bin);
    M1   = map(I, SD1, So1);                                    % Detected Object
    M2   = map(I, SD2, So2);
    ac1  = avcol(img, M1);                                    % Average Color
    ac2  = avcol(img, M2);
    elseif fn ~= sf                                        % Temporary Object Model for Current Frame
    SDt1 = LogLikelihoodRatio(I, Si1, Sb1, Bin);                                % Temporary Object Seeds
    Mt1  = map(I, SDt1, So1);                                   % Temporary Detected Object
    act1 = avcol(img, Mt1);                                   % Temporary Average Color
    SDt2 = LogLikelihoodRatio(I, Si2, Sb2, Bin);                                % Temporary Object Seeds
    Mt2  = map(I, SDt2, So2);                                   % Temporary Detected Object
    act2 = avcol(img, Mt2);
    if abs(ac1 - act1) > (0.05 * 256)                        % Check for Model Update
      SD1  = SDt1;                                           % Update Object Model
      ac1  = act1;                                           % Update Average Color
    end
    if abs(ac2 - act2) > (0.05 * 256)
      SD2  = SDt2;
      ac2  = act2;
    end
  end

  % detection
  for mi = 1:5                                             % mean-shift iteration
    M1   = map(I, SD1, So1);                                    % Detected Object
    M2   = map(I, SD2, So2);
    % centroid
    CDp1 = CD1;                                              % Primary Object Centroid
    CDp2 = CD2;
    [Cnr1, Cnc1, v1] = find(M1 ~= 0);                            % Find Object Pixels
    [Cnr2, Cnc2, v2] = find(M2 ~= 0);
    R1   = sum(Cnr1);
    C1   = sum(Cnc1);
    n1   = sum(v1);
    R2   = sum(Cnr2);
    C2   = sum(Cnc2);
    n2   = sum(v2);
    if n1 == 0                                              % NaN Resistance
      CD1  = CDp1;
    else                                                   % Object Centroid
      CD1  = round([C1/n1 R1/n1]);
    end

    if n2 == 0                                              % NaN Resistance
      CD2  = CDp2;
    else                                                   % Object Centroid
      CD2  = round([C2/n2 R2/n2]);
    end

    or1  = round([CD1(1)-or1(3)/2 CD1(2)-or1(4)/2 or1(3) or1(4)]);% Move Rectangle center to New Centroid
    Delta1 = norm(CD1 - CDp1);                                % Calculate Movement(Difference in centers)
    if Delta1 < 2                                           % If Centroid Does not change Break
       break
    end
    or2  = round([CD2(1)-or2(3)/2 CD2(2)-or2(4)/2 or2(3) or2(4)]);% Move Rectangle center to New Centroid
    Delta2 = norm(CD2 - CDp2);                                % Calculate Movement(Difference in centers)
    if Delta2 < 1                                           % If Centroid Does not change Break
       break
    end
  end

  output1(fn-sf+1,:) = CD1;
  output2(fn-sf+1,:) = CD2;
  % show
  Im = im2double(img);
  Oi1 = M1(or1(2)+1:or1(2)+or1(4), or1(1)+1:or1(1)+or1(3));
  Im(1:or1(4),1:or1(3),:) = double(cat(3, Oi1, Oi1, Oi1));
  imshow(Im)
  Im = im2double(img);
  Oi2 = M2(or2(2)+1:or2(2)+or2(4), or2(1)+1:or2(1)+or2(3));
  Im(1:or2(4),1:or2(3),:) = double(cat(3, Oi2, Oi2, Oi2));
  imshow(Im)
  hold on
  title([num2str(fn-sf+1), '/', num2str(ef-sf+1)]);
  rectangle('Position', [or1(1),or1(2),or1(3),or1(4)], 'LineWidth', 3,'EdgeColor', 'g');
  plot(output1(1:fn-sf+1,1), output1(1:fn-sf+1,2), 'g', 'LineWidth', 2,'LineStyle', '--')
  rectangle('Position', [or2(1),or2(2),or2(3),or2(4)], 'LineWidth', 3,'EdgeColor', 'r');
  plot(output2(1:fn-sf+1,1), output2(1:fn-sf+1,2), 'r', 'LineWidth', 2,'LineStyle', '--')
  hold off
  pause(0.01)
end

save Output1.mat output1
save Output2.mat output2
