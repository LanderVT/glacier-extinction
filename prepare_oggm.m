


clear all
clc

%% Temp levels

templevels = readtable('temp_levels.xlsx');
gcms = string(templevels{:,1});
ssps = string(templevels{:,2});
folderPath = '/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results';
file = [folderPath,'/glac_area_annual/',sprintf('%02d', 11),'/R',sprintf('%02d', 11),'_glac_area_annual_ssp585_MCMC_ba1_1sets_2000_2100_all.nc'];
glac_area = ncread(file, 'glac_area_annual');
gcms_pygem = ncread(file, 'Climate_Model');

index_15 = find(templevels{:,4} > 1.1 & templevels{:,4} < 1.7 & ismember(gcms, gcms_pygem) & ~contains(ssps, 'ssp119') & ~contains(ssps, 'ssp534-over') & ~contains(ssps, 'ssp434') & ~contains(ssps, 'ssp460'));
index_20 = find(templevels{:,4} > 1.5 & templevels{:,4} < 2.45  & ismember(gcms, gcms_pygem) & ~contains(ssps, 'ssp119') & ~contains(ssps, 'ssp534-over') & ~contains(ssps, 'ssp434') & ~contains(ssps, 'ssp460'));
index_27 = find(templevels{:,4} > 2.2 & templevels{:,4} < 3.4 & ismember(gcms, gcms_pygem) & ~contains(ssps, 'ssp119') & ~contains(ssps, 'ssp534-over') & ~contains(ssps, 'ssp434') & ~contains(ssps, 'ssp460'));
index_30 = find(templevels{:,4} > 2.5 & templevels{:,4} < 3.2 & ismember(gcms, gcms_pygem) & ~contains(ssps, 'ssp119') & ~contains(ssps, 'ssp534-over') & ~contains(ssps, 'ssp434') & ~contains(ssps, 'ssp460'));
index_40 = find(templevels{:,4} > 3.7 & templevels{:,4} < 4.4 & ismember(gcms, gcms_pygem) & ~contains(ssps, 'ssp119') & ~contains(ssps, 'ssp534-over') & ~contains(ssps, 'ssp434') & ~contains(ssps, 'ssp460'));
index_50 = find(templevels{:,4} > 4.2 & templevels{:,4} < 5.3 & ismember(gcms, gcms_pygem) & ~contains(ssps, 'ssp119') & ~contains(ssps, 'ssp534-over') & ~contains(ssps, 'ssp434') & ~contains(ssps, 'ssp460'));

temps_15 = median(templevels{index_15,4})
temps_20 = median(templevels{index_20,4})
temps_27 = median(templevels{index_27,4})
temps_30 = median(templevels{index_30,4})
temps_40 = median(templevels{index_40,4})
temps_50 = median(templevels{index_50,4})

%% Define the folder path

conversion = 900;

folderPath = '/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/oggm_results';

% Loop over RGIs
rgis = {'RGI01', 'RGI02', 'RGI03', 'RGI04', 'RGI05', 'RGI06',...
        'RGI07', 'RGI08', 'RGI09', 'RGI10', 'RGI11', 'RGI12',...
        'RGI13', 'RGI14', 'RGI15', 'RGI16', 'RGI17', 'RGI18', 'RGI19'};

sspNames = {'/ssp119', '/ssp126', '/ssp245', '/ssp370', '/ssp585'};

regions_n = {'alaska','westerncanada','arcticcanadaN','arcticcanadaS',...
            'greenland','iceland','svalbard',...
            'scandinavia','russianarctic','northasia',...
            'centraleurope','caucasus', 'centralasiaN','centralasiaW',...
            'centralasiaS','lowlatitudes','southernandes','newzealand',...
            'antarctic'};

