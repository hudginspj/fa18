close all
format compact
hold on
rng(1, 'v4normal')

% Feature generation
X_pos = randn(20,2)*2;
X_neg = randn(10,2)*2 + [5, 5];
X = cat(1, X_pos, X_neg);

% Desired outputs generation
y = 0;
y(1:30) = 1;
y(21:30) = -1;
y = y';

% Plotting training data for part 2
plot(X_pos(1:20,1), X_pos(1:20,2), 'bo', X_neg(1:10,1), X_neg(1:10,2), 'ro')

%Part 1a, 1b     Results: 12 epochs, w = [-0.5954   -0.7314    3.1000]
X(1:30,3) = +1;
[w_part_1b, epoch_part_1a] = train(X, y, [0 0 0], 0.1);
epoch_part_1a
w_part_1b
[x1, x2] = boundary(w_part_1b);
plot(x1, x2, '-')

%Part 1d     Reults: w = -0.1338   -0.1710    0.7764
[w_part_1d] = batch_train(X, y, [0 0 0], 0.1);
w_part_1d
[x1, x2] = boundary(w_part_1d);
plot(x1, x2)

%Part 2: Creation of outlier
X(31,1:3) = [20,20,1];
y(31) = -1;
plot(20,20,'go')

%Part 2a:  Results: Same boundary and number of epochs as part 1.
% w = [-5.9543   -7.3137   31.0000] is original result times 10
[w_part_2a, epochs_part_2a] = train(X, y, [0 0 0], 1);
w_part_2a
epochs_part_2a
[x1, x2] = boundary(w_part_2a);
plot(x1, x2, 'r.')

%Part 2b
[w] = batch_train(X, y, [0 0 0], 1);
[x1, x2] = boundary(w);
plot(x1, x2)

%Part 2c
[w_part_2c] = penalty_train(X, y, [0 0 0], 1);
w_part_2c
[x1, x2] = boundary(w_part_2c);
plot(x1, x2)

% Part 3 Results with lambda = 20. 
% Cross validation is performed at the end of this script.
% w = -0.0436   -0.0915    0.3447
[w_part_3] = penalty_train(X, y, [0 0 0], 20);
w_part_3 = [-0.0436   -0.0915    0.3447]
[x1, x2] = boundary(w_part_3);
plot(x1, x2)

title('Training data and boundaries')
xlabel('x1') 
ylabel('x2')
legend({'Positive','Negative','Part 1a/1b', 'Part 1d', 'Outlier', 'Part 2a', 'Part 2b','Part 2c','Part 3'})


%Part 1c
etas = 0;
epochs = 0;
for i = 1:9
    exponent = i-5;
    etas(i) = 10^exponent;
    [w, epoch] = train(X, y, [1 1 1], etas(i));
    epochs(i) = epoch;
end
expons;
epochs;

figure()
semilogx(etas, epochs);
title('Relationship between eta and training epochs')
xlabel('Eta') 
ylabel('Epochs')


%Part 3: Cross validation for many values of lambda
lambdas = 0;
errors = 0;
for i = 1:500
    lambdas(i) = i/10;
    errors(i) = xval(X,y,lambdas(i));
end
lambdas;
errors;

figure()

plot(lambdas, errors);
title('Cross-validation Results')
xlabel('Lambda') 
ylabel('Errors')


% Cross-validation test for given lambda
function [errors] = xval(X, y, lambda)
    indices = crossvalind('Kfold',31,10);
    errors = 0;
    for i = 1:10
       test = (indices == i);
       tra = ~test;
       [w] = penalty_train(X(tra,:), y(tra,:), [0,0,0], lambda);
       pred = arrayfun(@(x) sign(x), X(test,:) * w');
       y(test);
       dif = pred - y(test);
       errors = errors + sum(dif.*dif)/4;
    end
end

%Helper function to plot boundaries
function [x1, x2] = boundary(w)
    x1 = -5:10;
    x2 =  arrayfun(@(x) (-w(1)*x/w(2)) - w(3)/w(2),-5:10);
end

% Iterative Perceptron
function [w, epoch] = train(X, y, w, eta)
    e = 1;
    epoch = 0;
    while any(e)
        epoch = epoch + 1;
        e = 0;
        for p = 1:30
            x = X(p,1:3);
            u = x * w';
            o = sign(u);
            e(p) = y(p) - o;
            w = w + eta * e(p) * x;
        end
    end
end

% Batch perceptron
function [w] = batch_train(X, y, w, eta)
    w = (pinv(X) * y)';

end

% Regularized perceptrion
function [w] = penalty_train(X, y, w, lambda)
    w = inv(X' * X + lambda * eye(3)) * (X' * y);
    w = w';
end
