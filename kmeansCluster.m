function [ ssd, cluster ] = kmeansCluster( data, noOfCluster, method )
%K-Means Cluster - Simple k means clustering algorithm
%   Purpose: classify the objects in data matrix based on the attributes
%   Criteria: minimize Euclidean distance between centroids and object points
%   Input : 1) data: input data (mxp) double
%           2) noOfCluster: number of cluster (integer)
%           3) method: distance method to be used to find similar data point ('euclidean' or 'spearman')
%   Output: 1) ssd: 1xN double matrix with sum of squared distances for each iteration
%              N = No of Iteration
%           2) cluster: (mx1) double matrix indicating which index falls in
%              which cluster, here m = no of row of data in input
%   Local variables:
%       1) oldCentoid: (noOfCluster x p) double matrix for old centroid in
%       each iteration, here p = no of rows in input data
%       2) intermediateCentoid: (noOfCluster x p) double matrix for intermediate centroid in
%       each iteration, here p = no of rows in input data
%       3) newCentoid: (noOfCluster x p) double matrix for new centroid in
%       each iteration, here p = no of rows in input data
%       4) clusterMse: (noOfCluster x N) doouble matrix, stores SSD for each
%       cluster at each iteration. Here N = no of Iteration
%       5) rIdx: an integer to track the index number in each iteration
%       6) minDist: dataPoints with minimum distance from cluster centroid
% cluster = zeros(size(data, 1), 1);
% minDist = zeros(size(data, 1), 1);
intermediateCentoid = datasample(data, noOfCluster); % centroids
newCentoid = zeros(noOfCluster, size(data, 2));
clusterMse = zeros(noOfCluster, 1); % this stores Mean square Distance from centroids (For each cluster)
rIdx = 1;
while(true)
    oldCentoid = intermediateCentoid;
    distMat = pdist2(data, oldCentoid, method);
    [minDist, cluster] = min(distMat, [], 2); % finds the minimum distance and corresponding index
    for i = 1:noOfCluster
        % for each new cluster below code calculates new centroid
        newCentoid(i, :) = mean(data(cluster == i, :), 1);
        clusterMse(i, rIdx) = sum((minDist(cluster == i)).^2);
    end
    clear i
    intermediateCentoid = newCentoid;
    rIdx = rIdx + 1;
    % below conditions checks if all centroid are moving or not, if not
    % then break
    if sum(sum((newCentoid - oldCentoid) == 0)) == size(oldCentoid, 1) * size(oldCentoid, 2)
        break;
    end
    if rIdx == 101
        disp('While loop is on infinite loop breaking at 100th loop')
        break;
    end
end
ssd = sum(clusterMse, 1); % double array for sum of square distance
end