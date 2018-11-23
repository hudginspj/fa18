close all, clear all, format compact
warning('off', 'all')

global F D C B A
F = 40; D = 55; C = 70; B = 85; A = 100;


%%%%%%%%%%   WHEN RUNNING: Press any key to advance to next case   %%%%%%%
rules = [C D F B C D A B C A A B];
all_plots(4, 3, 0.1, rules)
all_plots(4, 3, 0.5, rules)
all_plots(4, 3, 0.9, rules)

rules = [C D D F F A A B B C];
all_plots(2, 5, 0.1, rules)
all_plots(2, 5, 0.5, rules)
all_plots(2, 5, 0.9, rules)
 
rules = [D C B F D C C B A D C B];
all_plots_extra(2, 2, 0.5, rules);



%%%%%% Generates all plots for a given case %%%%%%%%%%%
function all_plots(num_q_centers, num_e_centers, overlap, y)
    global F D C B A
    g_centers = [F D C B A];
    q_centers = [0 : 100/(num_q_centers-1) : 100];
    e_centers = [0 : 10/(num_e_centers-1) : 10];
    
    subplot(1,3,1);
    plot_triangles(q_centers, overlap, 100)
    xlabel('Q')

    subplot(1,3,2);
    plot_triangles(e_centers, overlap, 10)
    xlabel('E')
 
    subplot(1,3,3);
    plot_singletons(g_centers, 100)
    xlabel('G')
    
    %saveas(gcf,strcat('MF', num2str(num_e_centers), num2str(overlap), '.png'))
    figure
    
    fmesh(@(q, e) fuzzy_eval(q, e, q_centers, e_centers, overlap, y), [0 100 0 10])
    xlabel('Q')
    ylabel('E')
    zlabel('G')
    
    %saveas(gcf,strcat('Surf', num2str(num_e_centers), num2str(overlap), '.png'))
    pause; close all;
end

%%%%%% Implementation %%%%%%%%%

function [g] = fuzzy_eval(q, e, q_centers, e_centers, overlap, y)
    Mq = memberships(q, q_centers, overlap);
    Me = memberships(e, e_centers, overlap);
    H = kron(Mq, Me);
    g = (y * H') / sum(H);
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

%%%%%% Plotting of Membership Functions %%%%%%%%%

function [M] = plot_triangles(centers, overlap, max_x)
    midpoint_distance = (centers(2) - centers(1))/2;
    width = midpoint_distance / (1-overlap);
    x =  [0 : 0.1: max_x];
    hold on
    for i=[1:length(centers)]
        plot(x, membership(x, centers(i), width));
    end
    ylabel('MF')
end

function [M] = plot_singletons(centers, max_x)
    hold on
    for c=centers
        plot([c c], [0 1]);
    end
    xlim([0 100])
    ylabel('MF')
end

%%%%%%%%%%% Extensions to handle F %%%%%%%%%%%%%

function all_plots_extra(num_q_centers, num_e_centers, overlap, y)
    global F D C B A
    g_centers = [F D C B A];
    q_centers = [0 : 100/(num_q_centers-1) : 100];
    e_centers = [0 : 10/(num_e_centers-1) : 10];
    f_centers = [50, 75, 100];
    
    subplot(1,4,1);
    plot_triangles(q_centers, overlap, 100)
    xlabel('Q')

    subplot(1,4,2);
    plot_triangles(e_centers, overlap, 10)
    xlabel('E')
    
    subplot(1,4,3);
    plot_triangles(f_centers, overlap, 100)
    xlabel('F')
 
    subplot(1,4,4);
    plot_singletons(g_centers, 100)
    xlabel('G')
    %saveas(gcf,strcat('MF_extra.png'))
    figure
    
    subplot(1,3,1);
    fmesh(@(q, e) fuzzy_eval_extra(q, e, 50, q_centers, e_centers, f_centers, overlap, y), [0 100 0 10])
    xlabel('Q'); ylabel('E'); zlabel('G'); title('F = 50')
    
    subplot(1,3,2);
    fmesh(@(q, e) fuzzy_eval_extra(q, e, 75, q_centers, e_centers, f_centers, overlap, y), [0 100 0 10])
    xlabel('Q'); ylabel('E'); zlabel('G'); title('F = 75')
    
    subplot(1,3,3);
    fmesh(@(q, e) fuzzy_eval_extra(q, e, 100, q_centers, e_centers, f_centers, overlap, y), [0 100 0 10])
    xlabel('Q'); ylabel('E'); zlabel('G'); title('F = 100')
    %saveas(gcf,strcat('Surf_extra.png'))
    
    pause; close all
end

function [g] = fuzzy_eval_extra(q, e, f, q_centers, e_centers, f_centers, overlap, y)
    Mq = memberships(q, q_centers, overlap);
    Me = memberships(e, e_centers, overlap);
    Mf = memberships(f, f_centers, overlap);
    H = kron(Mq, Me);
    H = kron(H, Mf);
    g = (y * H') / sum(H);
end