for r = 11

    disp(['Region running = ', regions_n{r}])

    file = ['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results/glac_area_annual/',sprintf('%02d', r),'/R',sprintf('%02d', r),'_glac_area_annual_ssp585_MCMC_ba1_1sets_2000_2100_all.nc'];
    gcms = ncread(file, 'Climate_Model');
    glac_area = ncread(file, 'glac_area_annual');

    vol_tot_ssp15 = nan(size(glac_area,2),1,101);
    vol_tot_ssp20 = nan(size(glac_area,2),1,101);
    vol_tot_ssp27 = nan(size(glac_area,2),1,101);
    vol_tot_ssp30 = nan(size(glac_area,2),1,101);
    vol_tot_ssp40 = nan(size(glac_area,2),1,101);
    vol_tot_ssp50 = nan(size(glac_area,2),1,101);

    area_tot_ssp15 = vol_tot_ssp15;
    area_tot_ssp20 = vol_tot_ssp20;
    area_tot_ssp27 = vol_tot_ssp27;
    area_tot_ssp30 = vol_tot_ssp30;
    area_tot_ssp40 = vol_tot_ssp40;
    area_tot_ssp50 = vol_tot_ssp50;

    % Loop over 6 T scenario's
    for p = 1:6

        countclim = 0;

        if p == 1
            index = index_15;
        elseif p == 2
            index = index_20;
        elseif p == 3
            index = index_27;
        elseif p == 4
            index = index_30;
        elseif p == 5
            index = index_40;
        elseif p == 6
            index = index_50;
        end

        for q = 1:size(index)
            sspName = ssps_temps{index(q)};
            gcmName = gcms_temps{index(q)};
            file = [folderPath,'/oggm_v161_per_glacier_data/',gcmName,'/RGI',sprintf('%02d', r),'_volume_',gcmName,'_',sspName,'.csv'];
            file2 = [folderPath,'/oggm_v161_per_glacier_data/',gcmName,'/RGI',sprintf('%02d', r),'_area_',gcmName,'_',sspName,'.csv'];
            if exist(file) && sum(contains(gcms, gcmName)) > 0
                glac_vol = importdata(file);
                glac_area = importdata(file2);
                ids = cellfun(@str2double, glac_area.textdata);
                glac_area = glac_area.data;
                glac_vol = glac_vol.data;
                countclim = countclim + 1;
                if p == 1
                    for v = 2:size(glac_area,1)
                        rgi_nr = ids(v);
                        vol_tot_ssp15(rgi_nr,countclim,:) = glac_vol(v,:) ./ 1000000000;
                        area_tot_ssp15(rgi_nr,countclim,:) = glac_area(v,:) ./ 1000000;
                    end
                elseif p == 2
                    for v = 2:size(glac_area,1)
                        rgi_nr = ids(v);
                        vol_tot_ssp20(rgi_nr,countclim,:) = glac_vol(v,:) ./ 1000000000;
                        area_tot_ssp20(rgi_nr,countclim,:) = glac_area(v,:) ./ 1000000;
                    end
                elseif p == 3
                    for v = 2:size(glac_area,1)
                        rgi_nr = ids(v);
                        vol_tot_ssp27(rgi_nr,countclim,:) = glac_vol(v,:) ./ 1000000000;
                        area_tot_ssp27(rgi_nr,countclim,:) = glac_area(v,:) ./ 1000000;
                    end
                elseif p == 4
                    for v = 2:size(glac_area,1)
                        rgi_nr = ids(v);
                        vol_tot_ssp30(rgi_nr,countclim,:) = glac_vol(v,:) ./ 1000000000;
                        area_tot_ssp30(rgi_nr,countclim,:) = glac_area(v,:) ./ 1000000;
                    end
                elseif p == 5
                    for v = 2:size(glac_area,1)
                        rgi_nr = ids(v);
                        vol_tot_ssp40(rgi_nr,countclim,:) = glac_vol(v,:) ./ 1000000000;
                        area_tot_ssp40(rgi_nr,countclim,:) = glac_area(v,:) ./ 1000000;
                    end
                elseif p == 6
                    for v = 2:size(glac_area,1)
                        rgi_nr = ids(v);
                        vol_tot_ssp50(rgi_nr,countclim,:) = glac_vol(v,:) ./ 1000000000;
                        area_tot_ssp50(rgi_nr,countclim,:) = glac_area(v,:) ./ 1000000;
                    end
                end
            end
        end
    end

    save([folderPath,'/',rgis{r},'/area_tot_ssp15'], 'area_tot_ssp15')
    save([folderPath,'/',rgis{r},'/area_tot_ssp20'], 'area_tot_ssp20')
    save([folderPath,'/',rgis{r},'/area_tot_ssp27'], 'area_tot_ssp27')
    save([folderPath,'/',rgis{r},'/area_tot_ssp30'], 'area_tot_ssp30')
    save([folderPath,'/',rgis{r},'/area_tot_ssp40'], 'area_tot_ssp40')
    save([folderPath,'/',rgis{r},'/area_tot_ssp50'], 'area_tot_ssp50')
    save([folderPath,'/',rgis{r},'/vol_tot_ssp15'], 'vol_tot_ssp15')
    save([folderPath,'/',rgis{r},'/vol_tot_ssp20'], 'vol_tot_ssp20')
    save([folderPath,'/',rgis{r},'/vol_tot_ssp27'], 'vol_tot_ssp27')
    save([folderPath,'/',rgis{r},'/vol_tot_ssp30'], 'vol_tot_ssp30')
    save([folderPath,'/',rgis{r},'/vol_tot_ssp40'], 'vol_tot_ssp40')
    save([folderPath,'/',rgis{r},'/vol_tot_ssp50'], 'vol_tot_ssp50')

