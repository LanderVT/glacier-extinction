


clear all
clc

%% Temp levels

templevels = readtable('temp_levels.xlsx');
gcms_temps = string(templevels{:,1});
ssps_temps = string(templevels{:,2});
folderPath = '/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results';
file = [folderPath,'/glac_area_annual/',sprintf('%02d', 11),'/R',sprintf('%02d', 11),'_glac_area_annual_ssp585_MCMC_ba1_1sets_2000_2100_all.nc'];
glac_area = ncread(file, 'glac_area_annual');
gcms_pygem = ncread(file, 'Climate_Model');

index_15 = find(templevels{:,4} > 1.1 & templevels{:,4} < 1.8 & ismember(gcms_temps, gcms_pygem) & ~contains(ssps_temps, 'ssp119'));
index_20 = find(templevels{:,4} > 1.5 & templevels{:,4} < 2.45  & ismember(gcms_temps, gcms_pygem) & ~contains(ssps_temps, 'ssp119'));
index_27 = find(templevels{:,4} > 2.2 & templevels{:,4} < 3.4 & ismember(gcms_temps, gcms_pygem) & ~contains(ssps_temps, 'ssp119'));
index_30 = find(templevels{:,4} > 2.5 & templevels{:,4} < 3.4 & ismember(gcms_temps, gcms_pygem) & ~contains(ssps_temps, 'ssp119'));
index_40 = find(templevels{:,4} > 3.7 & templevels{:,4} < 4.4 & ismember(gcms_temps, gcms_pygem) & ~contains(ssps_temps, 'ssp119'));
index_50 = find(templevels{:,4} > 4.4 & templevels{:,4} < 5.4 & ismember(gcms_temps, gcms_pygem) & ~contains(ssps_temps, 'ssp119'));

temps_15 = median(templevels{index_15,4})
temps_20 = median(templevels{index_20,4})
temps_27 = median(templevels{index_27,4})
temps_30 = median(templevels{index_30,4})
temps_40 = median(templevels{index_40,4})
temps_50 = median(templevels{index_50,4})

%% Define the folder path

conversion = 900;

folderPath = '/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results';

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
%rgi_nr = [1:12,16,18];

for r = [11]

    disp(['Region running = ', regions_n{r}])

    file = [folderPath,'/glac_area_annual/',sprintf('%02d', r),'/R',sprintf('%02d', r),'_glac_area_annual_ssp585_MCMC_ba1_1sets_2000_2100_all.nc'];
    glac_area = ncread(file, 'glac_area_annual');
    gcms = ncread(file, 'Climate_Model');
    time = ncread(file, 'time');
    rgis_list = ncread(file, 'RGIId');
    for a = 1:size(rgis_list,1)
        tmp = rgis_list{a};
        rgi_nr(a,1) = str2double(tmp(end-4:end));
    end

    vol_tot_ssp15 = nan(max(rgi_nr),1,101);
    vol_tot_ssp20 = nan(max(rgi_nr),1,101);
    vol_tot_ssp27 = nan(max(rgi_nr),1,101);
    vol_tot_ssp30 = nan(max(rgi_nr),1,101);
    vol_tot_ssp40 = nan(max(rgi_nr),1,101);
    vol_tot_ssp50 = nan(max(rgi_nr),1,101);

    area_tot_ssp15 = vol_tot_ssp15;
    area_tot_ssp20 = vol_tot_ssp20;
    area_tot_ssp27 = vol_tot_ssp27;
    area_tot_ssp30 = vol_tot_ssp30;
    area_tot_ssp40 = vol_tot_ssp40;
    area_tot_ssp50 = vol_tot_ssp50;

    for p = 1:5

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
            file = [folderPath,'/glac_area_annual/',sprintf('%02d', r),'/R',sprintf('%02d', r),'_glac_area_annual_',sspName,'_MCMC_ba1_1sets_2000_2100_all.nc'];
            file2 = [folderPath,'/glac_mass_annual/',sprintf('%02d', r),'/R',sprintf('%02d', r),'_glac_mass_annual_',sspName,'_MCMC_ba1_1sets_2000_2100_all.nc'];
            if exist(file)
                glac_area = ncread(file, 'glac_area_annual');
                glac_vol = ncread(file2, 'glac_mass_annual');
                idx = find(gcms == gcms_temps{index(q)});
                if isempty(idx) ~= 1
                    glac_area = glac_area(:,:,idx)';
                    glac_vol = glac_vol(:,:,idx)';
                    countclim = countclim + 1;
                    for w = 1:size(rgis_list,1)
                        rginumber = rgi_nr(w);
                        if p == 1
                            vol_tot_ssp15(rginumber,countclim,:) = glac_vol(w,2:end) ./ 1000000000 ./ conversion;
                            area_tot_ssp15(rginumber,countclim,:) = glac_area(w,2:end) ./ 1000000;
                        elseif p == 2
                            vol_tot_ssp20(rginumber,countclim,:) = glac_vol(w,2:end) ./ 1000000000 ./ conversion;
                            area_tot_ssp20(rginumber,countclim,:) = glac_area(w,2:end) ./ 1000000;
                        elseif p == 3
                            vol_tot_ssp27(rginumber,countclim,:) = glac_vol(w,2:end) ./ 1000000000 ./ conversion;
                            area_tot_ssp27(rginumber,countclim,:) = glac_area(w,2:end) ./ 1000000;
                        elseif p == 4
                            vol_tot_ssp30(rginumber,countclim,:) = glac_vol(w,2:end) ./ 1000000000 ./ conversion;
                            area_tot_ssp30(rginumber,countclim,:) = glac_area(w,2:end) ./ 1000000;
                        elseif p == 5
                            vol_tot_ssp40(rginumber,countclim,:) = glac_vol(w,2:end) ./ 1000000000 ./ conversion;
                            area_tot_ssp40(rginumber,countclim,:) = glac_area(w,2:end) ./ 1000000;
                        elseif p == 6
                            vol_tot_ssp50(rginumber,countclim,:) = glac_vol(w,2:end) ./ 1000000000 ./ conversion;
                            area_tot_ssp50(rginumber,countclim,:) = glac_area(w,2:end) ./ 1000000;
                        end
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

    clear rgi_nr
