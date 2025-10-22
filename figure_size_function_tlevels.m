
%% =========================================================================
%  SIZE–EXTINCTION RELATION (+2.0°C or other) — LOG FIT & METRICS
%  -------------------------------------------------------------------------
%  - Extracts per-glacier extinction years (median across GCMs) for SSP2-7.0
%  - Cleans NaNs/negatives/zeros, pairs with glacier areas
%  - Fits y = a*log(x) + b (log-area vs extinction year)
%  - Reports R^2 and RMSE, and exports a vector PDF
%
%% =========================================================================

figure('Visible', 'off','units','normalized','outerposition',[0 0 1 1])

%% ------------------------------------------------------------------------
% PANEL & RAW INPUTS
% -------------------------------------------------------------------------
subplot(2,2,1)

% NOTE: This initial 'areas' assignment is overwritten below by area_tot_27.
% It is kept here to preserve original code flow.
areas = year_no_27_mean(:,1);

% Per-glacier extinction years across GCMs (SSP2-7.0); take median column
A = squeeze(year_no_27_mean_result(r,:,:));
A = sort(A,2);
years = A(:,size(A,2)/2);

%% ------------------------------------------------------------------------
% CLEANING / PAIRING AREAS & YEARS
%  - Drop invalid years (<2000 → NaN)
%  - Use area_tot_27 as areas source (end-of-century slice here)
%  - Remove NaNs and nonpositive areas, keep aligned pairs
% -------------------------------------------------------------------------

years(years < 2000) = nan;

areas = area_tot_27(:,1,1);
areas = areas(~isnan(years));
years = years(~isnan(years));

years = years(~isnan(areas)); % drop NaN areas
areas = areas(~isnan(areas));
areas = areas (~isnan(years)); % drop NaN years
years = years(~isnan(years)); 

years = years(areas>0);
areas = areas(areas>0);

%% ------------------------------------------------------------------------
% SCATTER + LOG-X FIT (y = a*log(x) + b)
% -------------------------------------------------------------------------
scatter(areas, years, 'filled')
hold on
set(gca, 'XScale', 'log'); % Set x-axis to logarithmic scale

% Log-linear fit
p = polyfit(log(areas), years, 1); % Fit y = a*log(x) + b
y_fit = polyval(p, log(areas)); % Evaluate the polynomial

% Plot fitted curve (sorted by area for a clean line)
q = [areas,y_fit];
q = sort(q);
plot(q(:,1), q(:,2), 'r', 'LineWidth', 2);

ylim([1980 2100])


%% ------------------------------------------------------------------------
% METRICS: R^2 & RMSE
% -------------------------------------------------------------------------
SS_tot = sum((years - mean(years)).^2); % Total sum of squares
SS_res = sum((years - y_fit).^2); % Residual sum of squares
R_squared(r) = 1 - (SS_res / SS_tot);

fprintf('Fitted Equation: y = %.4f * log(x) + %.4f\n', p(1), p(2));
fprintf('R-squared: %.4f\n', R_squared(r));

RMSE(r) = sqrt(mean((years - y_fit).^2));
fprintf('Root Mean Square Error (RMSE): %.4f\n', RMSE(r));


%% ------------------------------------------------------------------------
% AXES, LABELS, STYLING
% -------------------------------------------------------------------------
grid on
set(gca, 'fontsize', 20)
ylabel('Extinction year')
xlabel('Glacier size (km^{2})')


%% ------------------------------------------------------------------------
% EXPORT (vector PDF, transparent background)
% -------------------------------------------------------------------------
name = ['../../results/', rgi, '_linear.pdf'];
fig = gcf; fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];    % keep on-disk aspect
exportgraphics(gcf, name, 'BackgroundColor', 'none')