end

%%
close all
figure('units','normalized','outerposition',[0 0 1 1])
subplot(2,2,1)
rgi = [];
region = r;
if ~isempty(rgi)
    hold on
    pygem15 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp15.mat']);
    pygem20 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp20.mat']);
    pygem27 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp27.mat']);
    pygem30 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp30.mat']);
    pygem40 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp40.mat']);
    pygem50 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp50.mat']);
    plot(2000:2100, squeeze(mean(pygem15(rgi,:,:),2)), ':', 'LineWidth',2);
    plot(2000:2100, squeeze(mean(pygem27(rgi,:,:),2)), ':', 'LineWidth',2, 'Color', 'k');
    plot(2000:2100, squeeze(mean(pygem40(rgi,:,:),2)), ':', 'LineWidth',2);
    glogem15 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp15.mat']);
    glogem27 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp27.mat']);
    glogem30 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp30.mat']);
    glogem40 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp40.mat']);
    plot(2000:2100, squeeze(mean(glogem15(rgi,:,:),2)), 'LineWidth',2);
    plot(2000:2100, squeeze(mean(glogem27(rgi,:,:),2)), 'LineWidth',2, 'Color', 'k');
    plot(2000:2100, squeeze(mean(glogem40(rgi,:,:),2)), 'LineWidth',2);
    oggm15 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/oggm_results/RGI',sprintf('%02d', region),'/vol_tot_ssp15.mat']);
    oggm27 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/oggm_results/RGI',sprintf('%02d', region),'/vol_tot_ssp27.mat']);
    oggm30 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/oggm_results/RGI',sprintf('%02d', region),'/vol_tot_ssp30.mat']);
    oggm40 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/oggm_results/RGI',sprintf('%02d', region),'/vol_tot_ssp40.mat']);
    plot(2000:2100, squeeze(mean(oggm15(rgi,:,:),2)), '--', 'LineWidth',2);
    plot(2000:2100, squeeze(mean(oggm27(rgi,:,:),2)), '--', 'LineWidth',2, 'Color', 'k');
    plot(2000:2100, squeeze(mean(oggm40(rgi,:,:),2)), '--', 'LineWidth',2);