end
%%
 

% glogem_test = importdata('/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI11/vol_tot_ssp20.mat');
% r = squeeze(mean(glogem_test(:,:,:),2));
% plot(2000:2100, nansum(r(:,:)))
% hold on
% py_test = importdata('/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results/RGI11/vol_tot_ssp20.mat');
% r2 = squeeze(mean(py_test(:,:,:),2));
% plot(2000:2100, nansum(r2(:,:)))

%%

close all
rgi = [];
region = r;
if ~isempty(rgi)
    plot(2000:2100, squeeze(nanmean(vol_tot_ssp15(rgi,:,:),2)));
    hold on
    plot(2000:2100, squeeze(nanmean(vol_tot_ssp27(rgi,:,:),2)));
    plot(2000:2100, squeeze(nanmean(vol_tot_ssp40(rgi,:,:),2)));
    hold on
    glogem15 = importdata('/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI',num2str(region),'/vol_tot_ssp15.mat');
    glogem27 = importdata('/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI',num2str(region),'/vol_tot_ssp27.mat');
    glogem40 = importdata('/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI',num2str(region),'/vol_tot_ssp40.mat');
    plot(2000:2100, squeeze(nanmean(glogem15(rgi,:,:),2)), 'LineWidth',2);
    plot(2000:2100, squeeze(nanmean(glogem27(rgi,:,:),2)), 'LineWidth',2);
    plot(2000:2100, squeeze(nanmean(glogem40(rgi,:,:),2)), 'LineWidth',2);
else
    plot(2000:2100, squeeze(nansum(nanmean(vol_tot_ssp15(:,:,:),2),1)));
    hold on
    plot(2000:2100, squeeze(nansum(nanmean(vol_tot_ssp27(:,:,:),2),1)));
    plot(2000:2100, squeeze(nansum(nanmean(vol_tot_ssp30(:,:,:),2),1)));
    plot(2000:2100, squeeze(nansum(nanmean(vol_tot_ssp40(:,:,:),2),1)));
    hold on
    glogem15 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp15.mat']);
    glogem27 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp27.mat']);
    glogem30 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp30.mat']);
    glogem40 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp40.mat']);
    plot(2000:2100, squeeze(nansum(nanmean(glogem15(:,:,:),2),1)), 'LineWidth',2);
    plot(2000:2100, squeeze(nansum(nanmean(glogem27(:,:,:),2),1)), 'LineWidth',2);
    plot(2000:2100, squeeze(nansum(nanmean(glogem30(:,:,:),2),1)), 'LineWidth',2);
    plot(2000:2100, squeeze(nansum(nanmean(glogem40(:,:,:),2),1)), 'LineWidth',2);
end

