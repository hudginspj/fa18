% function [] = hudgins_Project3   TODOOOOOOOOOOOOOOOOOOOOOOOOOOO
close all, clear all, format compact
seed0=1;	randn('seed',seed0), rand('seed',seed0)
hold on

membership(0.9,1,0.5);

F = 40;
D = 70;
A = 100;

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

q = [70 80 90];
e = [1 2 3];
% fm1(1, 7)

% predictions = arrayfun(@(x, y) x + y, q, e)
y = [D F F D D F A D D A A D];
fmesh(@(q, e) fuzzy_eval(q, e, 4, 3, 0.5, y ), [0 100 0 10])
%fmesh(@(q, e) fm1(q, e), [0 100 0 10])
%fmesh(@(x,y) sin(x)+cos(y))
%g = arrayfun(@fm1, q, e)

% function [g] = fm1(q, e)
% %     q = 90;
% %     e = 1;
%     q_centers = [0 : 100/3 : 100];
%     e_centers = [0 : 10/2 : 10];
% %     F = 40;
% %     D = 70;
% %     A = 100;
%     y = [D,F,F,D,D,F,A,D,D,A,A,D];
%     Mq = memberships(q, q_centers, 0.5);
%     Me = memberships(e, e_centers, 0.5);
%     H = kron(Mq, Me);
%     g = (y * H') / sum(H);
% end

function [g] = fuzzy_eval(q, e, num_q_centers, num_e_centers, overlap, y)
    q_centers = [0 : 100/(num_q_centers-1) : 100];
    e_centers = [0 : 10/(num_e_centers-1) : 10];
    Mq = memberships(q, q_centers, overlap);
    Me = memberships(e, e_centers, overlap);
    H = kron(Mq, Me);
    g = (y * H') / sum(H);
end



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




