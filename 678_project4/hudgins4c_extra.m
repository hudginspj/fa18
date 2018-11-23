% function [] = hudgins_Project3   TODOOOOOOOOOOOOOOOOOOOOOOOOOOO
close all, clear all, format compact
seed0=1;	randn('seed',seed0), rand('seed',seed0)
warning('off', 'all')

global F D A
F = 40;
D = 70;
A = 100;

rules = [D F F D D F A D D A A D];
% all_plots(4, 3, 0.1, rules)
all_plots(4, 3, 0.5, rules)
% all_plots(4, 3, 0.9, rules)
rules = [A D F F F A A A D F];
% all_plots(2, 5, 0.1, rules)
% all_plots(2, 5, 0.5, rules)
% all_plots(2, 5, 0.9, rules)

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
    
    plot_mfs(q_centers, overlap, 100)
    ylabel('MF')

    subplot(1,3,2);
    plot_mfs(e_centers, overlap, 10)
    xlabel('E')
 
    subplot(1,3,3);
    plot_mfs(g_centers, overlap, 100)
    xlabel('G')
    
    figure
    fmesh(@(q, e) fuzzy_eval(q, e, q_centers, e_centers, overlap, y ), [0 100 0 10])
    xlabel('Q')
    ylabel('E')
    zlabel('G')
    pause
    close all
end

function [g] = fuzzy_eval(q, e, q_centers, e_centers, overlap, y)
    Mq = memberships(q, q_centers, overlap);
    Me = memberships(e, e_centers, overlap);
    H = kron(Mq, Me);
    g = (y * H') / sum(H);
end

function [M] = plot_mfs(centers, overlap, max_x)
    midpoint_distance = (centers(2) - centers(1))/2;
    width = midpoint_distance / (1-overlap);
    x =  [0 : 0.1: max_x];
    hold on
    for i=[1:length(centers)]
        plot(x, membership(x, centers(i), width));
    end
    ylabel('MF')
end

function [M] = memberships(input, centers, overlap)
    midpoint_distance = (centers(2) - centers(1))/2;
    width = midpoint_distance / (1-overlap);
    M = arrayfun(@(c) membership(input, c, width), centers);
end

function [m] = membership(input, center, width)
    dif = abs(input - center);
    m = max(0, 1 - (dif / width));
end




