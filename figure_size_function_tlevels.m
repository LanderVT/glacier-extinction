
figure('Visible', 'off','units','normalized','outerposition',[0 0 1 1])

subplot(2,2,1)
areas = year_no_27_mean(:,1);
% revised to with the mean here!
A = squeeze(year_no_27_mean_result(r,:,:));
A = sort(A,2);
years = A(:,size(A,2)/2);



    years(years < 2000) = nan;
    areas = area_tot_27(:,1,1);
    areas = areas(~isnan(years));
    years = years(~isnan(years));

    years = years(~isnan(areas ));
    areas = areas (~isnan(areas ));
    areas = areas (~isnan(years));
    years = years(~isnan(years));
    years = years(areas>0);
    areas = areas(areas>0);

    scatter(areas, years, 'filled')
    hold on
    set(gca, 'XScale', 'log'); % Set x-axis to logarithmic scale

    % Perform logarithmic fit using polyfit
    p = polyfit(log(areas), years, 1); % Fit y = a*log(x) + b
    
    % Generate fitted values
    y_fit = polyval(p, log(areas)); % Evaluate the polynomial

    % Plot original data and fitted curve
    q = [areas,y_fit];
    q = sort(q);
    plot(q(:,1), q(:,2), 'r', 'LineWidth', 2);
    ylim([1980 2100])


    % Compute R-squared
    SS_tot = sum((years - mean(years)).^2); % Total sum of squares
    SS_res = sum((years - y_fit).^2); % Residual sum of squares
    R_squared(r) = 1 - (SS_res / SS_tot);

    % Display results
    fprintf('Fitted Equation: y = %.4f * log(x) + %.4f\n', p(1), p(2));
    fprintf('R-squared: %.4f\n', R_squared(r));

    RMSE(r) = sqrt(mean((years - y_fit).^2));
    fprintf('Root Mean Square Error (RMSE): %.4f\n', RMSE(r));



    grid on
    set(gca, 'fontsize', 20)
    ylabel('Extinction year')
    xlabel('Glacier size (km^{2})')
    name = ['../results_pre25/',rgi,'_linear.pdf'];
fig=gcf;fig.PaperPositionMode='auto';
fig_pos=fig.PaperPosition;fig.PaperSize = [fig_pos(3) fig_pos(4)]; % Needed to have correct aspect in saved figure
exportgraphics(gcf,name,'BackgroundColor','none')
