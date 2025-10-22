
%% =========================================================================
%  MEDIAN-BASED DISAPPEARANCE YEAR TRAJECTORIES & PROBABILITY BANDS
%  -------------------------------------------------------------------------
%  - Loops scenarios p=1..4 and extracts per-glacier disappearance years
%    (median across GCMs), removing zero rows.
%  - Builds cumulative counts per year (2000–2100) via step interpolation.
%  - Derives threshold years (10/25/50/75/100%) for each glacier row.
%  - Aggregates into yearly histograms list_years_40_probXX and plots:
%      * shaded 25–75% band (by scenario)  +  50% median as dashed line.
%
%  NOTE: Variables referenced here (e.g., year_no_XX_mean_result, etc.)
%        must already be in the workspace. Colors like color_ssp126/370
%        must also be defined beforehand (or earlier in your script).
%% =========================================================================


for p = 1:4

    %% --------------------------------------------------------------------
    % SELECT SCENARIO DATA (per-region if rgi<20; global if rgi=20)
    %   - Sort each glacier's GCM years along 2nd dim (ascending)
    %   - Remove rows starting with zero (no valid info)
    %   - For global: reshape to 2D, drop zero rows, set 0→NaN, sort rows
    %% --------------------------------------------------------------------

    if rgi < 20
        if p == 1
            A = squeeze(year_no_15_mean_result(rgi,:,:));
            A = sort(A,2);
            idx_zero = find(A(:,1) == 0);
            A(idx_zero,:) = [];
            B = A;
        elseif p == 2
            A = squeeze(year_no_20_mean_result(rgi,:,:));
            A = sort(A,2);
            idx_zero = find(A(:,1) == 0);
            A(idx_zero,:) = [];
            B = A;
        elseif p == 3
            A = squeeze(year_no_27_mean_result(rgi,:,:));
            A = sort(A,2);
            idx_zero = find(A(:,1) == 0);
            A(idx_zero,:) = [];
            B = A;
        else
            A = squeeze(year_no_40_mean_result(rgi,:,:));
            A = sort(A,2);
            idx_zero = find(A(:,1) == 0);
            A(idx_zero,:) = [];
            B = A;
        end
    else
        if p == 1
            A2D = reshape(year_no_15_mean_result, [], size(year_no_15_mean_result, 3));            
            idx_zero = find(A2D(:,1) == 0);
            A2D(idx_zero,:) = [];
            A2D(A2D == 0) = nan;
            A = sort(A2D,2);
            B = A;
        elseif p == 2
            A2D = reshape(year_no_20_mean_result, [], size(year_no_20_mean_result, 3));            
            idx_zero = find(A2D(:,1) == 0);
            A2D(idx_zero,:) = [];
            A2D(A2D == 0) = nan;
            A = sort(A2D,2);
            B = A;
        elseif p == 3
            A2D = reshape(year_no_27_mean_result, [], size(year_no_27_mean_result, 3));            
            idx_zero = find(A2D(:,1) == 0);
            A2D(idx_zero,:) = [];
            A2D(A2D == 0) = nan;
            A = sort(A2D,2);
            B = A;
        elseif p == 4
            A2D = reshape(year_no_40_mean_result, [], size(year_no_40_mean_result, 3));            
            idx_zero = find(A2D(:,1) == 0);
            A2D(idx_zero,:) = [];
            A2D(A2D == 0) = nan;
            A = sort(A2D,2);
            B = A;
        end
    end

%% --------------------------------------------------------------------
    % REMOVE GLACIERS WITH MEDIAN DISAPPEARANCE < 2025
    %   - Compute per-row median index (mid column)
    %   - Filter out rows where that median < 2025
%% --------------------------------------------------------------------
A2 = sort(A,2);
ind_dis = A2(:,round(size(A2,2)/2)); % median across GCMs
[idx_ind] = find(ind_dis < 2025);
A2(idx_ind,:) = [];
A = A2;
B = A;

% Track panel size per scenario
maxsize(p) = size(A,1);

%% --------------------------------------------------------------------
    % BUILD CUMULATIVE COUNTS PER ROW (2000–2100)
    %   - For each row: stepwise cumulative count vs. year
    %   - years_interp = 2000:2100 (inclusive)
%% --------------------------------------------------------------------
count = [];
years_g = [];
[n_rows, ~] = size(A);
years_interp = 2000:2100;

