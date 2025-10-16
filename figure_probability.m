for p = 1:4

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


A2 = sort(A,2);
ind_dis = A2(:,round(size(A2,2)/2));
[idx_ind] = find(ind_dis < 2025);
A2(idx_ind,:) = [];
A = A2;
B = A;

maxsize(p) = size(A,1);

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

        [years_unique, ~, idx_group] = unique(years_known(:));
        values_max = accumarray(idx_group, values_known(:), [], @max);

        % Add initial year and zero value
        years_unique = [2000; years_unique];
        values_max = [0; values_max];

        % Remove any non-finite values
        valid = isfinite(years_unique) & isfinite(values_max);
        years_unique = years_unique(valid);
        values_max = values_max(valid);

        if numel(years_unique) >= 2 && years_unique(2) ~= years_unique(1)
            values_interp = interp1(years_unique, values_max, years_interp, 'previous', 'extrap');
            count(r,:) = values_interp;
            years_g(r,:) = years_interp;
        end
    end
end


%% Levels 
mask = count > round(0.5 * size(A,2));
[firstFound, year_50] = max(mask, [], 2);  % max returns the first 'true' index per row
year_50(firstFound == 0) = NaN;

mask = count > round(0.75 * size(A,2));
[firstFound, year_75] = max(mask, [], 2);  % max returns the first 'true' index per row
year_75(firstFound == 0) = NaN;

mask = count > round(0.25 * size(A,2));
[firstFound, year_25] = max(mask, [], 2);  % max returns the first 'true' index per row
year_25(firstFound == 0) = NaN;

mask = count > round(1 * size(A,2)-1);
[firstFound, year_100] = max(mask, [], 2);  % max returns the first 'true' index per row
year_100(firstFound == 0) = NaN;

mask = count > round(0.1 * size(A,2));
[firstFound, year_10] = max(mask, [], 2);  % max returns the first 'true' index per row
year_10(firstFound == 0) = NaN;
%% Levels 
year_25(year_50 < 25) = nan;
year_75(year_50 < 25) = nan;
year_50(year_50 < 25) = nan;

for a = 1:101
        years_con = a + 2000;
        list_years_40_prob50(a,p) = sum(year_50 + 2000 == years_con); 
        list_years_40_prob75(a,p) = sum(year_75 + 2000 == years_con); 
        list_years_40_prob25(a,p) = sum(year_25 + 2000 == years_con); 
end

end

hold on

x_fill = [2000:2100, fliplr(2000:2100)];
y_fill = [(cumsum(list_years_40_prob25(:,4)) ./ maxsize(4) .* 100)', fliplr((cumsum(list_years_40_prob75(:,4)) ./ maxsize(4) .* 100)')];
%fill(x_fill, y_fill, color_ssp585,'FaceAlpha', 0.2, 'EdgeColor', 'none');  % Light blue fill
y_fill = [(cumsum(list_years_40_prob25(:,3)) ./ maxsize(3) .* 100)', fliplr((cumsum(list_years_40_prob75(:,3)) ./ maxsize(3) .* 100)')];
fill(x_fill, y_fill, color_ssp370, 'FaceAlpha', 0.2, 'EdgeColor', 'none');  % Light blue fill
y_fill = [(cumsum(list_years_40_prob25(:,2)) ./ maxsize(2) .* 100)', fliplr((cumsum(list_years_40_prob75(:,2)) ./ maxsize(2) .* 100)')];
%fill(x_fill, y_fill, color_ssp245, 'FaceAlpha', 0.2, 'EdgeColor', 'none');  % Light blue fill
y_fill = [(cumsum(list_years_40_prob25(:,1)) ./ maxsize(1) .* 100)', fliplr((cumsum(list_years_40_prob75(:,1)) ./ maxsize(1) .* 100)')];
fill(x_fill, y_fill, color_ssp126, 'FaceAlpha', 0.2, 'EdgeColor', 'none');  % Light blue fill



%plot(2000:2100, cumsum(list_years_40_prob50(:,4)) ./ size(A,1) .* 100, ':', 'LineWidth', 3,'Color', color_ssp585)
plot(2000:2100, cumsum(list_years_40_prob50(:,3)) ./ maxsize(3) .* 100, ':', 'LineWidth', 3,'Color', color_ssp370)
%plot(2000:2100, cumsum(list_years_40_prob50(:,2)) ./ size(A,1) .* 100, ':', 'LineWidth', 2,'Color', color_ssp245)
plot(2000:2100, cumsum(list_years_40_prob50(:,1)) ./ maxsize(1) .* 100, ':', 'LineWidth', 3,'Color', color_ssp126)

%%
% plot(2000:2100, cumsum(list_years_40_prob75(:,4))')
% hold on
% plot(2000:2100, cumsum(list_years_40_prob25(:,4))')
% plot(2000:2100, cumsum(list_years_40_prob50(:,4))')
% 
% %plot(2000:2100, cumsum(list_years_40_prob25(:,4)) - sum(list_years_40_prob50(1:25,3))')
% %plot(2000:2100, cumsum(list_years_40_prob50(:,3)) - sum(list_years_40_prob50(1:25,3)), ':', 'LineWidth', 3,'Color', color_ssp370)
% xlim([2025 2100])