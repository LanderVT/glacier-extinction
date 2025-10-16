clc

if rgi < 20
    data1 = 100 .* (cumsum(list_years_40(rgi,25:end)) ./ (initial_glaciers(rgi) - sum(list_years_40(rgi,1:24))));
    data2 = 100 .* (cumsum(list_years_27(rgi,25:end)) ./ (initial_glaciers(rgi) - sum(list_years_27(rgi,1:24))));
    data3 = 100 .* (cumsum(list_years_20(rgi,25:end)) ./ (initial_glaciers(rgi) - sum(list_years_20(rgi,1:24))));
    data4 = 100 .* (cumsum(list_years_15(rgi,25:end)) ./ (initial_glaciers(rgi) - sum(list_years_15(rgi,1:24))));
else
    data1 = 100 .* cumsum(sum(list_years_40(1:19,25:end))) ./ (sum(initial_glaciers(1:19)) - sum(sum(list_years_40(1:19,1:24))));
    data2 = 100 .* cumsum(sum(list_years_27(1:19,25:end))) ./ (sum(initial_glaciers(1:19)) - sum(sum(list_years_27(1:19,1:24))));
    data3 = 100 .* cumsum(sum(list_years_20(1:19,25:end))) ./ (sum(initial_glaciers(1:19)) - sum(sum(list_years_20(1:19,1:24))));
    data4 = 100 .* cumsum(sum(list_years_15(1:19,25:end))) ./ (sum(initial_glaciers(1:19)) - sum(sum(list_years_15(1:19,1:24))));
end

data1(end+1) = 100;
data2(end+1) = 100;
data3(end+1) = 100;
data4(end+1) = 100;

%figure('units','normalized','outerposition',[0 0 1 1])
figure('Visible', 'off', 'units','normalized','outerposition',[0 0 1 1])
hold on;
theta_offset = pi/2;

radii = [0, 1, 2, 3];
n_slices = 76;
n_color_steps = 15;
step_size = floor(n_slices / n_color_steps);

% Define anchor colors
anchor_colors_white = [123, 26, 99; 255, 0, 0; 255, 200, 0; 255, 255, 140] ./ 255;
anchor_colors_yellow = [123, 26, 99; 255, 0, 0; 255, 221, 0; 255, 255, 200] ./ 255;

segment_lengths_white = [25, 25, 26];
segment_lengths_yellow = [38, 38];

