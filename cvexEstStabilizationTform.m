function H = cvexEstStabilizationTform(leftI,rightI,ptThresh)
%Get inter-image transform and aligned point features.
%  H = cvexEstStabilizationTform(leftI,rightI) returns an affine transform
%  between leftI and rightI using the |estimateGeometricTransform|
%  function.
%
%  H = cvexEstStabilizationTform(leftI,rightI,ptThresh) also accepts
%  arguments for the threshold to use for the corner detector.

% Copyright 2010 The MathWorks, Inc.

% Set default parameters
if nargin < 3 || isempty(ptThresh)
    ptThresh = 0.1;
end

%% Generate prospective points
pointsA = detectFASTFeatures(leftI, 'MinContrast', ptThresh);
pointsB = detectFASTFeatures(rightI, 'MinContrast', ptThresh);

%% Select point correspondences
% Extract features for the corners
[featuresA, pointsA] = extractFeatures(leftI, pointsA);
[featuresB, pointsB] = extractFeatures(rightI, pointsB);

% Match features which were computed from the current and the previous
% images
indexPairs = matchFeatures(featuresA, featuresB);
pointsA = pointsA(indexPairs(:, 1), :);
pointsB = pointsB(indexPairs(:, 2), :);

%% Use MSAC algorithm to compute the affine transformation
tform = estimateGeometricTransform(pointsB, pointsA, 'affine');
H = tform.T;
