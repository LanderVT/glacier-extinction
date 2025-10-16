

clear all
clc


%%

templevels = readtable('temp_levels.xlsx');
gcms = string(templevels{:,1});
ssps = string(templevels{:,2});
folderPath = '/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results';
file = [folderPath,'/glac_area_annual/',sprintf('%02d', 11),'/R',sprintf('%02d', 11),'_glac_area_annual_ssp585_MCMC_ba1_1sets_2000_2100_all.nc'];
glac_area = ncread(file, 'glac_area_annual');
gcms_pygem = ncread(file, 'Climate_Model');

index_15 = find(templevels{:,4} > 1.1 & templevels{:,4} < 1.6 & ismember(gcms, gcms_pygem) & ~contains(ssps, 'ssp119') & ~contains(ssps, 'ssp534-over') & ~contains(ssps, 'ssp434') & ~contains(ssps, 'ssp460'));
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

% templevels = readtable("batch_models.dat");
% gcms = string(templevels{:,3});
% experiment = [];
% ssp = [];
% for g = 1:size(gcms_glogem)
%     subset = char(gcms_glogem(g));
%     experiment{g} = subset(end-11:end-4);
%     ssp{g} = subset(end-18:end-13);
% end
% experiment = experiment';
% index_15 = find(templevels{:,4} > 1.2 & templevels{:,4} < 1.8 & contains(experiment,'r1i1p1') & ~contains(templevels{:,3}, 'CAMS') & ~contains(ssp', 'ssp119') & ~contains(ssp', 'ssp434') & ~contains(ssp', 'ssp460'));
% index_20 = find(templevels{:,4} > 1.49 & templevels{:,4} < 2.3 & contains(experiment,'r1i1p1') & ~contains(templevels{:,3}, 'CAMS')& ~contains(ssp', 'ssp119') & ~contains(ssp', 'ssp434') & ~contains(ssp', 'ssp460'));
% index_27 = find(templevels{:,4} > 2.2 & templevels{:,4} < 3.2 & contains(experiment,'r1i1p1') & ~contains(templevels{:,3}, 'CAMS')& ~contains(ssp', 'ssp119') & ~contains(ssp', 'ssp434') & ~contains(ssp', 'ssp460'));
% index_30 = find(templevels{:,4} > 2.4 & templevels{:,4} < 3.4 & contains(experiment,'r1i1p1') & ~contains(templevels{:,3}, 'CAMS')& ~contains(ssp', 'ssp119') & ~contains(ssp', 'ssp434') & ~contains(ssp', 'ssp460'));
% index_40 = find(templevels{:,4} > 3.5 & templevels{:,4} < 4.5 & contains(experiment,'r1i1p1') & ~contains(templevels{:,3}, 'CAMS')& ~contains(ssp', 'ssp119') & ~contains(ssp', 'ssp434') & ~contains(ssp', 'ssp460'));
% index_50 = find(templevels{:,4} > 4.5 & templevels{:,4} < 5.3 & contains(experiment,'r1i1p1') & ~contains(templevels{:,3}, 'CAMS')& ~contains(ssp', 'ssp119') & ~contains(ssp', 'ssp434') & ~contains(ssp', 'ssp460'));
% temps_15 = median(templevels{index_15,4});
% temps_20 = median(templevels{index_20,4});
% temps_27 = median(templevels{index_27,4});
% temps_30 = median(templevels{index_30,4});
% temps_40 = median(templevels{index_40,4});
% temps_50 = median(templevels{index_50,4});

%%
% Define the folder path
folderPath = '/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/';

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

% Generate matrices
nr_glaciers = [26785, 18804, 4295, 7068, 19030, 566, 1601, ...
               3403, 1068, 5080, 3905, 1856, 54266, 27823, ...
               13023, 2932, 15820, 3514, 2183];

for r = [1:size(rgis,2)

    disp(['Region running = ', regions_n{r}])

    vol_tot_ssp15 = nan(nr_glaciers(r),1,101);
    vol_tot_ssp20 = nan(nr_glaciers(r),1,101);
    vol_tot_ssp27 = nan(nr_glaciers(r),1,101);
    vol_tot_ssp30 = nan(nr_glaciers(r),1,101);
    vol_tot_ssp40 = nan(nr_glaciers(r),1,101);
    vol_tot_ssp50 = nan(nr_glaciers(r),1,101);

    area_tot_ssp15 = vol_tot_ssp15;
    area_tot_ssp20 = vol_tot_ssp20;
    area_tot_ssp27 = vol_tot_ssp27;
    area_tot_ssp30 = vol_tot_ssp30;
    area_tot_ssp40 = vol_tot_ssp40;
    area_tot_ssp50 = vol_tot_ssp50;

    % Get a list of all files in the folder
    folderPath_rgi = [folderPath,rgis{r}];
    files = dir(folderPath_rgi);

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

            sspName = ssps{index(q)};
            gcmName = gcms{index(q)};
            fullPath = fullfile(folderPath_rgi, gcmName);
            volfile = [fullPath,'/', sspName,'/', regions_n{r},'_Volume_r1.dat'];
            areafile = [fullPath,'/', sspName,'/', regions_n{r},'_Area_r1.dat'];
            

            if exist(volfile) && contains(gcmName, 'CAMS') == 0

                countclim = countclim + 1;
                data1 = readtable(volfile);
                data2 = readtable(areafile);
                for v = 2:size(data1,1)
                    rgi_nr = data1{v,1};
                    if p == 1
                        vol_tot_ssp15(rgi_nr,countclim,:) = data1{v,end-100:end};
                        area_tot_ssp15(rgi_nr,countclim,:) = data2{v,end-100:end};
                    elseif p == 2
                        vol_tot_ssp20(rgi_nr,countclim,:) = data1{v,end-100:end};
                        area_tot_ssp20(rgi_nr,countclim,:) = data2{v,end-100:end};
                    elseif p == 3
                        vol_tot_ssp27(rgi_nr,countclim,:) = data1{v,end-100:end};
                        area_tot_ssp27(rgi_nr,countclim,:) = data2{v,end-100:end};
                    elseif p == 4
                        vol_tot_ssp30(rgi_nr,countclim,:) = data1{v,end-100:end};
                        area_tot_ssp30(rgi_nr,countclim,:) = data2{v,end-100:end};
                    elseif p == 5
                        vol_tot_ssp40(rgi_nr,countclim,:) = data1{v,end-100:end};
                        area_tot_ssp40(rgi_nr,countclim,:) = data2{v,end-100:end};
                    elseif p == 6
                        vol_tot_ssp50(rgi_nr,countclim,:) = data1{v,end-100:end};
                        area_tot_ssp50(rgi_nr,countclim,:) = data2{v,end-100:end};
                    end
                end
            end
        end
    end

    save([folderPath_rgi,'/area_tot_ssp15'], 'area_tot_ssp15')
    save([folderPath_rgi,'/area_tot_ssp20'], 'area_tot_ssp20')
    save([folderPath_rgi,'/area_tot_ssp27'], 'area_tot_ssp27')
    save([folderPath_rgi,'/area_tot_ssp30'], 'area_tot_ssp30')
    save([folderPath_rgi,'/area_tot_ssp40'], 'area_tot_ssp40')
    save([folderPath_rgi,'/area_tot_ssp50'], 'area_tot_ssp50')
    save([folderPath_rgi,'/vol_tot_ssp15'], 'vol_tot_ssp15')
    save([folderPath_rgi,'/vol_tot_ssp20'], 'vol_tot_ssp20')
    save([folderPath_rgi,'/vol_tot_ssp27'], 'vol_tot_ssp27')
    save([folderPath_rgi,'/vol_tot_ssp30'], 'vol_tot_ssp30')
    save([folderPath_rgi,'/vol_tot_ssp40'], 'vol_tot_ssp40')
    save([folderPath_rgi,'/vol_tot_ssp50'], 'vol_tot_ssp50')

end

%%
region = r;

glogem15 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp15.mat']);
glogem20 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp20.mat']);
glogem27 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp27.mat']);
glogem30 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp30.mat']);
glogem40 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/RGI',sprintf('%02d', region),'/vol_tot_ssp40.mat']);
plot(2000:2100, squeeze(nansum(nanmean(glogem15(:,:,:),2),1)), 'LineWidth',2);
hold on
plot(2000:2100, squeeze(nansum(nanmean(glogem20(:,:,:),2),1)), 'LineWidth',2);
plot(2000:2100, squeeze(nansum(nanmean(glogem27(:,:,:),2),1)), 'LineWidth',2);
plot(2000:2100, squeeze(nansum(nanmean(glogem30(:,:,:),2),1)), 'LineWidth',2);
plot(2000:2100, squeeze(nansum(nanmean(glogem40(:,:,:),2),1)), 'LineWidth',2);
