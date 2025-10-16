
clc

figure('Visible', 'off','units','normalized','outerposition',[0 0 1 1])
%figure('units','normalized','outerposition',[0 0 1 1])


clear area_all
option=2;

color_ssp585 = [115, 31, 30] / 255;
color_ssp126 = [60, 136, 167] / 255;
color_ssp245 = [0.928 0.572 0.172];
color_ssp370 = [223, 0, 0] / 255;

if r < 20
    subplot(2,2,1)
    years_all = zeros(3,size(area_tot_15,1));
    for all = 1:4
        if all == 1
            areas = year_no_15_mean(r, :,1)';
            areas = areas(areas > 0);
            A = squeeze(year_no_15_mean_result(r,1:size(area_tot_15,1),:));
            A = sort(A,2);
            years = A(:,round(size(A,2)/2));
            idx = find(isnan(years));
            area_years = area_tot_15(idx,:,end);
            area_years = nanmedian(area_years,2);
        elseif all == 2
            areas = year_no_20_mean(r, :,1)';
            areas = areas(areas > 0);
            A = squeeze(year_no_20_mean_result(r,1:size(area_tot_15,1),:));
            A = sort(A,2);
            years = A(:,round(size(A,2)/2));
            idx = find(isnan(years));
            area_years = area_tot_20(idx,:,end);
            area_years = nanmedian(area_years,2);
        elseif all == 3
            areas = year_no_27_mean(r, :,1)';
            areas = areas(areas > 0);
            A = squeeze(year_no_27_mean_result(r,1:size(area_tot_15,1),:));
            A = sort(A,2);
            years = A(:,round(size(A,2)/2));
            idx = find(isnan(years));
            area_years = area_tot_27(idx,:,end);
            area_years = nanmedian(area_years,2);
        elseif all == 4
            areas = year_no_40_mean(r, :,1)';
            areas = areas(areas > 0);
            A = squeeze(year_no_40_mean_result(r,1:size(area_tot_15,1),:));
            A = sort(A,2);
            years = A(:,round(size(A,2)/2));
            idx = find(isnan(years));
            area_years = area_tot_40(idx,:,end);
            area_years = nanmedian(area_years,2);
        end
        years_all(all,:) = years;
        area_all(all,1:size(area_years,1)) = area_years;
    end
    years_all = years_all';
    area_all(area_all == 0) = nan;