for r = 1:n_rows
    row_data = A(r,:);
    valid_idx = ~isnan(row_data);

    if any(valid_idx)
        years_known = row_data(valid_idx);
        values_known = arrayfun(@(x) sum(B(r,:) <= x), years_known);

         % Collapse duplicate years by max value
        [years_unique, ~, idx_group] = unique(years_known(:));
        values_max = accumarray(idx_group, values_known(:), [], @max);

         % Add baseline (year 2000 → count 0)
        years_unique = [2000; years_unique];
        values_max = [0; values_max];

        % Keep finite only
        valid = isfinite(years_unique) & isfinite(values_max);
        years_unique = years_unique(valid);
        values_max = values_max(valid);

        % Step interpolation to full grid (previous-value hold)
        if numel(years_unique) >= 2 && years_unique(2) ~= years_unique(1)
            values_interp = interp1(years_unique, values_max, years_interp, 'previous', 'extrap');
            count(r,:) = values_interp;
            years_g(r,:) = years_interp;
        end
    end
end

%% --------------------------------------------------------------------
    % THRESHOLD YEARS (10/25/50/75/100%) PER ROW
    %   - Find first index where cumulative proportion exceeds threshold
    %   - If never exceeded → NaN
%% --------------------------------------------------------------------

% 50%
mask = count > round(0.5 * size(A,2));
[firstFound, year_50] = max(mask, [], 2);  % max returns the first 'true' index per row
year_50(firstFound == 0) = NaN;

% 75%
mask = count > round(0.75 * size(A,2));
[firstFound, year_75] = max(mask, [], 2);  % max returns the first 'true' index per row
year_75(firstFound == 0) = NaN;

% 25%
mask = count > round(0.25 * size(A,2));
[firstFound, year_25] = max(mask, [], 2);  % max returns the first 'true' index per row
year_25(firstFound == 0) = NaN;

% 100%
mask = count > round(1 * size(A,2)-1);
[firstFound, year_100] = max(mask, [], 2);  % max returns the first 'true' index per row
year_100(firstFound == 0) = NaN;

% 10%
mask = count > round(0.1 * size(A,2));
[firstFound, year_10] = max(mask, [], 2);  % max returns the first 'true' index per row
year_10(firstFound == 0) = NaN;

% Basic consistency: drop 25/50/75 if 50% index < 25 (as in original)
year_25(year_50 < 25) = nan;
year_75(year_50 < 25) = nan;
year_50(year_50 < 25) = nan;

%% --------------------------------------------------------------------
    % UPDATE YEARLY HISTOGRAMS OF THRESHOLD CROSSINGS
    %   - list_years_40_probXX: counts per calendar year 2000..2100
%% --------------------------------------------------------------------
    for a = 1:101
            years_con = a + 2000;
            list_years_40_prob50(a,p) = sum(year_50 + 2000 == years_con); 
            list_years_40_prob75(a,p) = sum(year_75 + 2000 == years_con); 
            list_years_40_prob25(a,p) = sum(year_25 + 2000 == years_con); 
    end

end

%% ------------------------------------------------------------------------
% PLOT SHADED 25–75% BAND + 50% MEDIAN LINES
%   NOTE: y_fill is reassigned for each scenario, as in the original code.
%         Keep the sequence if you rely on overplot order.
% ------------------------------------------------------------------------

hold on

x_fill = [2000:2100, fliplr(2000:2100)];

% --- _2.7°C band (uses p=3 arrays; transparent fill) ---
y_fill = [(cumsum(list_years_40_prob25(:,4)) ./ maxsize(4) .* 100)', fliplr((cumsum(list_years_40_prob75(:,4)) ./ maxsize(4) .* 100)')];
y_fill = [(cumsum(list_years_40_prob25(:,3)) ./ maxsize(3) .* 100)', fliplr((cumsum(list_years_40_prob75(:,3)) ./ maxsize(3) .* 100)')];
fill(x_fill, y_fill, color_ssp370, 'FaceAlpha', 0.2, 'EdgeColor', 'none');  % Light blue fill

% --- +1.5°C band (uses p=1 arrays; transparent fill) ---
y_fill = [(cumsum(list_years_40_prob25(:,2)) ./ maxsize(2) .* 100)', fliplr((cumsum(list_years_40_prob75(:,2)) ./ maxsize(2) .* 100)')];
y_fill = [(cumsum(list_years_40_prob25(:,1)) ./ maxsize(1) .* 100)', fliplr((cumsum(list_years_40_prob75(:,1)) ./ maxsize(1) .* 100)')];
fill(x_fill, y_fill, color_ssp126, 'FaceAlpha', 0.2, 'EdgeColor', 'none');  % Light blue fill

% --- 50% median lines ---
plot(2000:2100, cumsum(list_years_40_prob50(:,3)) ./ maxsize(3) .* 100, ':', 'LineWidth', 3,'Color', color_ssp370)
plot(2000:2100, cumsum(list_years_40_prob50(:,1)) ./ maxsize(1) .* 100, ':', 'LineWidth', 3,'Color', color_ssp126)

