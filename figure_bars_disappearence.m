
%% =========================================================================
%  BAR PLOTS OF GLACIER COUNTS BY SIZE BIN (LOG SCALE)
%  -------------------------------------------------------------------------
%  - Builds size bins (km^2) from ~1e-3 to 1e4
%  - Counts present-day glaciers and future-vanishing subsets per scenario
%  - Draws stacked rectangles per bin for SSP126/245/370/585 + current line
%  - Exports a vector PDF with transparent background
%
%  Option flag:
%    option = 1 → count "# glaciers with NaN disappearance year" (per bin)
%    option = 2 → count by EOC areas (heights_fut_area)
%% =========================================================================

clc

%% ------------------------------------------------------------------------
% FIGURE WINDOWS
%   First figure is created hidden (for batch export),
%   second one is visible (interactive view). Keep both if desired.
% -------------------------------------------------------------------------

figure('Visible', 'off','units','normalized','outerposition',[0 0 1 1])
figure('units','normalized','outerposition',[0 0 1 1])

%% ------------------------------------------------------------------------
% INIT / OPTIONS
% -------------------------------------------------------------------------

clear area_all
option = 2;  % see header note

% IPCC scenario colors (RGB normalized)
color_ssp585 = [115, 31, 30] / 255;
color_ssp126 = [60, 136, 167] / 255;
color_ssp245 = [0.928 0.572 0.172];
color_ssp370 = [223, 0, 0] / 255;

if r < 20
    subplot(2,2,1)
    years_all = zeros(3,size(area_tot_15,1));
    for all = 1:4
        if all == 1
            % --- (1.5°C) ---
            areas = year_no_15_mean(r, :,1)'; % base areas (remove zeros)
            areas = areas(areas > 0);
            
            A = squeeze(year_no_15_mean_result(r,1:size(area_tot_15,1),:));
            A = sort(A,2);
            years = A(:,round(size(A,2)/2)); % median across GCMs
            
            % glaciers with NaN disappearance year → take EOC area instead
            idx = find(isnan(years));
            area_years = area_tot_15(idx,:,end);
            area_years = nanmedian(area_years,2);
        
        elseif all == 2
            % --- (2.0°C) ---
            areas = year_no_20_mean(r, :,1)'; % base areas (remove zeros)
            areas = areas(areas > 0);
            
            A = squeeze(year_no_20_mean_result(r,1:size(area_tot_15,1),:));
            A = sort(A,2);
            years = A(:,round(size(A,2)/2)); % median across GCMs
            
            % glaciers with NaN disappearance year → take EOC area instead
            idx = find(isnan(years));
            area_years = area_tot_20(idx,:,end);
            area_years = nanmedian(area_years,2);

        elseif all == 3
            % --- (2.7°C) ---
            areas = year_no_27_mean(r, :,1)'; % base areas (remove zeros)
            areas = areas(areas > 0);

            A = squeeze(year_no_27_mean_result(r,1:size(area_tot_15,1),:));
            A = sort(A,2);
            years = A(:,round(size(A,2)/2)); % median across GCMs
            
            % glaciers with NaN disappearance year → take EOC area instead
            idx = find(isnan(years));
            area_years = area_tot_27(idx,:,end);
            area_years = nanmedian(area_years,2);

        elseif all == 4
            % --- (4.0°C) ---
            areas = year_no_40_mean(r, :,1)'; % base areas (remove zeros)
            areas = areas(areas > 0);
            
            A = squeeze(year_no_40_mean_result(r,1:size(area_tot_15,1),:));
            A = sort(A,2);
            years = A(:,round(size(A,2)/2)); % median across GCMs
            
            % glaciers with NaN disappearance year → take EOC area instead
            idx = find(isnan(years));
            area_years = area_tot_40(idx,:,end);
            area_years = nanmedian(area_years,2);
        end
        years_all(all,:) = years;
        area_all(all,1:size(area_years,1)) = area_years;
    end
    
    years_all = years_all';  % (rows: scenarios) 
    area_all(area_all == 0) = nan;  % (rows: scenarios)

else

    % ----------------- GLOBAL PATH (sum of 1..19) -----------------
    years_all = zeros(3,216535); % keeps shape consistent (will reuse)
    for all = 1:4
        if all == 1
            % Flatten, remove zero rows, take medians, collect EOC areas
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

    years_all = years_all'; % [nGlaciers × 4]
    area_all(area_all == 0) = nan;

end


%% ------------------------------------------------------------------------
% BINNING (log-spaced edges) AND FILTER
% -------------------------------------------------------------------------
% Bin edges (km^2): left/right edges of each bar (last wide bin to 1e4)
edges = [0, logspace(log10(1e-3), log10(1000), 100), 10000];

% Ignore glaciers that disappear before 2025 in the current-year array
areas(years < 2025) = nan;

%% ------------------------------------------------------------------------
% FILL HEIGHT MATRICES BY BIN
%   - heights_now(r, q)      : present-day count in bin q
%   - heights_fut(r, q, s)   : future-vanishing count (by scenario s)
%   - heights_fut_area(r,q,s): future-vanishing by EOC area (by scenario s)
% NOTE: arrays are presumed existing/growing; not preallocated here.
% -------------------------------------------------------------------------
for q = 2:size(edges,2)-2 % loop bins (skip first/last sentinel)
    % indices of glaciers whose area falls inside current bin
    idx_area = find(areas > edges(q-1) & areas < edges(q));
    % present-day count
    heights_now(r,q) = size(idx_area,1); 
     % per-scenario counts
    for all = 1:4
        % glaciers with NaN disappearance year in this bin
        a = find(isnan(years_all(idx_area,all)));
        if ~isempty(a)
            heights_fut(r,q,all) = size(a,1);
        else
            heights_fut(r,q,all) = 0;
        end

        % EOC area-based counting
        area_fut = area_all(all,:);
        idx_area2 = find(area_fut > edges(q-1) & area_fut < edges(q));
        heights_fut_area(r,q, all) = size(idx_area2,2);  % one fewer than edges
    end