else
    hold on
    pygem15 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp15.mat']);
    pygem20 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp20.mat']);
    pygem27 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp27.mat']);
    pygem30 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp30.mat']);
    pygem40 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp40.mat']);
    pygem50 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp50.mat']);
    plot(2000:2100, squeeze(nansum(nanmean(pygem15(:,:,:),2),1)), ':', 'LineWidth',2);
    plot(2000:2100, squeeze(nansum(nanmean(pygem27(:,:,:),2),1)), ':', 'LineWidth',2, 'Color', 'k');
    plot(2000:2100, squeeze(nansum(nanmean(pygem30(:,:,:),2),1)), ':', 'LineWidth',2);
    plot(2000:2100, squeeze(nansum(nanmean(pygem40(:,:,:),2),1)), ':', 'LineWidth',2);
    glogem15 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp15.mat']);
    glogem20 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp20.mat']);
    glogem27 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp27.mat']);
    glogem30 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp30.mat']);
    glogem40 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp40.mat']);
    glogem50 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp50.mat']);
    plot(2000:2100, squeeze(nansum(nanmean(glogem15(:,:,:),2),1)), 'LineWidth',2);
    plot(2000:2100, squeeze(nansum(nanmean(glogem27(:,:,:),2),1)), 'LineWidth',2, 'Color', 'k');
    plot(2000:2100, squeeze(nansum(nanmean(glogem30(:,:,:),2),1)), 'LineWidth',2);
    plot(2000:2100, squeeze(nansum(nanmean(glogem40(:,:,:),2),1)), 'LineWidth',2);
    oggm15 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/oggm_results/RGI',sprintf('%02d', region),'/vol_tot_ssp15.mat']);
    oggm20 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/oggm_results/RGI',sprintf('%02d', region),'/vol_tot_ssp20.mat']);
    oggm27 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/oggm_results/RGI',sprintf('%02d', region),'/vol_tot_ssp27.mat']);
    oggm30 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/oggm_results/RGI',sprintf('%02d', region),'/vol_tot_ssp30.mat']);
    oggm40 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/oggm_results/RGI',sprintf('%02d', region),'/vol_tot_ssp40.mat']);
    oggm50 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/oggm_results/RGI',sprintf('%02d', region),'/vol_tot_ssp50.mat']);
    plot(2000:2100, squeeze(nansum(nanmean(oggm15(:,:,:),2),1)), '--', 'LineWidth',2);
    plot(2000:2100, squeeze(nansum(nanmean(oggm27(:,:,:),2),1)), '--', 'LineWidth',2, 'Color', 'k');
    plot(2000:2100, squeeze(nansum(nanmean(oggm40(:,:,:),2),1)), '--', 'LineWidth',2);
end
    set(gca, 'fontsize', 20)
    ylabel('Total ice volume (km^3)');

subplot(2,2,2)
difference = 0;
base_volume_pygem = squeeze(nansum(nanmean(pygem40(:,:,20),2),1));
base_volume_glogem = squeeze(nansum(nanmean(glogem40(:,:,20),2),1));
base_volume_oggm = squeeze(nansum(nanmean(oggm40(:,:,20),2),1));