else
    years_all = zeros(3,216535);
    for all = 1:4
        if all == 1
            A2D = reshape(year_no_15_mean, [], size(year_no_15_mean, 3));            
            idx_zero = find(A2D(:,1) == 0);
            A2D(idx_zero,:) = [];
            areas = A2D(:,1);
            A2D = reshape(year_no_15_mean_result, [], size(year_no_15_mean_result, 3));            
            idx_zero = find(A2D(:,1) == 0);
            A2D(idx_zero,:) = [];
            years = A2D(:,round(size(A2D,2)/2));
            q2 = sum(initial_glaciers(:,1:19));
            idx = find(isnan(years(1:q2)));
            area_years = [];
            for q3 = 1:19
                area_years = [area_years, year_no_15_mean_eoc(q3,1:initial_glaciers(:,q3))];
            end
            area_years = area_years(idx);
        elseif all == 2
            A2D = reshape(year_no_20_mean, [], size(year_no_20_mean, 3));            
            idx_zero = find(A2D(:,1) == 0);
            A2D(idx_zero,:) = [];
            areas = A2D(:,1);
            A2D = reshape(year_no_20_mean_result, [], size(year_no_20_mean_result, 3));            
            idx_zero = find(A2D(:,1) == 0);
            A2D(idx_zero,:) = [];
            years = A2D(:,round(size(A2D,2)/2));
            q2 = sum(initial_glaciers(:,1:19));
            idx = find(isnan(years(1:q2)));
            area_years = [];
            for q3 = 1:19
                area_years = [area_years, year_no_20_mean_eoc(q3,1:initial_glaciers(:,q3))];
            end
            area_years = area_years(idx);
        elseif all == 3
            A2D = reshape(year_no_27_mean, [], size(year_no_27_mean, 3));            
            idx_zero = find(A2D(:,1) == 0);
            A2D(idx_zero,:) = [];
            areas = A2D(:,1);
            A2D = reshape(year_no_27_mean_result, [], size(year_no_27_mean_result, 3));            
            idx_zero = find(A2D(:,1) == 0);
            A2D(idx_zero,:) = [];
            years = A2D(:,round(size(A2D,2)/2));
            q2 = sum(initial_glaciers(:,1:19));
            idx = find(isnan(years(1:q2)));
            area_years = [];
            for q3 = 1:19
                area_years = [area_years, year_no_27_mean_eoc(q3,1:initial_glaciers(:,q3))];
            end
            area_years = area_years(idx);
        elseif all == 4
            A2D = reshape(year_no_40_mean, [], size(year_no_40_mean, 3));            
            idx_zero = find(A2D(:,1) == 0);
            A2D(idx_zero,:) = [];
            areas = A2D(:,1);
            A2D = reshape(year_no_40_mean_result, [], size(year_no_40_mean_result, 3));            
            idx_zero = find(A2D(:,1) == 0);
            A2D(idx_zero,:) = [];
            years = A2D(:,round(size(A2D,2)/2));
            q2 = sum(initial_glaciers(:,1:19));
            idx = find(isnan(years(1:q2)));
            area_years = [];
            for q3 = 1:19
                area_years = [area_years, year_no_40_mean_eoc(q3,1:initial_glaciers(:,q3))];
            end
            area_years = area_years(idx);
        end
        years_all(all,:) = years;
        area_all(all,1:size(area_years,2)) = area_years;
    end
    years_all = years_all';
    area_all(area_all == 0) = nan;
end

% Define bin edges (left and right edges of each bar)
edges = [0, logspace(log10(1e-3), log10(1000), 100), 10000];

% Filter for glaciers that disappear < 2025
areas(years < 2025) = nan;

% Define bar heights (e.g., total values in each bin)
%heights_now = [];
for q = 2:size(edges,2)-2
    idx_area = find(areas > edges(q-1) & areas < edges(q));
    heights_now(r,q) = size(idx_area,1);  % one fewer than edges
    for all = 1:4
        a = find(isnan(years_all(idx_area,all)));
        if ~isempty(a)
            heights_fut(r,q,all) = size(a,1);
        else
            heights_fut(r,q,all) = 0;
        end
        area_fut = area_all(all,:);
        idx_area2 = find(area_fut > edges(q-1) & area_fut < edges(q));
        heights_fut_area(r,q, all) = size(idx_area2,2);  % one fewer than edges
    end
end

% Compute bin centers and widths
centers = (edges(1:end-1) + edges(2:end)) / 2;
widths = edges(2:end) - edges(1:end-1);

hold on

for i = 1:size(heights_now,2)
    x0 = edges(i);
    w = widths(i);
    h = heights_now(r,i);
    rectangle('Position', [x0, 0, w, h], ...
              'EdgeColor', 'k', 'FaceColor', 'none', 'LineWidth', 0.5);
end

for i = 1:size(heights_fut,2)
    x0 = edges(i);
    w = edges(i+1) - edges(i);
    if option == 1
        h = heights_fut(r,i,1);
    else
        h = heights_fut_area(r,i,1);
    end
    rectangle('Position', [x0, 0, w, h], ...
              'FaceColor', color_ssp126, 'EdgeColor', 'k', 'LineWidth', 1);
end

for i = 1:size(heights_fut,2)
    x0 = edges(i);
    w = edges(i+1) - edges(i);
    if option == 1
        h = heights_fut(r,i,2);
    else
        h = heights_fut_area(r,i,2);
    end
    rectangle('Position', [x0, 0, w, h], ...
              'FaceColor', color_ssp245, 'EdgeColor', 'k', 'LineWidth', 1);
