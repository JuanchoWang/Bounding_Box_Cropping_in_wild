function crop_J = paralelogram_draw(per_dat, res, img, bw_img)

colors = {[255, 0, 0], [255, 85, 0], [255, 170, 0], [255, 255, 0], [170, 255, 0], [85, 255, 0], [0, 255, 0], ...
          [0, 255, 85], [0, 255, 170], [0, 255, 255], [0, 170, 255], [0, 85, 255], [0, 0, 255], [85, 0, 255], ...          
          [170, 0, 255], [255, 0, 255], [255, 0, 170], [255, 0, 85]};
      
upper_body_p = zeros(2,1);
lower_body_p = upper_body_p;
upper_body_p(1) = mean(per_dat.keypoints([16 19])); 
upper_body_p(2) = mean(per_dat.keypoints([17 20]));
lower_body_p(1) = mean(per_dat.keypoints([34 37])); 
lower_body_p(2) = mean(per_dat.keypoints([35 38])); 

% line(gca,[upper_body_p(1) lower_body_p(1)], [upper_body_p(2) lower_body_p(2)],'Color','w');

% determine the normal and orthogonal vector of the vertical axis for chosen
% person
ori_linev = upper_body_p - lower_body_p;
len_spline = sqrt(ori_linev(1)^2 + ori_linev(2)^2);
% normal_linev = 1/sqrt(ori_linev(1)^2 + ori_linev(2)^2);
% normal_linev = normal_linev * [-ori_linev(2); ori_linev(1)];
% bias_c = - dot(normal_linev, upper_body_p);
ori_linev = ori_linev/sqrt(ori_linev(1)^2 + ori_linev(2)^2);
% bias_co = - dot(ori_linev, upper_body_p);

% determine the angle for rotation
rot_ang = atan(ori_linev(1)/ori_linev(2));
if ori_linev(2) > 0
    rot_ang = pi + rot_ang;
end
J = imrotate(img,-rot_ang/pi*180);
new_res = zeros(1,2);
new_res(1) = size(J,2);
new_res(2) = size(J,1);
rot_mat = [cos(rot_ang) -sin(rot_ang); sin(rot_ang) cos(rot_ang)]; 

