
%% Clear all data

clear all
clc


%% General figures

% Loop over RGIs
rgis = {'RGI01', 'RGI02', 'RGI03', 'RGI04', 'RGI05', 'RGI06',...
        'RGI07', 'RGI08', 'RGI09', 'RGI10', 'RGI11', 'RGI12',...
        'RGI13', 'RGI14', 'RGI15', 'RGI16', 'RGI17', 'RGI18', 'RGI19'};

% Loop over SSPs
sspNames = {'/ssp126', '/ssp245', '/ssp370', '/ssp585'};

% Loop over regions
regions_n = {'alaska','westerncanada','arcticcanadaN','arcticcanadaS',...
            'greenland','iceland','svalbard',...
            'scandinavia','russianarctic','northasia',...
            'centraleurope','caucasus', 'centralasiaN','centralasiaW',...
            'centralasiaS','lowlat itudes','southernandes','newzealand',...
            'antarctic'};

% Select a glacier model or using the combination of all models
%run = 'glogem';
%run = 'pygem';
%run = 'oggm';
run = 'combo';

% Area threshold = 0.01 km2
limit_area = 0.01;

% Volume threshold = 1% of initial volume (can also be 5% or 10%)
limit_volume = 0.01;

% Smooth the area to remove artefacts of snowy years
smooth_area = 5;

