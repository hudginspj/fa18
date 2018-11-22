% function [] = hudgins_Project3   TODOOOOOOOOOOOOOOOOOOOOOOOOOOO
close all, clear all, format compact
seed0=1;	randn('seed',seed0), rand('seed',seed0)
hold on

membership(0.9,1,0.5);

%predictions = arrayfun(@(i) sign(decision(v, b, K_test(i,:)')), 1:dim(1));
% x =  [0 : 0.01: 1];
% y = membership(x, 0, 0.5)
% plot(x, membership(x, 0, 0.5))
% plot(x, membership(x, 0.5, 0.5))
% plot(x, membership(x, 1, 0.5))
% subplot(2,1,1);
% x = linspace(0,10);
% y1 = sin(x);
% plot(x,y1)
% 
% subplot(2,1,2); 
% y2 = sin(5*x);
% plot(x,y2)

memberships(0.9, [0, 0.5, 1], 0.5);
%plot_mfs([0, 0.5, 1], 0.5)


q = 90;
e = 1;
q_centers = [0 : 100/3 : 100];
e_centers = [0 : 10/2 : 10];
F = 40
D = 70
A = 100
y = [D,F,F,D,D,F,A,D,D,A,A,D]
Mq = memberships(q, q_centers, 0.5);
Me = memberships(e, e_centers, 0.5);
H = kron(Mq, Me);
o = (y * H') / sum(H)

%kron([1,2,3],[1, 10, 100])




function [M] = plot_mfs(centers, overlap)
    midpoint_distance = (centers(2) - centers(1))/2;
    width = midpoint_distance / (1-overlap);
    x =  [centers(1) : 0.01: centers(end)];
    for i=[1:length(centers)]
        plot(x, membership(x, centers(i), width));
%         M(i) = membership(input, centers(i), width)
    end
end

function [M] = memberships(input, centers, overlap)
    midpoint_distance = (centers(2) - centers(1))/2;
    width = midpoint_distance / (1-overlap);
    for i=[1:length(centers)]
        M(i) = membership(input, centers(i), width);
    end
end

function [m] = membership(input, center, width)
    dif = abs(input - center);
    m = max(0, 1 - (dif / width));
end




