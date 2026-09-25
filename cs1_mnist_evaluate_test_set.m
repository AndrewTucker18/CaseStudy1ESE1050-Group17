%% This code evaluates the test set.

% ** Important.  This script requires that:
% 1)'centroid_labels' be established in the workspace
% AND
% 2)'centroids' be established in the workspace
% AND
% 3)'test' be established in the workspace


% IMPORTANT!!:
% You should save 1) and 2) in a file named 'classifierdata.mat' as part of
% your submission.

predictions = zeros(200,1);
outliers = zeros(200,1);
testGroupings = zeros(200,1);
testDistances = zeros(200,2);
% loop through the test set, figure out the predicted number
for i = 1:200

testing_vector=test(i,:);

% Extract the centroid that is closest to the test image

[vec_distance,prediction_index] = assign_vector_to_centroid(testing_vector, centroids);
testGroupings(i) = prediction_index;
predictions(i) = centroid_labels(prediction_index);
testDistances(i) = vec_distance;
end

%% DESIGN AND IMPLEMENT A STRATEGY TO SET THE outliers VECTOR
% outliers(i) should be set to 1 if the i^th entry is an outlier
% otherwise, outliers(i) should be 0


[sortedDistances,indexes] = sort(testDistances,"descend");


figure;
colormap('gray');
n = 0

% Plots 11 test outliers  for visual reference
for i=1:11
plotsize = ceil(sqrt(11));
n = n+1
ind=indexes(i)

    e = test(ind,[1:784]);
    subplot(plotsize,plotsize,n);

    imagesc(reshape(e,[28 28])');
    title(strcat("Outlier ",num2str(ind)))

end

% Takes the minimum distance of all the outliers, which is the 11th row of
% sorted distances, and sets that as the bar for a new image set. If the
% distance for a new image is greater than this minimum bar, then that
% image is classified as an outlier. 
for j = 1:200 
    if (sortedDistances(11) <= testDistances(j))
            outliers(j) = 1;
    end   
end


%% MAKE A STEM PLOT OF THE OUTLIER FLAG
figure;
stem(outliers);

%% The following plots the correct and incorrect predictions
% Make sure you understand how this plot is constructed
figure;
plot(correctlabels,'o');
hold on;
plot(predictions,'x');
title('Predictions');

%% The following line provides the number of instances where and entry in correctlabel is
% equatl to the corresponding entry in prediction
% However, remember that some of these are outliers

correct_percentage = sum(correctlabels == predictions)/200 * 100





function [vec_distance, index] = assign_vector_to_centroid(data,centroids)

%Initializes vector that will store all the distances from each centroid to
%the particular "data" vector 
centroidDistance = zeros(size(centroids,1),1);
%Loops through all the centroids 
for j = 1:size(centroids,1)
% Recreating formula on page 95 of textbook, finds the difference
% between a single image and all its 784 dimensions and one of the centroids and all its 784 dimensions. 
    centroidDistance(j) = power(norm(data(1:784)-centroids(j,1:784)),2);    
end
% returns minimum centroid distance and the index of that centroid
[vec_distance,index] = min(centroidDistance);
end