build_colormap = @(anchors, seg_lengths) ...
    cell2mat(arrayfun(@(i) ...
        [linspace(anchors(i,1), anchors(i+1,1), seg_lengths(i))', ...
         linspace(anchors(i,2), anchors(i+1,2), seg_lengths(i))', ...
         linspace(anchors(i,3), anchors(i+1,3), seg_lengths(i))'], ...
    (1:length(seg_lengths))', 'UniformOutput', false));

full_colormap_white = build_colormap(anchor_colors_white, segment_lengths_white).^1.1;
full_colormap_yellow = build_colormap(anchor_colors_yellow, segment_lengths_yellow).^1.1;

colormap_white = full_colormap_white(round(linspace(1, size(full_colormap_white,1), n_color_steps)), :);
colormap_yellow = full_colormap_yellow(round(linspace(1, size(full_colormap_yellow,1), n_color_steps)), :);

% Create stepped color indices: 1 color every 5 slices
color_indices_5yr = repelem(1:n_color_steps, step_size);
if length(color_indices_5yr) < n_slices
    color_indices_5yr = [color_indices_5yr, repmat(n_color_steps, 1, n_slices - length(color_indices_5yr))];
end

smooth_interpolation = @(data, num) [interp1(linspace(0,1,length(data)-1), data(1:end-1), linspace(0,1,num-1), 'pchip'), data(end)];
smooth_data1 = smooth_interpolation(data1, n_slices);
smooth_data2 = smooth_interpolation(data2, n_slices);
smooth_data3 = smooth_interpolation(data3, n_slices);
smooth_data4 = smooth_interpolation(data4, n_slices);

slices1 = diff([0, smooth_data1]);
slices2 = diff([0, smooth_data2]);
slices3 = diff([0, smooth_data3]);
slices4 = diff([0, smooth_data4]);

slices1 = slices1 / sum(slices1) * 100;
slices2 = slices2 / sum(slices2) * 100;
slices3 = slices3 / sum(slices3) * 100;
slices4 = slices4 / sum(slices4) * 100;

angles = @(data) [theta_offset - cumsum([0, data] / sum(data) * 2 * pi)];

for i = 1:4
    switch i
        case 1, data = slices4;
        case 2, data = slices3;
        case 3, data = slices2;
        case 4, data = slices1;
    end

    angles_data = angles(data);

step_size = 5;
n_groups = floor(n_slices / step_size);  % = 15

for j = 1:n_groups
    idx_start = (j - 1) * step_size + 1;
    idx_end = j * step_size;
    theta_start = angles_data(idx_start);
    theta_end = angles_data(idx_end + 1);
    theta = linspace(theta_start, theta_end, 100);

    r_inner = radii(i);
    r_outer = radii(i) + 1;
    x = [r_inner * cos(theta), fliplr(r_outer * cos(theta))];
    y = [r_inner * sin(theta), fliplr(r_outer * sin(theta))];

    patch_color = colormap_white(j, :);
    fill(x, y, patch_color, 'EdgeColor', 'none', 'FaceAlpha', 1);

    % Draw margin line between slices (except first group)
    if j > 1
    % Margin angle = start of this slice
        theta_margin = theta_start;

        % Margin line color = color of previous wedge
        margin_color = colormap_white(j-1, :);

        % Draw radial line at slice boundary
        x_line = [r_inner * cos(theta_margin), r_outer * cos(theta_margin)];
        y_line = [r_inner * sin(theta_margin), r_outer * sin(theta_margin)];
        plot(x_line, y_line, 'Color', margin_color, 'LineWidth', 1);
    end
end

% Optionally plot the final slice (slice 76) as a thin white wedge
if n_slices == 76
    theta = linspace(angles_data(76), angles_data(77), 50);
    r_inner = radii(i);
    r_outer = radii(i) + 1;
    x = [r_inner * cos(theta), fliplr(r_outer * cos(theta))];
    y = [r_inner * sin(theta), fliplr(r_outer * sin(theta))];
    fill(x, y, [1 1 1], 'EdgeColor', 'none', 'FaceAlpha', 1);
end

theta_border = linspace(-pi, pi, 200);
    x_outer = (r_outer) * cos(theta_border);
    y_outer = (r_outer) * sin(theta_border);
    plot(x_outer, y_outer, 'k', 'LineWidth', 2);

    x_inner = (r_inner) * cos(theta_border);
    y_inner = (r_inner) * sin(theta_border);
    plot(x_inner, y_inner, 'k', 'LineWidth', 2);

    %Mark boundaries
    for angle_id = [76, 77]
        final_angle = angles_data(angle_id);
        x_line = [r_inner * cos(final_angle), r_outer * cos(final_angle)];
        y_line = [r_inner * sin(final_angle), r_outer * sin(final_angle)];
        plot(x_line, y_line, 'k-', 'LineWidth', 2);
    end

    % Add lines for 2050 and 2075
    year_targets = [2050, 2075];
    year_lookup = linspace(2025, 2100, n_slices);  % 100 points between 2025 and 2100
    % 
    for y_idx = 1:length(year_targets)
        year_target = year_targets(y_idx);

        % Find the slice index closest to the target year
        [~, year_idx] = min(abs(year_lookup - year_target));

        % Determine the correct slices array for the current ring
        switch i
            case 1
                slices = slices4;
            case 2
                slices = slices3;
            case 3
                slices = slices2;
            case 4
                slices = slices1;
        end

        % Compute angle for cumulative slices up to the year index
        angle_for_year = theta_offset - sum(slices(1:year_idx)) / sum(slices) * 2 * pi;

        % Plot dashed radial line
        x_line = [r_inner * cos(angle_for_year), r_outer * cos(angle_for_year)];
        y_line = [r_inner * sin(angle_for_year), r_outer * sin(angle_for_year)];
        plot(x_line, y_line, 'k--', 'LineWidth', 2);
    end
    

    % Add the peak year line (white) to each respective ring
    %year_targets = peakextinctionyear(rgi, 11:14);  % assumed to be one value per ring

    % Extract the target year for this ring
    %year_target = year_targets(i);

    % Find the slice index closest to the target year
    %[~, year_idx] = min(abs(year_lookup - year_target));

    % Select the correct slice data for the current ring
    switch i
        case 1
            slices = slices4;
        case 2
            slices = slices3;
        case 3
            slices = slices2;
        case 4
            slices = slices1;
    end

    %   Compute angle for cumulative slices up to the year index
    angle_for_year = theta_offset - sum(slices(1:year_idx)) / sum(slices) * 2 * pi;

    % Compute coordinates for radial line
    x_line = [r_inner * cos(angle_for_year), r_outer * cos(angle_for_year)];
    y_line = [r_inner * sin(angle_for_year), r_outer * sin(angle_for_year)];

    % Plot solid white radial line on this ring
    %plot(x_line, y_line, 'w-', 'LineWidth', 2);
end

axis equal off;
hold off;

if rgi == 20
    colormap(colormap_map);
    c = colorbar('eastoutside');
    caxis([2025 2100]);  % Map color scale to actual year range

    % Specify the desired label years
    years = 2030:10:2100;

    % Use the year values directly for the tick positions
    c.Ticks = [];
    c.TickLabels = string(years);

    % Styling
    c.Label.String = 'Year';
    c.Label.FontSize = 20;
    c.FontSize = 20;
    c.Box = 'off';
end

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
name = ['../results_pre25/',mountains,'_pie_',run,'.pdf'];
exportgraphics(gcf, name, 'ContentType', 'vector', 'BackgroundColor', 'none');

%%

scale_log = @(x) 0.6 + ((log10(x) - log10(500)) / (log10(50000) - log10(500))) * 1.4;
x = [2400];
scaled_vals = scale_log(x)