end

for i = 1:size(heights_fut,2)
    x0 = edges(i);
    w = edges(i+1) - edges(i);
    if option == 1
        h = heights_fut(r,i,3);
    else
        h = heights_fut_area(r,i,3);
    end
    rectangle('Position', [x0, 0, w, h], ...
              'FaceColor', color_ssp370, 'EdgeColor', 'k', 'LineWidth', 1);
end

for i = 1:size(heights_fut,2)
    x0 = edges(i);
    w = edges(i+1) - edges(i);
    if option == 1
        h = heights_fut(r,i,4);
    else
        h = heights_fut_area(r,i,4);
    end
    rectangle('Position', [x0, 0, w, h], ...
              'FaceColor', color_ssp585, 'EdgeColor', 'k', 'LineWidth', 1);
end

% if r == 1 || r == 13 || r == 14 || r == 5
%     ylim([0 2500])
% elseif r == 4 || r == 14 || r == 17 || r == 2
%     ylim([0 1000])
% elseif r == 9 || r == 3 || r == 10 || r == 18
%     ylim([0 300])
% elseif r == 8 || r == 12 || r == 19 || r == 16
%     ylim([0 200])
% elseif r == 9 || r == 6 || r == 7
%     ylim([0 70])
% end

% if r == 13
%     xlabel('Glacier size (km^2)');
%     ylabel('Nr of glaciers');
% elseif r == 2 || r == 8 || r == 3 || r == 7
%     ylabel('Nr of glaciers');
% else
%     yticks([]);
% end

% plot(edges(2:end-1), heights_fut_area(:,1)', 'linewidth', 2, 'Color', color_ssp126)
% plot(edges(2:end-1), heights_fut_area(:,2)', 'linewidth', 2, 'Color', color_ssp245)
% plot(edges(2:end-1), heights_fut_area(:,3)', 'linewidth', 2, 'Color', color_ssp370)
% plot(edges(2:end-1), heights_fut_area(:,4)', 'linewidth', 2, 'Color', color_ssp585)

grid on
xlim([0.01, 10^3]);

set(gca, 'XScale', 'log'); % Set x-axis to logarithmic scale
set(gca, 'fontsize', 22)

% if r ~= 13 &&  r ~= 2 && r ~= 3 && r ~= 8 && r ~= 7 && r ~= 20
%     set(gca, 'YTick', []);  % Most reliable
% end

ylim([0 max(heights_now(r,:))])

if r == 21
     yticks([0 0.2 0.4 0.6 0.8 1]);
     set(gca, 'fontsize', 40)
elseif r == 20
    xticks([10^-2 10^-1 10^0 10^1 10^2 10^3]);
    set(gca, 'fontsize', 40)
    %set(gca, 'YTick', []);  % Most reliable
else
    xticks([10^-2 10^-1 10^0 10^1 10^2]);
    %set(gca, 'YTick', []);  % Most reliable
end

% Get current y-ticks
yt = get(gca, 'YTick');
% Keep only the first (lowest) and last (highest)
yt_new = yt([1 end]);
% Set the new ticks
set(gca, 'YTick', yt_new);

if r < 20
    name = ['../results_pre25/',rgi,'_', num2str(option),'_barplots.pdf'];
else
    name = ['../results_pre25/world_', num2str(option),'_barplots.pdf']
end
fig=gcf;fig.PaperPositionMode='auto';
fig_pos=fig.PaperPosition;fig.PaperSize = [fig_pos(3) fig_pos(4)]; % Needed to have correct aspect in saved figure
exportgraphics(gcf,name,'BackgroundColor','none')



%%
% 
% plot(edges(:,1:end-2), heights_fut_area(:,1))
% hold on
% plot(edges(:,1:end-2), heights_now', 'linewidth', 2)
% xlim([100 1000])