function [] = hudgins_Project3
close all, clear all, format compact
seed0=1;	randn('seed',seed0), rand('seed',seed0)

load("cancer.mat")

X=full(X);
X=normalize(X);
shuffle_idx = randperm(length(Y));
X = X(shuffle_idx,:);
Y = Y(shuffle_idx);

ntrain = 149;
ntest = 49;
nfeatures = 32;
X_tra = X(1:ntrain, :);
Y_tra = Y(1:ntrain);
X_test = X(ntrain+1:end, :);
Y_test = Y(ntrain+1:end);

size(X)
% plot data inputs
% plot outputs as circle to 
% scale the input if you think it is needed
% create train and test set
% find numb of train data and call in ntrain, same for ntest
% 
%N0 = [5 10 15 25 50 75 100]% or, whatever you prefer
N0 = [5 10 15 25]
%N0 = 25;
%I0 = [100 250 500 1000]% or if 1000 is not enough go for more
I0 = [10 20 50 100]
%I0 = 100; %11;
% 
%A = arrayfun(@(x) mean(x.f1),S)
f = @tanh;
df = @(x) 1 - f(x)^2;
eta = 0.01;
E = []
for ni = 1:length(N0)
    num_n = N0(ni)
% 		define random initial HL weighs V, and random OL weights W
    V = rand(num_n,nfeatures);
    vsize = size(V)
    W = rand(1,num_n);

%     for i = 1:length(I0) % i is an index of an epoch or a sweep through all data
%         epochs = I0(i)
    for ei = 1:length(I0)
        epochs = I0(ei)
        epochs %#ok<*NOPRT>
        for epoch = 1:epochs
            epoch
            sq_E = 0;
            for j = 1:ntrain
                x = X(j,:);
                d = Y(j);
                u = V*x';
                y = arrayfun(f,u);
                W;
                o = W*y;
                if isnan(o)
                    return
                end
                e = d-o;
                sq_E = sq_E + e^2;
                %del_ok = e*(1-o^2)
                del_ok = e;%(1-o^2)
                dW = eta*del_ok.*y';
                max_dw = max(dW);
                min_dw = min(dW);
                
                
                dV = (eta*del_ok*W)'.*arrayfun(df,u)*x;
%                 dVa = (eta*del_ok*W)'
%                 dVb = arrayfun(df,u)
%                 dV2 = dVa.*dVb*x

                W = W + dW;
                V = V + dV;
                %pause
                
% 			input is X(j,,:)
% 				here comes your learning code which basically implements the algorithm as given in the table and example
% 
% 				you take your first data point and    
% 	    	here you calculate inputs to HL neurons, their outputs and derivatives of AF at each neuron
% 	    	input(s) to OL neuron and its output
% 	    	error_at OL neuron for a given input data
% 	    	
% 	    	EBP part comes below now
% 	    	
% 	    	delta signal for OL neuron
% 	    	delta signals for HL neurons
% 	    	
% 	    	update OL and HL weights
            end
            sq_E
        end
        %W is trained
        errors = 0;
        for j = ntrain+1:length(X)
            x = X(j,:);
            d = Y(j);
            u = V*x';
            y = arrayfun(f,u);
            W;
            o = W*y;
            if o > 1.5
                predicted_class = 2;
            else
                predicted_class = 1;
            end
            if predicted_class ~= d
                errors = errors + 1;
                predicted_class;
                d;
            end
            
        end
        errors
        accuracy = 1 - (errors/ntest)
        E(ni,ei) = accuracy
                
        
    end
%     Training is over
%     here comes calculation of the error on the test data
%     give them, find outputs see errors and save in error matrix E
%     E(n,i) = 
end
E
mesh(N0, I0, E)
% 
% find best numb of neurons and best numb of iterations.
% plotting etc
% 
% 
% % in real life you would now go an and design (i.e., retrain) your multilayer perceptron on all the data by using the best numbers
% % and your NN is designed
% 
% 
% 

% function [class] = predict(W, V, x)
%     
% end