% display all the keypoints index for chosen person
new_kp = [];
bw_region = bw_img;
for k = 1:17
    if per_dat.keypoints(k*3) == 1
        rectangle(gca, 'Position', [per_dat.keypoints(3*k-2)-0.5 per_dat.keypoints(3*k-1)-0.5 1 1],'LineWidth',2,'EdgeColor',colors{k}/255);
        text(gca,per_dat.keypoints(3*k-2),per_dat.keypoints(3*k-1),int2str(k),'Color','y');
        new_keypoint = rot_mat*[[per_dat.keypoints(3*k-2); per_dat.keypoints(3*k-1)]-[res(1); res(2)]/2] + [new_res(1); new_res(2)]/2;
        new_kp = [new_kp; new_keypoint'];
        bw_region = bwselect(bw_region, per_dat.keypoints(3*k-2), per_dat.keypoints(3*k-1));% import semantic segmentation result
    end
end

temp_mat = sortrows(new_kp);
min_horizp = temp_mat(1,:);
max_horizp = temp_mat(end,:);
temp_mat = sortrows(new_kp, 2);
min_vertip = temp_mat(1,:);
max_vertip = temp_mat(end,:);

% correct the lower vertical points if some keypoints not detected
hip_mat = zeros(2,2);
hip_mat(:,1) = rot_mat*[[per_dat.keypoints(34); per_dat.keypoints(35)]-[res(1); res(2)]/2] + [new_res(1); new_res(2)]/2;
hip_mat(:,2) = rot_mat*[[per_dat.keypoints(37); per_dat.keypoints(38)]-[res(1); res(2)]/2] + [new_res(1); new_res(2)]/2;
hip_mat = sortrows(hip_mat',2);
sho_mat = zeros(2,2);
sho_mat(:,1) = rot_mat*[[per_dat.keypoints(16); per_dat.keypoints(17)]-[res(1); res(2)]/2] + [new_res(1); new_res(2)]/2;
sho_mat(:,2) = rot_mat*[[per_dat.keypoints(19); per_dat.keypoints(20)]-[res(1); res(2)]/2] + [new_res(1); new_res(2)]/2;
sho_mat = sortrows(sho_mat',2);
kne_mat = zeros(2,2);

if per_dat.keypoints(42) == 1 && per_dat.keypoints(45) == 1
    kne_mat(:,1) = rot_mat*[[per_dat.keypoints(40); per_dat.keypoints(41)]-[res(1); res(2)]/2] + [new_res(1); new_res(2)]/2;
    kne_mat(:,2) = rot_mat*[[per_dat.keypoints(43); per_dat.keypoints(44)]-[res(1); res(2)]/2] + [new_res(1); new_res(2)]/2;
    kne_mat = sortrows(kne_mat',2);
else
    kne_mat = zeros(2,1);
    if per_dat.keypoints(42) == 1
        kne_mat = rot_mat*[[per_dat.keypoints(40); per_dat.keypoints(41)]-[res(1); res(2)]/2] + [new_res(1); new_res(2)]/2;
    end
    if per_dat.keypoints(45) == 1
        kne_mat = rot_mat*[[per_dat.keypoints(43); per_dat.keypoints(44)]-[res(1); res(2)]/2] + [new_res(1); new_res(2)]/2;
    end
    kne_mat = kne_mat';
end

if (max_vertip(2) == hip_mat(2,2)) && (ori_linev(2) < 0)
    max_vertip(2) = max_vertip(2) + len_spline*(0.491/0.288);
end
if (min_vertip(2) == hip_mat(1,2)) && (ori_linev(2) > 0) % if someone stands or lies upside down :)
    min_vertip(2) = min_vertip(2) - len_spline*(0.491/0.288);
end
% if min_vertip(2) == sho_mat(1,2) && ori_linev(2) < 0 % not very useful, because eyes or nose can always be detected
%     min_vertip(2) = min_vertip(2) - len_spline*(0.118/0.288);
% end
if (max_vertip(2) == kne_mat(end,2)) && (ori_linev(2) < 0)
    max_vertip(2) = max_vertip(2) + len_spline*(0.246/0.288);
end

% plot a rectangle for both minimal and maximal horizontal points
% rectangle(gca,'Position',[min_horizp-4 8 8],'LineWidth',2,'EdgeColor','w','LineStyle','--');
% rectangle(gca,'Position',[max_horizp-4 8 8],'LineWidth',2,'EdgeColor','y','LineStyle','--');
% 
% rectangle(gca,'Position',[min_vertip-4 8 8],'LineWidth',2,'EdgeColor','b','LineStyle','--');
% rectangle(gca,'Position',[max_vertip-4 8 8],'LineWidth',2,'EdgeColor','g','LineStyle','--');

% determine the initial position and size of bonding box
topleft_point = [min_horizp(1) min_vertip(2)];
crop_width = max_horizp(1) - min_horizp(1);
crop_height = max_vertip(2) - min_vertip(2);

% set the default scale factor here to enlarge the bonding box
scale_fac_left = 0.15;
scale_fac_up = 0.1/0.897;
scale_fac_down = 0.08/0.897;
scale_fac_right = 0.15;

% correct the scale factor in horizontal direction
body_mat = sortrows([hip_mat; sho_mat]);
if min_horizp(1) == body_mat(1,1)
    scale_fac_left = 0.3;
end
if max_horizp(1) == body_mat(end,1)
    scale_fac_right = 0.3;
end

topleft_point = [topleft_point(1)-scale_fac_left*crop_width topleft_point(2)-scale_fac_up*crop_height];
crop_width = crop_width*(1+scale_fac_left+scale_fac_right);
crop_height = crop_height*(1+scale_fac_up+scale_fac_down);

% change the parameter above according to sem_seg result
% uncomment the following lines and change the input if you don't want
% any influence of sem_seg
if ~isempty(bw_region)
    BW_J = imrotate(bw_region,-rot_ang/pi*180);
    if bwarea(BW_J) < crop_width*crop_height*0.8 && bwarea(BW_J) > crop_width*crop_height*0.3 % the area ratio is 0.3~0.8
        BW_bb = regionprops(BW_J, 'BoundingBox');
        topleft_point = [BW_bb.BoundingBox(1) BW_bb.BoundingBox(2)];
        crop_width = BW_bb.BoundingBox(3);
        crop_height = BW_bb.BoundingBox(4);
    end
end

crop_J = imcrop(J,[topleft_point crop_width crop_height]);

end