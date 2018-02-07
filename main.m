addpath('\\hi2crsmb\external\wan4hi\Code\Bounding_Box_Cropping_in_wild_v1.2\src');
addpath('\\hi2crsmb\external\wan4hi\Code\code_from_others\jsonlab');

ori_dat = loadjson('\\hi2crsmb\external\wan4hi\Daten\Semantic_Segmentation\Bounding_Box_Test\pose_result_json\Test_Snapshots_Pose.json');% change json path
new_dat = [ori_dat{1,:}];
dinfo = dir('\\hi2crsmb\external\wan4hi\Daten\Semantic_Segmentation\Bounding_Box_Test\sem_seg_result\overlayed\*.png');% change pic path
names_cell ={dinfo.name};
bw_path = '\\hi2crsmb\external\wan4hi\Daten\Semantic_Segmentation\Bounding_Box_Test\sem_seg_result\class_index';% change sem_seg input path
output_path = '\\hi2crsmb\external\wan4hi\Code\Bounding_Box_Cropping_in_wild_v1.2\cropped_image';% change output path

% uncomment the following lines if you have different image format
% names_cell{1} = [];
% names_cell{2} = [];
% emptycell = cellfun('isempty', names_cell);
% names_cell(emptycell) = [];

ans_cell = struct;
ans_cell = setfield(ans_cell,'image_name',{});
ans_cell = setfield(ans_cell,'ID',[]);
ans_cell = setfield(ans_cell,'Path_of_saved_cropped_images',{});
erg_cell = {};

colors = {[255, 0, 0], [255, 85, 0], [255, 170, 0], [255, 255, 0], [170, 255, 0], [85, 255, 0], [0, 255, 0], ...
          [0, 255, 85], [0, 255, 170], [0, 255, 255], [0, 170, 255], [0, 85, 255], [0, 0, 255], [85, 0, 255], ...          
          [170, 0, 255], [255, 0, 255], [255, 0, 170], [255, 0, 85]};
for i = 1:length(names_cell) % change here to debug
    ans_cell.image_name = names_cell{i};
    ans_cell.ID = [];
    ans_cell.Path_of_saved_cropped_images = {};
    
    figure(2*i-1)
    I = imread(names_cell{i});
    
    BW = imread(strcat(bw_path, '\', names_cell{i}));
    BW = double(BW == 1);
    
    [bool_img jsonrow_idx] = ismember(i,[new_dat.image_id]);
    if i ~= length(names_cell)
        [bool_img jsonrow_idxEnd] = ismember(i+1,[new_dat.image_id]);
    else
        jsonrow_idxEnd = length(new_dat)+1;
    end
    res = zeros(1,2);
    res(1) = size(I,2);
    res(2) = size(I,1);
    imshow(I,'InitialMagnification',100);
    dir_name = names_cell{i};
    mkdir(output_path, dir_name(1:end-4)); % change end-3 when jpeg
    folderPath = strcat(output_path, '\', dir_name(1:end-4));% change end-3 when jpeg
    cd(folderPath);
    for j = jsonrow_idx:jsonrow_idxEnd-1 %change here to debug
        KPshow_json(new_dat, j, jsonrow_idxEnd - jsonrow_idx);
        
        if new_dat(j).keypoints([18 21 36 39]) == 1 % only when keypoints for both shoulders and hips are visible can the parallelogram be drawn.
            crop_img = paralelogram_draw(new_dat(j),res,I,BW);
            ans_cell.ID = [ans_cell.ID j-jsonrow_idx+1];
            imwrite(crop_img,strcat(int2str(j-jsonrow_idx+1),'.png'));
            ans_cell.Path_of_saved_cropped_images{j-jsonrow_idx+1} = strcat(folderPath,'\',strcat(int2str(j-jsonrow_idx+1),'.png'));
        end
    end
    if ~isempty(ans_cell.ID)
        figure(2*i)        
        for k = 1:length(ans_cell.ID)
            switch fix((length(ans_cell.ID)-1) / 5)
                case 0
                    subplot(1,5,k);
                case 1
                    subplot(2,5,k);
                case 2
                    subplot(3,5,k);
                case 3
                    subplot(4,5,k);
            end
            imshow(ans_cell.Path_of_saved_cropped_images{ans_cell.ID(k)});
        end
    end
    erg_cell{i} = ans_cell;
    cd('..')
end