% Year untill which (since 2000), we take the mean of all GCMs/SSPs (might 
% be needed for some models to be consistent. If 1, not used.
year_avg = 1;

% Create empty matrices for results
list_areas_hit = zeros(19,42);
list_vol_hit = zeros(19,42);

% Loop over RGI's
for r = [1:19]

    rgi = rgis{r};

    % Load volume for different warming levels 
    % PyGEM
    vol_tot_pygem_40 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results/',rgi,'/vol_tot_ssp40.mat']);
    vol_tot_pygem_27 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results/',rgi,'/vol_tot_ssp27.mat']);
    vol_tot_pygem_20 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results/',rgi,'/vol_tot_ssp20.mat']);
    vol_tot_pygem_15 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results/',rgi,'/vol_tot_ssp15.mat']);
    mean_vol = 1/4 .* squeeze(nanmean(vol_tot_pygem_15(:,1:size(vol_tot_pygem_15,2),1:24),2)) + squeeze(nanmean(vol_tot_pygem_20(:,1:size(vol_tot_pygem_20,2),1:24),2)) + squeeze(nanmean(vol_tot_pygem_27(:,1:size(vol_tot_pygem_27,2),1:24),2)) + squeeze(nanmean(vol_tot_pygem_40(:,1:size(vol_tot_pygem_40,2),1:24),2));
    for q = 1:size(vol_tot_pygem_40,2)
        vol_tot_pygem_40(:,q,1:24) = mean_vol; 
    end
    for q = 1:size(vol_tot_pygem_27,2)
        vol_tot_pygem_27(:,q,1:24) = mean_vol; 
    end
    for q = 1:size(vol_tot_pygem_20,2)
        vol_tot_pygem_20(:,q,1:24) = mean_vol; 
    end
    for q = 1:size(vol_tot_pygem_15,2)
        vol_tot_pygem_15(:,q,1:24) = mean_vol; 
    end
    
    % GloGEM
    vol_tot_glogem_40 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/',rgi,'/vol_tot_ssp40.mat']);
    vol_tot_glogem_27 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/',rgi,'/vol_tot_ssp27.mat']);
    vol_tot_glogem_20 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/',rgi,'/vol_tot_ssp20.mat']);
    vol_tot_glogem_15 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/',rgi,'/vol_tot_ssp15.mat']);
    mean_vol = 1/4 .* squeeze(nanmean(vol_tot_glogem_15(:,1:size(vol_tot_glogem_15,2),1:24),2)) + squeeze(nanmean(vol_tot_glogem_20(:,1:size(vol_tot_glogem_20,2),1:24),2)) + squeeze(nanmean(vol_tot_glogem_27(:,1:size(vol_tot_glogem_27,2),1:24),2)) + squeeze(nanmean(vol_tot_glogem_40(:,1:size(vol_tot_glogem_40,2),1:24),2));
    for q = 1:size(vol_tot_glogem_40,2)
        vol_tot_glogem_40(:,q,1:24) = mean_vol; 
    end
    for q = 1:size(vol_tot_glogem_27,2)
        vol_tot_glogem_27(:,q,1:24) = mean_vol; 
    end
    for q = 1:size(vol_tot_glogem_20,2)
        vol_tot_glogem_20(:,q,1:24) = mean_vol; 
    end
    for q = 1:size(vol_tot_glogem_15,2)
        vol_tot_glogem_15(:,q,1:24) = mean_vol; 
    end
    
    % OGGM
    vol_tot_oggm_40 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/oggm_results/',rgi,'/vol_tot_ssp40.mat']);
    vol_tot_oggm_27 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/oggm_results/',rgi,'/vol_tot_ssp27.mat']);
    vol_tot_oggm_20 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/oggm_results/',rgi,'/vol_tot_ssp20.mat']);
    vol_tot_oggm_15 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/oggm_results/',rgi,'/vol_tot_ssp15.mat']);
    mean_vol = 1/4 .* squeeze(nanmean(vol_tot_oggm_15(:,1:size(vol_tot_oggm_15,2),1:24),2)) + squeeze(nanmean(vol_tot_oggm_20(:,1:size(vol_tot_oggm_20,2),1:24),2)) + squeeze(nanmean(vol_tot_oggm_27(:,1:size(vol_tot_oggm_27,2),1:24),2)) + squeeze(nanmean(vol_tot_oggm_40(:,1:size(vol_tot_oggm_40,2),1:24),2));
    for q = 1:size(vol_tot_oggm_40,2)
        vol_tot_oggm_40(:,q,1:24) = mean_vol; 
    end
    for q = 1:size(vol_tot_oggm_27,2)
        vol_tot_oggm_27(:,q,1:24) = mean_vol; 
    end
    for q = 1:size(vol_tot_oggm_20,2)
        vol_tot_oggm_20(:,q,1:24) = mean_vol; 
    end
    for q = 1:size(vol_tot_oggm_15,2)
        vol_tot_oggm_15(:,q,1:24) = mean_vol; 
    end

    % Load area for different warming levels 
    % PyGEM
    area_tot_pygem_40 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results/',rgi,'/area_tot_ssp40.mat']);
    area_tot_pygem_27 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results/',rgi,'/area_tot_ssp27.mat']);
    area_tot_pygem_20 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results/',rgi,'/area_tot_ssp20.mat']);
    area_tot_pygem_15 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/pygem_results/',rgi,'/area_tot_ssp15.mat']);
    mean_area = round(1/4 .* squeeze(nanmean(area_tot_pygem_15(:,1:size(vol_tot_pygem_15,2),1:24),2)) + squeeze(nanmean(area_tot_pygem_20(:,1:size(vol_tot_pygem_20,2),1:24),2)) + squeeze(nanmean(area_tot_pygem_27(:,1:size(vol_tot_pygem_27,2),1:24),2)) + squeeze(nanmean(area_tot_pygem_40(:,1:size(vol_tot_pygem_40,2),1:24),2)),5);
    for q = 1:size(vol_tot_pygem_40,2)
        area_tot_pygem_40(:,q,1:year_avg) = mean_area(:, 1:year_avg); 
    end
    for q = 1:size(vol_tot_pygem_27,2)
        area_tot_pygem_27(:,q,1:year_avg) = mean_area(:, 1:year_avg);
    end
    for q = 1:size(vol_tot_pygem_20,2)
        area_tot_pygem_20(:,q,1:year_avg) = mean_area(:, 1:year_avg);
    end
    for q = 1:size(vol_tot_pygem_15,2)
        area_tot_pygem_15(:,q,1:year_avg) = mean_area(:, 1:year_avg); 
    end
    area_tot_pygem_15(find(area_tot_pygem_15(:,1,1) == 0),:,:) = nan;
    area_tot_pygem_20(find(area_tot_pygem_20(:,1,1) == 0),:,:) = nan;
    area_tot_pygem_27(find(area_tot_pygem_27(:,1,1) == 0),:,:) = nan;
    area_tot_pygem_40(find(area_tot_pygem_40(:,1,1) == 0),:,:) = nan;
    
    % GloGEM 
    area_tot_glogem_40 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/',rgi,'/area_tot_ssp40.mat']);
    area_tot_glogem_27 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/',rgi,'/area_tot_ssp27.mat']);
    area_tot_glogem_20 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/',rgi,'/area_tot_ssp20.mat']);
    area_tot_glogem_15 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/glogem_results/',rgi,'/area_tot_ssp15.mat']);
    mean_area = 1/4 .* squeeze(nanmedian(area_tot_glogem_15(:,1:size(vol_tot_glogem_15,2),1:24),2)) + squeeze(nanmean(area_tot_glogem_20(:,1:size(vol_tot_glogem_20,2),1:24),2)) + squeeze(nanmean(area_tot_glogem_27(:,1:size(vol_tot_glogem_27,2),1:24),2)) + squeeze(nanmean(area_tot_glogem_40(:,1:size(vol_tot_glogem_40,2),1:24),2));
    for q = 1:size(vol_tot_glogem_40,2)
        area_tot_glogem_40(:,q,1:year_avg) = mean_area(:, 1:year_avg); 
    end
    for q = 1:size(vol_tot_glogem_27,2)
        area_tot_glogem_27(:,q,1:year_avg) = mean_area(:, 1:year_avg); 
    end
    for q = 1:size(vol_tot_glogem_20,2)
        area_tot_glogem_20(:,q,1:year_avg) = mean_area(:, 1:year_avg); 
    end
    for q = 1:size(vol_tot_glogem_15,2)
        area_tot_glogem_15(:,q,1:year_avg) = mean_area(:, 1:year_avg); 
    end
    [rv,tv]=find(area_tot_glogem_15(:,1,1:year_avg) < 0.01);
    area_tot_glogem_15(rv,:,:) = nan;
    area_tot_glogem_20(rv,:,:) = nan;
    area_tot_glogem_27(rv,:,:) = nan;
    area_tot_glogem_40(rv,:,:) = nan;
    
    % OGGM 
    area_tot_oggm_40 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/oggm_results/',rgi,'/area_tot_ssp40.mat']);
    area_tot_oggm_27 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/oggm_results/',rgi,'/area_tot_ssp27.mat']);
    area_tot_oggm_20 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/oggm_results/',rgi,'/area_tot_ssp20.mat']);
    area_tot_oggm_15 = importdata(['/Users/landervantricht/Documents/PostDoc/Projects/Glacier_Extinction/oggm_results/',rgi,'/area_tot_ssp15.mat']);
    mean_area = 1/4 .* squeeze(nanmean(area_tot_oggm_15(:,1:size(vol_tot_oggm_15,2),1:24),2)) + squeeze(nanmean(area_tot_oggm_20(:,1:size(vol_tot_oggm_20,2),1:24),2)) + squeeze(nanmean(area_tot_oggm_27(:,1:size(vol_tot_oggm_27,2),1:24),2)) + squeeze(nanmean(area_tot_oggm_40(:,1:size(vol_tot_oggm_40,2),1:24),2));
    for q = 1:size(vol_tot_oggm_40,2)
        area_tot_oggm_40(:,q,1:year_avg) = mean_area(:, 1:year_avg); 
    end
    for q = 1:size(vol_tot_oggm_27,2)
        area_tot_oggm_27(:,q,1:year_avg) = mean_area(:, 1:year_avg);
    end
    for q = 1:size(vol_tot_oggm_20,2)
        area_tot_oggm_20(:,q,1:year_avg) = mean_area(:, 1:year_avg);
    end
    for q = 1:size(vol_tot_oggm_15,2)
        area_tot_oggm_15(:,q,1:year_avg) = mean_area(:, 1:year_avg);
    end
    area_tot_oggm_15(find(area_tot_oggm_15(:,1,1) == 0),:,:) = nan;
    area_tot_oggm_20(find(area_tot_oggm_20(:,1,1) == 0),:,:) = nan;
    area_tot_oggm_27(find(area_tot_oggm_27(:,1,1) == 0),:,:) = nan;
    area_tot_oggm_40(find(area_tot_oggm_40(:,1,1) == 0),:,:) = nan;
    
    % Merge models
    if contains(run, 'combo')
        % Maximum glacier ID of any of the models
        maxer = min(size(area_tot_pygem_40,1),size(area_tot_glogem_40,1), size(area_tot_oggm_40,1));
        % Merge the area data (and perform moving mean)
        area_tot_40 = [movmean(area_tot_pygem_40(1:maxer,:,:),smooth_area,3),movmean(area_tot_glogem_40(1:maxer,:,:),smooth_area,3),movmean(area_tot_oggm_40(1:maxer,:,:),smooth_area,3)];
        area_tot_27 = [movmean(area_tot_pygem_27(1:maxer,:,:),smooth_area,3),movmean(area_tot_glogem_27(1:maxer,:,:),smooth_area,3),movmean(area_tot_oggm_27(1:maxer,:,:),smooth_area,3)];
        area_tot_20 = [movmean(area_tot_pygem_20(1:maxer,:,:),smooth_area,3),movmean(area_tot_glogem_20(1:maxer,:,:),smooth_area,3),movmean(area_tot_oggm_20(1:maxer,:,:),smooth_area,3)];
        area_tot_15 = [movmean(area_tot_pygem_15(1:maxer,:,:),smooth_area,3),movmean(area_tot_glogem_15(1:maxer,:,:),smooth_area,3),movmean(area_tot_oggm_15(1:maxer,:,:),smooth_area,3)];
        % Merge the volume data
        vol_tot_40 = [vol_tot_pygem_40(1:maxer,:,:),vol_tot_glogem_40(1:maxer,:,:),vol_tot_oggm_40(1:maxer,:,:)];
        vol_tot_27 = [vol_tot_pygem_27(1:maxer,:,:),vol_tot_glogem_27(1:maxer,:,:),vol_tot_oggm_27(1:maxer,:,:)];
        vol_tot_20 = [vol_tot_pygem_20(1:maxer,:,:),vol_tot_glogem_20(1:maxer,:,:),vol_tot_oggm_20(1:maxer,:,:)];
        vol_tot_15 = [vol_tot_pygem_15(1:maxer,:,:),vol_tot_glogem_15(1:maxer,:,:),vol_tot_oggm_15(1:maxer,:,:)];
    % Only using GloGEM
    elseif contains(run, 'glogem')
        area_tot_40 = [area_tot_glogem_40];
        area_tot_27 = [area_tot_glogem_27];
        area_tot_20 = [area_tot_glogem_20];
        area_tot_15 = [area_tot_glogem_15];
        vol_tot_40 = [vol_tot_glogem_40];
        vol_tot_27 = [vol_tot_glogem_27];
        vol_tot_20 = [vol_tot_glogem_20];
        vol_tot_15 = [vol_tot_glogem_15];
    % Only using PyGEM
    elseif contains(run, 'pygem')
        area_tot_40 = [area_tot_pygem_40];
        area_tot_27 = [area_tot_pygem_27];
        area_tot_20 = [area_tot_pygem_20];
        area_tot_15 = [area_tot_pygem_15];
        vol_tot_40 = [vol_tot_pygem_40];
        vol_tot_27 = [vol_tot_pygem_27];
        vol_tot_20 = [vol_tot_pygem_20];
        vol_tot_15 = [vol_tot_pygem_15];
    % Only using OGGM
    elseif contains(run, 'oggm')
        area_tot_40 = [area_tot_oggm_40];
        area_tot_27 = [area_tot_oggm_27];
        area_tot_20 = [area_tot_oggm_20];
        area_tot_15 = [area_tot_oggm_15];
        vol_tot_40 = [vol_tot_oggm_40];
        vol_tot_27 = [vol_tot_oggm_27];
        vol_tot_20 = [vol_tot_oggm_20];
        vol_tot_15 = [vol_tot_oggm_15];
    end

    % Initialise results
    year_no = [];

    % Loop through all glaciers 
    for t = 1:size(area_tot_27,2)
        for i = 1:size(area_tot_27,1)
            if t <= size(area_tot_40,2)
                area_glac = round(squeeze(area_tot_40(i,t,:)),5);
                vol_glac = squeeze(vol_tot_40(i,t,:));
                % Save year of the multi-model mean
                [idy1] = find(area_glac < limit_area);
                [idy2] = find(vol_glac < limit_volume .* vol_glac(1));
                if ~isempty(idy1) | ~isempty(idy2)
                    if ~isempty(idy1) & ~isempty(idy2)
                        year_no_40_mean_result(r, i,t) = min(idy1(1), idy2(1)) + 2000;
                    elseif ~isempty(idy1)
                        year_no_40_mean_result(r, i,t) = idy1(1) + 2000;
                    elseif ~isempty(idy2)
                        year_no_40_mean_result(r, i,t) = idy2(1) + 2000;
                    end
                else
                    year_no_40_mean_result(r, i,t) = nan;
                end
            end
            if t <= size(area_tot_27,2)
                area_glac = round(squeeze(area_tot_27(i,t,:)),5);
                vol_glac = squeeze(vol_tot_27(i,t,:));
                % Save year of the multi-model mean
                [idy1] = find(area_glac < limit_area);
                [idy2] = find(vol_glac < limit_volume .* vol_glac(1));
                if ~isempty(idy1) | ~isempty(idy2)
                    if ~isempty(idy1) & ~isempty(idy2)
                        year_no_27_mean_result(r, i,t) = min(idy1(1), idy2(1)) + 2000;
                        if idy1(1) < idy2(1)
                            list_areas_hit(r,t) = list_areas_hit(r,t) + 1; 
                        else
                            list_vol_hit(r,t) = list_vol_hit(r,t) + 1;
                        end
                    elseif ~isempty(idy1)
                        year_no_27_mean_result(r, i,t) = idy1(1) + 2000;
                        list_areas_hit(r,t) = list_areas_hit(r,t) + 1; 
                    elseif ~isempty(idy2)
                        year_no_27_mean_result(r, i,t) = idy2(1) + 2000;
                        list_vol_hit(r,t) = list_vol_hit(r,t) + 1; 
                    end
                else
                    year_no_27_mean_result(r, i,t) = nan;
                end

            end
            if t <= size(area_tot_20,2)
                area_glac = round(squeeze(area_tot_20(i,t,:)),5);
                vol_glac = squeeze(vol_tot_20(i,t,:));
                % Save year of the multi-model mean
                [idy1] = find(area_glac < limit_area);
                [idy2] = find(vol_glac < limit_volume .* vol_glac(1));
                if ~isempty(idy1) | ~isempty(idy2)
                    if ~isempty(idy1) & ~isempty(idy2)
                        year_no_20_mean_result(r, i,t) = min(idy1(1), idy2(1)) + 2000;
                    elseif ~isempty(idy1)
                        year_no_20_mean_result(r, i,t) = idy1(1) + 2000;
                    elseif ~isempty(idy2)
                        year_no_20_mean_result(r, i,t) = idy2(1) + 2000;
                    end
                else
                    year_no_20_mean_result(r, i,t) = nan;
                end
            end
            if t <= size(area_tot_15,2)
                area_glac = round(squeeze(area_tot_15(i,t,:)),5);
                vol_glac = squeeze(vol_tot_15(i,t,:));
                % Save year of the multi-model mean
                [idy1] = find(area_glac < limit_area);
                [idy2] = find(vol_glac < limit_volume .* vol_glac(1));
                if ~isempty(idy1) | ~isempty(idy2)
                    if ~isempty(idy1) & ~isempty(idy2)
                        year_no_15_mean_result(r, i,t) = min(idy1(1), idy2(1)) + 2000;
                    elseif ~isempty(idy1)
                        year_no_15_mean_result(r, i,t) = idy1(1) + 2000;
                    elseif ~isempty(idy2)
                        year_no_15_mean_result(r, i,t) = idy2(1) + 2000;
                    end
                else
                    year_no_15_mean_result(r, i,t) = nan;
                end
            end
        end

        for a = 1:101
            years_con = a + 2000;
            if t <= size(area_tot_40,2)
                list_years_40_tot(r,a,t) = sum(year_no_40_mean_result(r, :,t) == years_con);
            end       
            if t <= size(area_tot_27,2)
                list_years_27_tot(r,a,t) = sum(year_no_27_mean_result(r, :,t) == years_con);
            end
            if t <= size(area_tot_20,2)
                list_years_20_tot(r,a,t) = sum(year_no_20_mean_result(r, :,t) == years_con);
            end
            if t <= size(area_tot_15,2)
                list_years_15_tot(r,a,t) = sum(year_no_15_mean_result(r, :,t) == years_con);
            end
        end
    end
   
   
    % Function of size
    year_no_40_mean(r, 1:size(area_tot_40,1)) = round(squeeze(nanmean(area_tot_40(:,:,1),2)),5);
    year_no_27_mean(r, 1:size(area_tot_40,1)) = round(squeeze(nanmean(area_tot_27(:,:,1),2)),5);
    year_no_20_mean(r, 1:size(area_tot_40,1)) = round(squeeze(nanmean(area_tot_20(:,:,1),2)),5);
    year_no_15_mean(r, 1:size(area_tot_40,1)) = round(squeeze(nanmean(area_tot_15(:,:,1),2)),5);

    % Show the size of glaciers as a function of warming
    size_function_tlevels

    % Three options here
    %% Option 1 -> Mean of all the extinction curves
    % tmp = squeeze(nanmean(list_years_40_tot(:,:,:),3));
    % list_years_40(r,:) = tmp(r,:);
    % tmp = squeeze(nanmean(list_years_27_tot(:,:,:),3));
    % list_years_27(r,:) = tmp(r,:);
    % tmp = squeeze(nanmean(list_years_20_tot(:,:,:),3));
    % list_years_20(r,:) = tmp(r,:); 
    % tmp = squeeze(nanmean(list_years_15_tot(:,:,:),3));
    % list_years_15(r,:) = tmp(r,:);

    %% Option 2 -> Median of the cumulative curves
    % tmp = squeeze(median(cumsum(list_years_40_tot(:,:,:),2),3));
    % list_years_40(r,:) = [0,tmp(r,2:end) - tmp(r,1:end-1)];
    % tmp = squeeze(median(cumsum(list_years_27_tot(:,:,:),2),3));
    % list_years_27(r,:) = [0,tmp(r,2:end) - tmp(r,1:end-1)];
    % tmp = squeeze(median(cumsum(list_years_20_tot(:,:,:),2),3));
    % list_years_20(r,:) = [0,tmp(r,2:end) - tmp(r,1:end-1)];
    % tmp = squeeze(median(cumsum(list_years_15_tot(:,:,:),2),3));
    % list_years_17(r,:) = [0,tmp(r,2:end) - tmp(r,1:end-1)];

    %% Option 3 -> Median year for each glacier
    ra40 = sort(squeeze(year_no_40_mean_result(r,:,:)),2);
    ra40_med = ra40(:,round(size(ra40,2)/2));
    ra40_max = ra40(:,round(size(ra40,2)/2) + round(size(ra40,2)/4));
    ra40_min = ra40(:,round(size(ra40,2)/2) - round(size(ra40,2)/4));
    ra27 = sort(squeeze(year_no_27_mean_result(r,:,:)),2);
    ra27_med = ra27(:,round(size(ra27,2)/2));
    ra27_max = ra27(:,round(size(ra27,2)/2) + round(size(ra27,2)/4));
    ra27_min = ra27(:,round(size(ra27,2)/2) - round(size(ra27,2)/4));
    ra20 = sort(squeeze(year_no_20_mean_result(r,:,:)),2);
    ra20_med = ra20(:,round(size(ra20,2)/2));
    ra20_max = ra20(:,round(size(ra20,2)/2) + round(size(ra20,2)/4));
    ra20_min = ra20(:,round(size(ra20,2)/2) - round(size(ra20,2)/4));
    ra15 = sort(squeeze(year_no_15_mean_result(r,:,:)),2);
    ra15_med = ra15(:,round(size(ra15,2)/2));
    ra15_max = ra15(:,round(size(ra15,2)/2) + round(size(ra15,2)/4));
    ra15_min = ra15(:,round(size(ra15,2)/2) - round(size(ra15,2)/4));

    % Determine how many glaciers are lost in a particular year 
    for a = 1:101
        years_con = a + 2000;
        list_years_40(r,a) = sum(ra40_med == years_con);
        list_years_27(r,a) = sum(ra27_med == years_con);
        list_years_20(r,a) = sum(ra20_med == years_con);
        list_years_15(r,a) = sum(ra15_med == years_con);
        list_years_40_max(r,a) = sum(ra40_max == years_con);
        list_years_27_max(r,a) = sum(ra27_max == years_con);
        list_years_20_max(r,a) = sum(ra20_max == years_con);
        list_years_15_max(r,a) = sum(ra15_max == years_con);
        list_years_40_min(r,a) = sum(ra40_min == years_con);
        list_years_27_min(r,a) = sum(ra27_min== years_con);
        list_years_20_min(r,a) = sum(ra20_min == years_con);
        list_years_15_min(r,a) = sum(ra15_min == years_con);
    end

    % Barplot for glacier numbers as a function of size (Fig. 2)
    bars_disappearence_multiple

close all

% Determine initial number of glaciers in 2025
initial_glaciers(r) = size(find(year_no_40_mean(r,:) > 0),2);
glac_lost_2025(r,1) = mean([sum(list_years_40(r,1:24)), sum(list_years_27(r,1:24)), sum(list_years_20(r,1:24)), sum(list_years_15(r,1:24))]);
glac_lost_2025(r,2) = round(100 .* ((glac_lost_2025(r,1) / initial_glaciers(r))));
initial_glacier_2025(r) = initial_glaciers(r) - glac_lost_2025(r,1);

% How many glaciers are left?
glac_left_15(r,1) = initial_glaciers(r) - sum(list_years_15(r,1:end));
glac_left_15(r,2) = -100.* (1-glac_left_15(r,1)/ initial_glacier_2025(r));
glac_left_15(r,3) = initial_glaciers(r) - sum(list_years_15_max(r,1:end));
glac_left_15(r,4) = initial_glaciers(r) - sum(list_years_15_min(r,1:end));
glac_left_20(r,1) = initial_glaciers(r) - sum(list_years_20(r,1:end));
glac_left_20(r,2) = -100.* (1-glac_left_20(r,1)/ initial_glacier_2025(r));
glac_left_20(r,3) = initial_glaciers(r) - sum(list_years_20_max(r,1:end));
glac_left_20(r,4) = initial_glaciers(r) - sum(list_years_20_min(r,1:end));
glac_left_27(r,1) = initial_glaciers(r) - sum(list_years_27(r,1:end));
glac_left_27(r,2) = -100.* (1-glac_left_27(r,1)/ initial_glacier_2025(r));
glac_left_27(r,3) = initial_glaciers(r) - sum(list_years_27_max(r,1:end));
glac_left_27(r,4) = initial_glaciers(r) - sum(list_years_27_min(r,1:end));
glac_left_40(r,1) = initial_glaciers(r) - sum(list_years_40(r,1:end));
glac_left_40(r,2) = -100.* (1-glac_left_40(r,1)/ initial_glacier_2025(r));
glac_left_40(r,3) = initial_glaciers(r) - sum(list_years_40_max(r,1:end));
glac_left_40(r,4) = initial_glaciers(r) - sum(list_years_40_min(r,1:end));


end



%% Show the results

% Colors of the IPCC
color_ssp585 = [115, 31, 30] / 255;
color_ssp126 = [60, 136, 167] / 255;
color_ssp245 = [0.928 0.572 0.172];
color_ssp370 = [223, 0, 0] / 255;

for rgi = [1:19]

% Create a figure
figure('Visible', 'off', 'units','normalized','outerposition',[0 0 1 1])

% Double smoothing for curves (can be varied)
smoothing = 10;
smoothing2 = 1;

subplot(2,2,1)
yyaxis left

% For global plot
if rgi == 20
    
    hold on
    scatter(2000:2100, sum(list_years_40(:,:),1), 50, 'filled', 'MarkerFaceColor', color_ssp585)
    scatter(2000:2100, sum(list_years_27(:,:),1), 50, 'filled', 'MarkerFaceColor', color_ssp370)
    scatter(2000:2100, sum(list_years_20(:,:),1), 50, 'filled', 'MarkerFaceColor', color_ssp245)
    scatter(2000:2100, sum(list_years_15(:,:),1), 50, 'filled', 'MarkerFaceColor', color_ssp126)
    interp_40 = sum(list_years_40(1:19,16:end));
    interp_27 = sum(list_years_27(1:19,16:end));
    interp_20 = sum(list_years_20(1:19,16:end));
    interp_15 = sum(list_years_15(1:19,16:end));
    smoothing_40 = smooth(2015:2100, interp_40, 0.3, 'lowess');
    smoothing_27 = smooth(2015:2100, interp_27, 0.3, 'lowess');
    smoothing_20 = smooth(2015:2100, interp_20, 0.3, 'lowess');
    smoothing_15 = smooth(2015:2100, interp_15, 0.3, 'lowess');
    plot(2015:2100, smoothing_40, '-', 'LineWidth', 3, 'Color', color_ssp585)
    plot(2015:2100, smoothing_27, '-', 'LineWidth', 3, 'Color', color_ssp370)
    plot(2015:2100, smoothing_20, '-', 'LineWidth', 3, 'Color', color_ssp245)
    plot(2015:2100, smoothing_15, '-', 'LineWidth', 3, 'Color', color_ssp126)
    xlim([2000 2100])

% For regional plots
else

    hold on
    scatter(2000:2100, list_years_40(rgi,:), 50, 'filled', 'MarkerFaceColor', color_ssp585)
    scatter(2000:2100, list_years_27(rgi,:), 50, 'filled', 'MarkerFaceColor', color_ssp370)
    scatter(2000:2100, list_years_20(rgi,:), 50, 'filled', 'MarkerFaceColor', color_ssp245)
    scatter(2000:2100, list_years_15(rgi,:), 50, 'filled', 'MarkerFaceColor', color_ssp126)
    interp_40 = list_years_40(rgi,16:end);
    interp_27 = list_years_27(rgi,16:end);
    interp_20 = list_years_20(rgi,16:end);
    interp_15 = list_years_15(rgi,16:end);
    smoothing_40 = smooth(2015:2100, interp_40, 0.3, 'lowess');
    smoothing_27 = smooth(2015:2100, interp_27, 0.3, 'lowess');
    smoothing_20 = smooth(2015:2100, interp_20, 0.3, 'lowess');
    smoothing_15 = smooth(2015:2100, interp_15, 0.3, 'lowess');
    plot(2015:2100, smoothing_40, '-', 'LineWidth', 3, 'Color', color_ssp585)
    plot(2015:2100, smoothing_27, '-', 'LineWidth', 3, 'Color', color_ssp370)
    plot(2015:2100, smoothing_20, '-', 'LineWidth', 3, 'Color', color_ssp245)
    plot(2015:2100, smoothing_15, '-', 'LineWidth', 3, 'Color', color_ssp126)
    xlim([2000 2100])
end

grid on

% Limits of the axes
if rgi == 7
    ylim([0 35])
elseif rgi == 8
    ylim([0 150])
elseif rgi == 1
    ylim([0 800])
elseif rgi == 2
    ylim([0 700])
elseif rgi == 3
    ylim([0 80])
elseif rgi == 4
    ylim([0 150])
elseif rgi == 5
    ylim([0 350])
elseif rgi == 9
    ylim([0 20])
elseif rgi == 10
    ylim([0 300])
elseif rgi == 12
    ylim([0 70])
elseif rgi == 13
    ylim([0 1400])
elseif rgi == 14
    ylim([0 1000])
elseif rgi == 15
    ylim([0 400])
elseif rgi == 16
    ylim([0 100])
elseif rgi == 17
    ylim([0 400])
elseif rgi == 18
    ylim([0 200])
elseif rgi == 6
    ylim([0 15])
elseif rgi == 19
    ylim([0 40])
end

% Settings for the figure
set(gca, 'fontsize', 26)
ax = gca;  % Get current axes
% Set both Y-axis labels to black
ax.YColor = 'k';  % Sets the color of both left & right y-axes
% Set both Y-axis tick labels to black
ax.YLabel.Color = 'k';
% Set the entire axis color (if needed)
ax.XColor = 'k';  % Also make x-axis black if necessary

xlim([2025 2100])

% How many glaciers lost (percentage)
yyaxis right

figure_probability

ax = gca;  % Get current axes
% Set both Y-axis labels to black
ax.YColor = 'k';  % Sets the color of both left & right y-axes
% Set both Y-axis tick labels to black
ax.YLabel.Color = 'k';
% Set the entire axis color (if needed)
ax.XColor = 'k';  % Also make x-axis black if necessary
ylim([0 100])

yticks([0 20 40 60 80 100]);

if  rgi == 1
    mountains = 'RGI01';
elseif  rgi == 14
    mountains = 'RGI14';
elseif  rgi == 4
    mountains = 'RGI04';
elseif  rgi == 2
    mountains = 'RGI02';
elseif  rgi == 3
    mountains = 'RGI03';
elseif  rgi == 12
    mountains = 'RGI12';
    yyaxis left
elseif  rgi == 10
    mountains = 'RGI10';
elseif  rgi == 6
    mountains = 'RGI06';
elseif  rgi == 7
    mountains = 'RGI07';
elseif  rgi == 8
    mountains = 'RGI08';
elseif  rgi == 9
    mountains = 'RGI09';
elseif  rgi == 10
    mountains = 'RGI10';
elseif  rgi == 13
    mountains = 'RGI13';
elseif  rgi == 15
    mountains = 'RGI15';
elseif  rgi == 17
    mountains = 'RGI17';
elseif  rgi == 18
    mountains = 'RGI18';
elseif  rgi == 16
    mountains = 'RGI16';
elseif  rgi == 20
    mountains = 'RGI20';
elseif  rgi == 19
    mountains = 'RGI19';
elseif  rgi == 5
    mountains = 'RGI05';
elseif  rgi == 11
    mountains = 'RGI11';
end

if rgi ~= 20
    set(gca, 'fontsize', 30)
else
    set(gca, 'fontsize', 25)
end

if rgi == 8 | rgi == 10 | rgi == 2 | rgi == 3 | rgi == 17 | rgi == 16 ...
        | rgi == 1 | rgi == 4 | rgi == 5 | rgi == 11 | rgi == 12 ...
        | rgi == 13 | rgi == 14 | rgi == 15 | rgi == 18 | rgi == 19
        xticklabels([])
end

yticks([0 20 40 60 80 100]);

name = ['../results_pre25/',mountains,'_disappearance_',run,'.pdf'];
fig=gcf;fig.PaperPositionMode='auto';
fig_pos=fig.PaperPosition;fig.PaperSize = [fig_pos(3) fig_pos(4)]; % Needed to have correct aspect in saved figure
exportgraphics(gcf,name,'BackgroundColor','none')
peakextinctionyear(rgi,1) = 15 + mean([find(smoothing_20 == max(smoothing_20)) + 2000,find(smoothing_15 == max(smoothing_15) + 2000),...
                    find(smoothing_27 == max(smoothing_27)) + 2000, find(smoothing_40 == max(smoothing_40)) + 2000]);
peakextinctionyear(rgi,2) = std([find(smoothing_20 == max(smoothing_20)) + 2000,find(smoothing_15 == max(smoothing_15) + 2000),...
                    find(smoothing_27 == max(smoothing_27)) + 2000, find(smoothing_40 == max(smoothing_40)) + 2000]); 

if rgi < 20
    peakextinctionyear(rgi,3) = initial_glaciers(rgi);
end

if rgi < 20
    a = year_no_40_mean(rgi,:)';
    a = a(a ~= 0);
    peakextinctionyear(rgi,4) = nanmedian(a);
    peakextinctionyear(rgi,5) = nanmean(vol_tot_27(:,1,1));
    peakextinctionyear(rgi,6) = nanmedian(area_tot_27(:,1,1));
    peakextinctionyear(rgi,7) = nanmedian(vol_tot_27(:,1,1));
end

peakextinctionyear(rgi,8) = rgi;
peakextinctionyear(rgi,9) = round(mean([
smoothing_15(round(peakextinctionyear(rgi,1) - 15 - 2000)), ...
smoothing_20(round(peakextinctionyear(rgi,1) - 15 - 2000)), ...
smoothing_27(round(peakextinctionyear(rgi,1) - 15 - 2000)), ...
smoothing_40(round(peakextinctionyear(rgi,1) - 15 - 2000))]));

peakextinctionyear(rgi,10) = round(std([
smoothing_15(round(peakextinctionyear(rgi,1) - 15 - 2000)), ...
smoothing_20(round(peakextinctionyear(rgi,1) - 15 - 2000)), ...
smoothing_27(round(peakextinctionyear(rgi,1) - 15 - 2000)), ...
smoothing_40(round(peakextinctionyear(rgi,1) - 15 - 2000))]));


% Fing the peaks

peaks_avg = find(smoothing_15 == max(smoothing_15)) + 15 + 2000;
peakextinctionyear(rgi,11) = peaks_avg(1);
peaks_avg = find(smoothing_20 == max(smoothing_20)) + 15 + 2000;
peakextinctionyear(rgi,12) = peaks_avg(1);
peaks_avg = find(smoothing_27 == max(smoothing_27)) + 15 + 2000;
peakextinctionyear(rgi,13) = peaks_avg(1);
peaks_avg = find(smoothing_40 == max(smoothing_40)) + 15 + 2000;
peakextinctionyear(rgi,14) = peaks_avg(1);

% Create piecharys figure
figure_piecharts

% For loop over all regions, close figures directly
close all

end


%% Overview figures and data

% === SORT AND PREPARE DATA ===
[values, sort_idx] = sortrows(peakextinctionyear(1:19,:), 3, 'ascend');
numBars = size(values, 1);
sorted_initial = initial_glaciers(sort_idx);

% === Glacier Number Loss (%) for SSPs ===
% SSP1-2.6
val_15 = glac_left_15(sort_idx, 2) ;
val_15_min = -100 .* (1 - glac_left_15(sort_idx, 3) ./ sorted_initial');
val_15_max = -100 .* (1 - glac_left_15(sort_idx, 4) ./ sorted_initial');

% SSP2-4.5
val_20 = glac_left_20(sort_idx, 2);
val_20_min = -100 .* (1 - glac_left_20(sort_idx, 3) ./ sorted_initial');
val_20_max = -100 .* (1 - glac_left_20(sort_idx, 4) ./ sorted_initial');

% SSP3-7.0
val_27 = glac_left_27(sort_idx, 2);
val_27_min = -100 .* (1 - glac_left_27(sort_idx, 3) ./ sorted_initial');
val_27_max = -100 .* (1 - glac_left_27(sort_idx, 4) ./ sorted_initial');

% SSP5-8.5
val_40 = glac_left_40(sort_idx, 2);
val_40_min = -100 .* (1 - glac_left_40(sort_idx, 3) ./ sorted_initial');
val_40_max = -100 .* (1 - glac_left_40(sort_idx, 4) ./ sorted_initial');

% Central bar values
bar_matrix_loss = [val_15, val_20, val_27, val_40];

% Asymmetric error bars (from central value to min/max)
error_low_matrix = [val_15 - min([val_15_min, val_15_max], [], 2), ...
                    val_20 - min([val_20_min, val_20_max], [], 2), ...
                    val_27 - min([val_27_min, val_27_max], [], 2), ...
                    val_40 - min([val_40_min, val_40_max], [], 2)];

error_high_matrix = [max([val_15_min, val_15_max], [], 2) - val_15, ...
                     max([val_20_min, val_20_max], [], 2) - val_20, ...
                     max([val_27_min, val_27_max], [], 2) - val_27, ...
                     max([val_40_min, val_40_max], [], 2) - val_40];

% Clean invalid values
bar_matrix_loss(~isfinite(bar_matrix_loss)) = 0;
error_low_matrix(~isfinite(error_low_matrix)) = 0;
error_high_matrix(~isfinite(error_high_matrix)) = 0;

% === Extinction Year (columns 11 to 14)
bar_matrix_extinction = values(:, 11:14);
error_matrix_extinction = zeros(size(bar_matrix_extinction));  % Placeholder

% === SSP Colors
color_ssp585 = [115, 31, 30] / 255;
color_ssp126 = [60, 136, 167] / 255;
color_ssp245 = [0.928, 0.572, 0.172];
color_ssp370 = [223, 0, 0] / 255;
ssp_colors = {color_ssp126, color_ssp245, color_ssp370, color_ssp585};

figure('units','normalized','outerposition',[0 0 1 1]);

ax1 = axes('Position', [0.08 0.1 0.335 0.85]);
hold(ax1, 'on');

total_width = 0.8;
num_groups = size(bar_matrix_loss, 2);
individual_width = total_width / num_groups;

for i = 1:num_groups
    y = (1:numBars) - total_width/2 + (i - 0.5) * individual_width;
    barh(ax1, y, bar_matrix_loss(:,i), ...
        'BarWidth', individual_width, ...
        'FaceColor', ssp_colors{i}, ...
        'FaceAlpha', 0.85);

    errorbar(ax1, bar_matrix_loss(:,i), y, ...
        error_low_matrix(:,i), error_high_matrix(:,i), ...
        'horizontal', 'k', 'LineStyle', 'none', 'LineWidth', 1.2, 'CapSize', 4);
end

xlim(ax1, [-100 0]);
yticks(ax1, []);
yticklabels(ax1, []);
xlabel(ax1, 'Glacier number loss (%)', 'FontSize', 16);
grid(ax1, 'on');
set(ax1, 'FontSize', 30, 'Box', 'off');

% ===== RIGHT PANEL: Peak Extinction Year
ax2 = axes('Position', [0.615 0.1 0.335 0.85]);
hold(ax2, 'on');

num_groups_ext = size(bar_matrix_extinction, 2);
individual_width_ext = total_width / num_groups_ext;

for i = 1:num_groups_ext
    y_ext = (1:numBars) - total_width/2 + (i - 0.5) * individual_width_ext;
    barh(ax2, y_ext, bar_matrix_extinction(:,i), ...
        'BarWidth', individual_width_ext, ...
        'FaceColor', ssp_colors{i}, ...
        'FaceAlpha', 0.85);

end

xlim(ax2, [2025 2100]);
yticks(ax2, []);
yticklabels(ax2, []);
xlabel(ax2, 'Peak extinction year', 'FontSize', 16);
grid(ax2, 'on');
set(ax2, 'FontSize', 30, 'Box', 'off');

% ===== EXPORT
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
exportgraphics(fig, 'peaks.pdf', ...
    'ContentType', 'vector', ...
    'BackgroundColor', 'none');

%% Figure response times (data of Zekollari et al., 2025)

figure('units','normalized','outerposition',[0 0 1 1])
response_times_zeko = readtable('response_timescale.xlsx');
responsetime = [120, 60, 650, 250, 400, 320, 320, 170, 450, 55, ...
                50, 40, 110, 170, 55, 30, 100, 60, 800];
responsetime = response_times_zeko{2:end,32};

% === SUBPLOT 1: Linear regression of response time vs extinction year ===

% Linear model on 1:18
x = responsetime(1:19);
y = peakextinctionyear(1:19,13);

subplot(2,2,2)
% Scatter and regression line
scatter(x, y, 100, 'filled', 'MarkerFaceColor', [0.2 0.6 0.8],     ...
    'MarkerFaceColor', color_ssp370, ...
    'MarkerEdgeColor', 'k')  % Thin black edge
hold on
x(9) = nan;
x(19) = nan;
x(3) = nan;
mdl = fitlm(x, y)
scatter(x, y, 200, 'filled', 'MarkerFaceColor', [0.2 0.6 0.8],     ...
    'MarkerFaceColor', color_ssp370, ...
    'MarkerEdgeColor', 'k')  % Thin black edge
xlabel('Response timescale (yr)')
ylabel('Peak extinction year')
grid on
set(gca, 'FontSize', 25)
ylim([2025 2101])
set(gca, 'XScale', 'log')  % set x-axis to logarithmic

% === SUBPLOT 2: Response time vs glacier number loss (SSP3-7.0) ===
x = responsetime(1:19);
subplot(2,2,1)
scatter(x, glac_left_27(:,2), ...
    100, 'filled', ...
    'MarkerFaceColor', color_ssp370, ...
    'MarkerEdgeColor', 'k')  % Thin black edge
hold on
x(9) = nan;
x(19) = nan;
x(3) = nan;
scatter(x, glac_left_27(:,2), ...
    200, 'filled', ...
    'MarkerFaceColor', color_ssp370, ...
    'MarkerEdgeColor', 'k')  % Thin black edge
xlabel('Response timescale (yr)')
ylabel('Glacier number loss (%)')
grid on
set(gca, 'FontSize', 25)
y = glac_left_27(:,2);
mdl = fitlm(x, y)
set(gca, 'XScale', 'log')  % set x-axis to logarithmic

subplot(2,2,3)
% Scatter and regression line
scatter(peakextinctionyear(:,4), y, 100, 'filled', 'MarkerFaceColor', [0.2 0.6 0.8],     ...
    'MarkerFaceColor', color_ssp370, ...
    'MarkerEdgeColor', 'k')  % Thin black edge
hold on
xlabel('Median glacier size (km^2)')
ylabel('Glacier number loss (%)')
grid on
set(gca, 'FontSize', 25)
set(gca, 'XScale', 'log')  % set x-axis to logarithmic
x = peakextinctionyear(:,4);
x(9) = nan;
x(19) = nan;
x(3) = nan;
scatter(x, y, 200, 'filled', 'MarkerFaceColor', [0.2 0.6 0.8],     ...
    'MarkerFaceColor', color_ssp370, ...
    'MarkerEdgeColor', 'k')  % Thin black edge
mdl = fitlm(x, y)

y = peakextinctionyear(1:19,13);
subplot(2,2,4)
% Scatter and regression line
scatter(peakextinctionyear(:,4), y, 100, 'filled', 'MarkerFaceColor', [0.2 0.6 0.8],     ...
    'MarkerFaceColor', color_ssp370, ...
    'MarkerEdgeColor', 'k')  % Thin black edge
hold on
xlabel('Median glacier size (km^2)')
ylabel('Peak extinction year')
grid on
set(gca, 'FontSize', 25)
ylim([2025 2101])
set(gca, 'XScale', 'log')  % set x-axis to logarithmic
x = peakextinctionyear(:,4);
x(9) = nan;
x(19) = nan;
x(3) = nan;
scatter(x, y, 200, 'filled', 'MarkerFaceColor', [0.2 0.6 0.8],     ...
    'MarkerFaceColor', color_ssp370, ...
    'MarkerEdgeColor', 'k')  % Thin black edge
mdl = fitlm(x, y)

% ===== EXPORT
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
exportgraphics(fig, 'reponsetime.pdf', ...
    'ContentType', 'vector', ...
    'BackgroundColor', 'none');

%% Figure Area Log

figure('units','normalized','outerposition',[0 0 1 1])

years = 2000:2100;
mean_alps = sort(squeeze(nanmean(area_tot_ssp245(:,:,:),2)));

% Define bin edges for initial area
bin_edges = 0:0.05:100; % Bins from 0 to 100 km² in 0.5 km² intervals
num_bins = length(bin_edges) - 1;
binned_avg = NaN(num_bins, length(years)); % Initialize with NaNs
bin_counts = zeros(num_bins, 1); % Count number of glaciers per bin

% Compute the average area within each bin and count glaciers
for b = 1:num_bins
    in_bin = mean_alps(:,1) >= bin_edges(b) & mean_alps(:,1) < bin_edges(b+1);
    
    if any(in_bin) % Only compute if there are glaciers in the bin
        binned_avg(b, :) = mean(mean_alps(in_bin, :), 1, 'omitnan');
        bin_counts(b) = sum(in_bin); % Store the number of glaciers in each bin
    end
end

% **Plot results on a logarithmic Y-axis**
hold on;
set(gca, 'YScale', 'log'); % Ensure Y-axis is logarithmic

colors = lines(num_bins); % Generate distinct colors for bins

% **Define line width scaling**
min_width = 2; % Minimum line width
max_width = 20; % Maximum line width
if max(bin_counts) > 0
    line_widths = min_width + (max_width - min_width) * (bin_counts - min(bin_counts)) / (max(bin_counts) - min(bin_counts));
else
    line_widths = ones(num_bins, 1) * min_width; % Default to min width if no data
end

for b = 1:num_bins
    valid_idx = ~isnan(binned_avg(b, :)); % Remove NaN values
    if any(valid_idx)
        plot(years(valid_idx), binned_avg(b, valid_idx), 'Color', colors(b, :), 'LineWidth', line_widths(b));
    end
end

% **Add reference line at y = 0.01 km²**
yline(0.01, 'r--', 'LineWidth', 2);

% **Labels and title**
xlabel('Year');
ylabel('Glacier Area (km²)');
title('Glacier Area Over Time');
grid on;

% **Adjust Y-axis limits (ensure no zero values)**
ylim([10^-2, 100]);


%% RMSE linear

figure('units','normalized','outerposition',[0 0 1 1])

% Extract bar heights and error values
values = R_squared;
bar_values = values;  % Heights of bars (first column)

% Define x-axis labels as "RGI01" to "RGI20"
numBars = length(bar_values);
x_labels = arrayfun(@(x) sprintf('RGI%02d', x), 1:numBars, 'UniformOutput', false);

% Normalize values to range between 1 and the number of colormap colors
normalized_values = (bar_values - min(bar_values)) / (max(bar_values) - min(bar_values));
color_indices = round(normalized_values * (numBars - 1)) + 1; % Ensure positive integer indices

% Define a red-to-white colormap
cmap = flip([linspace(1,1,numBars)', linspace(1,0,numBars)', linspace(1,0,numBars)']); % White to Red
cmap = [linspace(1,0,numBars)', zeros(numBars,1), linspace(0,1,numBars)']; % Red to Blue gradient

% Create the bar plot
bar_handle = bar(bar_values, 'FaceColor', 'flat'); 

% Apply the colormap to bars
colormap(cmap);
bar_handle.CData = cmap(color_indices, :); % Assign colors using corrected integer indices

% Hold plot for error bars
hold on;

% Format the plot
xticks(1:numBars);
xticklabels(x_labels);
xtickangle(45); % Rotate x-axis labels for better visibility
xticklabels([])
%title('Peak Extinction Year');
grid on;

% Adjust figure appearance
set(gca, 'FontSize', 20, 'Box', 'off'); % Improve appearance

hold off;

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];  % Ensure correct aspect ratio
name = ['linears.pdf'];
exportgraphics(gcf, name, 'ContentType', 'vector', 'BackgroundColor', 'none');

close all

%%

figure('units','normalized','outerposition',[0 0 1 1])
clc
subplot(2,2,1)
for p = 1:4
    if p == 1
        A = sort(full_years_15,2) + 2000;
        B = A;
    elseif p == 2
        A = sort(full_years_20,2) + 2000;
        B = A;
    elseif p == 3
        A = sort(full_years_27,2) + 2000;
        B = A;
    else
        A = sort(full_years_40,2) + 2000;
        B = A;
    end
count = [];
years_g = [];
for r = 1:3927
    if isempty(find(~isnan(A(r,:)))) == 0
        values_known = arrayfun(@(x) sum(B(r,:) <= x), A(r,:));
        years_known = A(r,:);

        years_known = years_known(:);
        values_known = values_known(:);

        [years_unique, ~, idx_group] = unique(years_known);
        values_max = accumarray(idx_group, values_known, [], @max);

        values_max = [0;values_max];
        years_unique = [2000;years_unique];

        % Ensure both vectors are finite
        is_valid = isfinite(years_unique) & isfinite(values_max);

        % Filter out bad values
        years_unique = years_unique(is_valid);
        values_max   = values_max(is_valid);

        years_interp = 2000:2100;
        if years_unique(2) ~= years_unique(1)
            values_interp = interp1(years_unique, values_max, years_interp, 'previous', 'extrap');
            count(r,:) = values_interp;
            years_g(r,:) = years_interp;
        end
    end
end


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

for a = 1:101
        years_con = a + 2000;
        list_years_40_prob50(a,p) = sum(year_50 + 2000 == years_con); 
        list_years_40_prob75(a,p) = sum(year_75 + 2000 == years_con); 
        list_years_40_prob25(a,p) = sum(year_25 + 2000 == years_con); 
        list_years_40_prob100(a,p) = sum(year_100 + 2000 == years_con); 
        list_years_40_prob10(a,p) = sum(year_10 + 2000 == years_con); 
end

end

hold on

x_fill = [2000:2100, fliplr(2000:2100)];
y_fill = [(cumsum(list_years_40_prob25(:,4)) ./ 3927 .* 100)', fliplr((cumsum(list_years_40_prob75(:,4)) ./ 3927 .* 100)')];
fill(x_fill, y_fill, color_ssp585,'FaceAlpha', 0.3, 'EdgeColor', 'none');  % Light blue fill
y_fill = [(cumsum(list_years_40_prob25(:,3)) ./ 3927 .* 100)', fliplr((cumsum(list_years_40_prob75(:,3)) ./ 3927 .* 100)')];
fill(x_fill, y_fill, color_ssp370, 'FaceAlpha', 0.3, 'EdgeColor', 'none');  % Light blue fill
y_fill = [(cumsum(list_years_40_prob25(:,2)) ./ 3927 .* 100)', fliplr((cumsum(list_years_40_prob75(:,2)) ./ 3927 .* 100)')];
fill(x_fill, y_fill, color_ssp245, 'FaceAlpha', 0.3, 'EdgeColor', 'none');  % Light blue fill
y_fill = [(cumsum(list_years_40_prob25(:,1)) ./ 3927 .* 100)', fliplr((cumsum(list_years_40_prob75(:,1)) ./ 3927 .* 100)')];
fill(x_fill, y_fill, color_ssp126, 'FaceAlpha', 0.3, 'EdgeColor', 'none');  % Light blue fill


set(gca, 'fontsize', 20)
hold on
grid on
ylabel('Glaciers disappeared (%)')
xlabel('Year')

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];  % Ensure correct aspect ratio
name = ['results/',rgi,'_probability.pdf'];
exportgraphics(gcf, name, 'ContentType', 'vector', 'BackgroundColor', 'none');

