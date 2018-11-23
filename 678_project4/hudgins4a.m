% function [] = hudgins_Project3   TODOOOOOOOOOOOOOOOOOOOOOOOOOOO
close all, clear all, format compact
seed0=1;	randn('seed',seed0), rand('seed',seed0)
hold on

global F D A
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


%plot_mfs([0, 0.5, 1], 0.5)

%y = [D F F D D F A D D A A D];
%fmesh(@(q, e) fuzzy_eval(q, e, 4, 3, 0.5, y ), [0 100 0 10])
all_plots(4, 3, 0.5, [D F F D D F A D D A A D])

function all_plots(num_q_centers, num_e_centers, overlap, y)
    global F D A
    g_centers = [F D A];
    q_centers = [0 : 100/(num_q_centers-1) : 100];
    e_centers = [0 : 10/(num_e_centers-1) : 10];
    
    
    
    subplot(1,3,1);
    x = linspace(0,10);
    y1 = sin(x);
    y1b = sin(x)+0.5;
    y1c = sin(x)+0.1;
    
    hold on
%     plot(x,y1)
%     plot(x,y1b)
%     plot(x,y1c)
    plot_mfs(q_centers, overlap, 100)
    xlabel('Q') 
    ylabel('MF')
    %title('MF for ')

    subplot(1,3,2);
    plot_mfs(e_centers, overlap, 10)
    xlabel('E')
%     y2 = sin(5*x);
%     plot(x,y2)
%     
    subplot(1,3,3);
    plot_mfs(g_centers, overlap, 100)
    xlabel('G')
%     y3 = sin(5*x);
%     plot(x,y3)
    
    %fmesh(@(q, e) fuzzy_eval(q, e, q_centers, e_centers, 0.5, y ), [0 100 0 10])
end



function [g] = fuzzy_eval(q, e, q_centers, e_centers, overlap, y)
%     q_centers = [0 : 100/(num_q_centers-1) : 100];
%     e_centers = [0 : 10/(num_e_centers-1) : 10];
    Mq = memberships(q, q_centers, overlap);
    Me = memberships(e, e_centers, overlap);
    H = kron(Mq, Me);
    g = (y * H') / sum(H);
end


function [M] = plot_mfs(centers, overlap, max_x)
    midpoint_distance = (centers(2) - centers(1))/2;
    width = midpoint_distance / (1-overlap);
    x =  [0 : 0.01: max_x];
    hold on
    for i=[1:length(centers)]
        plot(x, membership(x, centers(i), width));
%         M(i) = membership(input, centers(i), width)
    end
    ylabel('MF')
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




