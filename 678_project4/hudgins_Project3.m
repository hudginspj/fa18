function [] = hudgins_Project3
close all, clear all, format compact
seed0=1;	randn('seed',seed0), rand('seed',seed0)

load("cancer.mat")

X=full(X);
X=normalize(X);
shuffle_idx = randperm(length(Y));
X = X(shuffle_idx,:);
Y = Y(shuffle_idx);

ntrain = 149; ntest = 49; nfeatures = 32;

X_tra = X(1:ntrain, :);
Y_tra = Y(1:ntrain);
X_test = X(ntrain+1:end, :);
Y_test = Y(ntrain+1:end);
nclass1 = sum(Y_test<1.5)
nclass2 = sum(Y_test>1.5)

hold on
plot(X((Y==1),1), X((Y==1),5), 'ro');
plot(X((Y==2),1), X((Y==2),5), 'bo');
title('Training Data on Dimensions 1 and 5')
xlabel('x_1') 
ylabel('x_2')
figure

N0 = [5 10 15 25 50 75 100]
%N0 = [50 100]
%N0 = [5 10 15]
N0 = 15;
I0 = [100 250 500 1000]
%I0 = [10 20]
I0 = 100
% 
f = @tanh;
df = @(x) 1 - f(x)^2;
eta = 0.02;
E = []
bias = 1

for ni = 1:length(N0)
    num_n = N0(ni)
    V = rand(num_n,nfeatures);
    vsize = size(V)
    W = rand(1,num_n);
    for ei = 1:length(I0)
        epochs = I0(ei);
        for epoch = 1:epochs
            [epoch epochs num_n]
            sq_E = 0;
            for j = 1:ntrain
                x = X(j,:);
                d = Y(j);
                u = V*x';
                y = arrayfun(f,u);
                W;
                o = W*y + bias;
                if isnan(o)
                    return
                end
                e = d-o;
                sq_E = sq_E + e^2;
                %del_ok = e*(1-o^2)
                del_ok = e;
                dW = eta*del_ok.*y';
                            
                dV = (eta*del_ok*W)'.*arrayfun(df,u)*x;

                W = W + dW;
                V = V + dV;
                %pause
            end
            sq_E;
        end
        % W and V are trained
        errors = 0;
        recall1 = 0;
        recall2 = 0;
        for j = ntrain+1:length(X)
            x = X(j,:);
            d = Y(j);
            u = V*x';
            y = arrayfun(f,u);
            W;
            o = W*y + bias;
            if o > 1.5
                predicted_class = 2;
            else
                predicted_class = 1;
            end
            if predicted_class == 1 && d == 1 
                recall1 = recall1 + 1;
            elseif predicted_class == 2 && d == 2
                recall2 = recall2 + 1
            else
                errors = errors + 1;
            end
            
        end
        errors
        R1(ni,ei) = 1 - recall1/nclass1;
        R2(ni,ei) = 1 - recall2/nclass2;
        E(ni,ei) = 100 * errors/ntest;
    end
end
class_1_percentage = R1
class_2_percentage = R2
N0
I0
E
mesh(I0, N0, E);
alpha 0.5
xlabel('Iterations') 
ylabel('HL Neurons')
zlabel('Error Percentage')