end

% Bin centers & widths (for plotting aids if needed)
centers = (edges(1:end-1) + edges(2:end)) / 2;
widths = edges(2:end) - edges(1:end-1);

hold on

%% ------------------------------------------------------------------------
% DRAW BARS (RECTANGLES) PER BIN
%   First: outlines for "now"; then colored stacks for future scenarios
% -------------------------------------------------------------------------
% Present-day outlines (black, no fill)
for i = 1:size(heights_now,2)
    x0 = edges(i);
    w = widths(i);
    h = heights_now(r,i);
    rectangle('Position', [x0, 0, w, h], ...
              'EdgeColor', 'k', 'FaceColor', 'none', 'LineWidth', 0.5, 'FaceAlpha', 1);
end

% Scenario fills — +1.5(blue)
for i = 1:size(heights_fut,2)
    x0 = edges(i);
    w = edges(i+1) - edges(i);
    if option == 1
        h = heights_fut(r,i,1);
    else
        h = heights_fut_area(r,i,1);
    end
    rectangle('Position', [x0, 0, w, h], ...
              'FaceColor', color_ssp126, 'EdgeColor', 'k', 'LineWidth', 1, 'FaceAlpha', 1);
end

% Scenario fills — SSP2.0 (orange)
for i = 1:size(heights_fut,2)
    x0 = edges(i);
    w = edges(i+1) - edges(i);
    if option == 1
        h = heights_fut(r,i,2);
    else
        h = heights_fut_area(r,i,2);
    end
    rectangle('Position', [x0, 0, w, h], ...
              'FaceColor', color_ssp245, 'EdgeColor', 'k', 'LineWidth', 1, 'FaceAlpha', 1);
end

% Scenario fills — +2.7 (red)
for i = 1:size(heights_fut,2)
    x0 = edges(i);
    w = edges(i+1) - edges(i);
    if option == 1
        h = heights_fut(r,i,3);
    else
        h = heights_fut_area(r,i,3);
    end
    rectangle('Position', [x0, 0, w, h], ...
              'FaceColor', color_ssp370, 'EdgeColor', 'k', 'LineWidth', 1, 'FaceAlpha', 1);
end

% Scenario fills — +4.0 (dark red)
for i = 1:size(heights_fut,2)
    x0 = edges(i);
    w = edges(i+1) - edges(i);
    if option == 1
        h = heights_fut(r,i,4);
    else
        h = heights_fut_area(r,i,4);
    end
    rectangle('Position', [x0, 0, w, h], ...
              'FaceColor', color_ssp585, 'EdgeColor', 'k', 'LineWidth', 1, 'FaceAlpha', 1);
end

% Overlay present-day line on top (for visibility)
plot(edges(2:end-1) - (edges(3:end)-edges(2:end-1))/2,heights_now(r,:)', 'linewidth',2, 'Color', 'k')

%% ------------------------------------------------------------------------
% AXIS LIMITS, LABELS, TICKS (region-dependent y-lims preserved)
% -------------------------------------------------------------------------
if r == 1 || r == 13 || r == 14 || r == 5
    ylim([0 2500])
elseif r == 4 || r == 14 || r == 17 || r == 2
    ylim([0 1000])
elseif r == 9 || r == 3 || r == 10 || r == 18
    ylim([0 300])
elseif r == 8 || r == 12 || r == 19 || r == 16
    ylim([0 200])
elseif r == 9 || r == 6 || r == 7
    ylim([0 70])
end

% Axis labels (kept as in original)
if r == 13
    xlabel('Glacier size (km^2)');
    ylabel('Nr of glaciers');
elseif r == 2 || r == 8 || r == 3 || r == 7
    ylabel('Nr of glaciers');
end

grid on
xlim([0.01, 10^3]);

set(gca, 'XScale', 'log'); % Set x-axis to logarithmic scale
set(gca, 'fontsize', 22)

% Ensure y-limits are tight to present-day max
ylim([0 max(heights_now(r,:))])

% Region-specific tick tweaks
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

% Remove ylabel safely (as in original)
ylabel('off')
set(gca, 'ylabel', []);  % Most reliable

% Keep only first and last y-tick for clarity
yt = get(gca, 'YTick');
if numel(yt) >= 2
    set(gca, 'YTick', yt([1 end]));
end

%% ------------------------------------------------------------------------
% EXPORT (vector PDF, transparent background)
% -------------------------------------------------------------------------
if r < 20
    name = ['../../results/',rgi,'_barplots.pdf'];
else
    name = ['../../results/world_barplots.pdf'];
end
fig=gcf;fig.PaperPositionMode='auto';
fig_pos=fig.PaperPosition;fig.PaperSize = [fig_pos(3) fig_pos(4)]; % Needed to have correct aspect in saved figure
exportgraphics(gcf,name,'BackgroundColor','none')