if difference == 1
    sealevel_pygem = [squeeze(nansum(nanmean(pygem15(:,:,end),2),1)) - base_volume_pygem;...
                  squeeze(nansum(nanmean(pygem20(:,:,end),2),1)) - base_volume_pygem;...
                  squeeze(nansum(nanmean(pygem27(:,:,end),2),1)) - base_volume_pygem;...
                  squeeze(nansum(nanmean(pygem30(:,:,end),2),1)) - base_volume_pygem;...
                  squeeze(nansum(nanmean(pygem40(:,:,end),2),1)) - base_volume_pygem;...
                  squeeze(nansum(nanmean(pygem50(:,:,end),2),1)) - base_volume_pygem];

    sealevel_glogem = [squeeze(nansum(nanmean(glogem15(:,:,end),2),1)) - base_volume_glogem;...
                  squeeze(nansum(nanmean(glogem20(:,:,end),2),1)) - base_volume_glogem;...
                  squeeze(nansum(nanmean(glogem27(:,:,end),2),1)) - base_volume_glogem;...
                  squeeze(nansum(nanmean(glogem30(:,:,end),2),1)) - base_volume_glogem;...
                  squeeze(nansum(nanmean(glogem40(:,:,end),2),1)) - base_volume_glogem;...
                  squeeze(nansum(nanmean(glogem50(:,:,end),2),1)) - base_volume_glogem];

    sealevel_oggm = [squeeze(nansum(nanmean(oggm15(:,:,end),2),1)) - base_volume_oggm;...
                  squeeze(nansum(nanmean(oggm20(:,:,end),2),1)) - base_volume_oggm;...
                  squeeze(nansum(nanmean(oggm27(:,:,end),2),1)) - base_volume_oggm;...
                  squeeze(nansum(nanmean(oggm30(:,:,end),2),1)) - base_volume_oggm;...
                  squeeze(nansum(nanmean(oggm40(:,:,end),2),1)) - base_volume_oggm;...
                  squeeze(nansum(nanmean(oggm50(:,:,end),2),1)) - base_volume_oggm];

    plot(abs(sealevel_pygem * 0.9167 / 361.8));
    hold on
    plot(abs(sealevel_glogem * 0.9167  / 361.8));
    plot(abs(sealevel_oggm * 0.9167  / 361.8));
    xticks(1:6); % Ensure ticks are placed at positions 1 to 6
    xticklabels({'+1.5°C', '+2°C', '+2.7°C', '+3°C', '+4°C', '+5°C'});
    xlabel('Global Temperature Increase');
    ylabel('Sea Level Rise');
    set(gca, 'fontsize', 20)
else
    sealevel_pygem = [squeeze(nansum(nanmean(pygem15(:,:,end),2),1))./base_volume_pygem;...
                  squeeze(nansum(nanmean(pygem20(:,:,end),2),1))./base_volume_pygem;...
                  squeeze(nansum(nanmean(pygem27(:,:,end),2),1))./base_volume_pygem;...
                  squeeze(nansum(nanmean(pygem30(:,:,end),2),1))./base_volume_pygem;...
                  squeeze(nansum(nanmean(pygem40(:,:,end),2),1))./base_volume_pygem;...
                  squeeze(nansum(nanmean(pygem50(:,:,end),2),1))./base_volume_pygem];

    sealevel_glogem = [squeeze(nansum(nanmean(glogem15(:,:,end),2),1))./base_volume_glogem;...
                  squeeze(nansum(nanmean(glogem20(:,:,end),2),1))./base_volume_glogem;...
                  squeeze(nansum(nanmean(glogem27(:,:,end),2),1))./base_volume_glogem;...
                  squeeze(nansum(nanmean(glogem30(:,:,end),2),1))./base_volume_glogem;...
                  squeeze(nansum(nanmean(glogem40(:,:,end),2),1))./base_volume_glogem;...
                  squeeze(nansum(nanmean(glogem50(:,:,end),2),1))./base_volume_glogem];

    sealevel_oggm = [squeeze(nansum(nanmean(oggm15(:,:,end),2),1))./base_volume_oggm;...
                  squeeze(nansum(nanmean(oggm20(:,:,end),2),1))./base_volume_oggm;...
                  squeeze(nansum(nanmean(oggm27(:,:,end),2),1))./base_volume_oggm;...
                  squeeze(nansum(nanmean(oggm30(:,:,end),2),1))./base_volume_oggm;...
                  squeeze(nansum(nanmean(oggm40(:,:,end),2),1))./base_volume_oggm;...
                  squeeze(nansum(nanmean(oggm50(:,:,end),2),1))./base_volume_oggm];


    plot(-100 * (1-sealevel_pygem), ':', 'linewidth', 2);
    hold on
    plot(-100 * (1-sealevel_glogem), 'linewidth', 2);
    plot(-100 * (1-sealevel_oggm), '--', 'linewidth', 2);
    xticks(1:6); % Ensure ticks are placed at positions 1 to 6
    xticklabels({'+1.5°C', '+2°C', '+2.7°C', '+3°C', '+4°C', '+5°C'});
    xlabel('Global Temperature Increase');
    ylabel('Volume change vs 2020 (%)');
    ylim([-100 0])
    set(gca, 'fontsize', 20)
end

