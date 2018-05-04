% originally by david ross, included to avoid dependencies.

function r = multirnd(theta)

% if theta is a row vector, convert it to a column vector
if size(theta,1) == 1
    theta = theta';
end

n = length(theta);
theta_cdf = cumsum(theta);

r = zeros(n,1);
random_vals = rand;

r(min(find(random_vals <= theta_cdf))) = 1;

