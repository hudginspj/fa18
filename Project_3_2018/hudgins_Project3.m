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
% N0 = [5 10 15 25 50 75 100] or, whatever you prefer
% I0 = [100 250 500 1000] or if 1000 is not enough go for more
N0 = 2;
I0 = 11;
% 
%A = arrayfun(@(x) mean(x.f1),S)
f = @tanh;
df = @(x) 1 - tanh(x)^2;
eta = 0.1;

for num_n= N0
% 		define random initial HL weighs V, and random OL weights W
    V = rand(num_n,nfeatures);
    vsize = size(V)
    W = rand(1,num_n);

%     for i = 1:length(I0) % i is an index of an epoch or a sweep through all data
%         epochs = I0(i)
    for epochs = I0
        epochs
        for epoch = 1:epochs
            epoch
            E = 0;
            for j = 1:ntrain
                x = X(j,:);
                d = Y(j);
                u = V*x';
                y = arrayfun(f,u);
                o = W*y;

                e = d-o;
                E = E + e^2;
                del_ok = e*(1-o^2);
                dW = eta*del_ok.*y';

                dV = (eta*del_ok*W)'.*arrayfun(df,u)*x;

                W = W + dW;
                V = V + dV;
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
            E
        end
    end
%     Training is over
%     here comes calculation of the error on the test data
%     give them, find outputs see errors and save in error matrix E
%     E(n,i) = 
end
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
