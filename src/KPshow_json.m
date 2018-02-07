function KPshow_json(json_dat, idx ,num)
LiWi = 1;
colors = {[255, 0, 0], [255, 85, 0], [255, 170, 0], [255, 255, 0], [170, 255, 0], [85, 255, 0], [0, 255, 0], ...
          [0, 255, 85], [0, 255, 170], [0, 255, 255], [0, 170, 255], [0, 85, 255], [0, 0, 255], [85, 0, 255], ...          
          [170, 0, 255], [255, 0, 255], [255, 0, 170], [255, 0, 85]};
col_idx = mod(idx, num)+1;
if col_idx > length(colors)
    col_idx = mod(idx,18)+1;
end
Col = colors{col_idx}/255;
if json_dat(idx).keypoints(18) == 1 && json_dat(idx).keypoints(24) ==1 %Lsh-Lelb
    line(gca,json_dat(idx).keypoints([16 22]),json_dat(idx).keypoints([17 23]),'LineWidth',LiWi,'Color',Col);
end
if json_dat(idx).keypoints(21) == 1 && json_dat(idx).keypoints(27) ==1 %Rsh-Relb
    line(gca,json_dat(idx).keypoints([19 25]),json_dat(idx).keypoints([20 26]),'LineWidth',LiWi,'Color',Col);
end
if json_dat(idx).keypoints(24) == 1 && json_dat(idx).keypoints(30) ==1 %Lwri-Lelb
    line(gca,json_dat(idx).keypoints([22 28]),json_dat(idx).keypoints([23 29]),'LineWidth',LiWi,'Color',Col);
end
if json_dat(idx).keypoints(33) == 1 && json_dat(idx).keypoints(27) ==1 %Rwri-Relb
    line(gca,json_dat(idx).keypoints([31 25]),json_dat(idx).keypoints([32 26]),'LineWidth',LiWi,'Color',Col);
end
if json_dat(idx).keypoints(18) == 1 && json_dat(idx).keypoints(21) ==1 %Lsh-Rsh
    line(gca,json_dat(idx).keypoints([16 19]),json_dat(idx).keypoints([17 20]),'LineWidth',LiWi,'Color',Col);
end
if json_dat(idx).keypoints(18) == 1 && json_dat(idx).keypoints(36) ==1 %Lsh-Lhip
    line(gca,json_dat(idx).keypoints([16 34]),json_dat(idx).keypoints([17 35]),'LineWidth',LiWi,'Color',Col);
end
if json_dat(idx).keypoints(21) == 1 && json_dat(idx).keypoints(39) ==1 %Rsh-Rhip
    line(gca,json_dat(idx).keypoints([19 37]),json_dat(idx).keypoints([20 38]),'LineWidth',LiWi,'Color',Col);
end
if json_dat(idx).keypoints(42) == 1 && json_dat(idx).keypoints(36) ==1 %Lkne-Lhip
    line(gca,json_dat(idx).keypoints([40 34]),json_dat(idx).keypoints([41 35]),'LineWidth',LiWi,'Color',Col);
end
if json_dat(idx).keypoints(45) == 1 && json_dat(idx).keypoints(39) ==1 %Rkne-Rhip
    line(gca,json_dat(idx).keypoints([43 37]),json_dat(idx).keypoints([44 38]),'LineWidth',LiWi,'Color',Col);
end
if json_dat(idx).keypoints(42) == 1 && json_dat(idx).keypoints(48) ==1 %Lkne-Lank
    line(gca,json_dat(idx).keypoints([40 46]),json_dat(idx).keypoints([41 47]),'LineWidth',LiWi,'Color',Col);
end
if json_dat(idx).keypoints(45) == 1 && json_dat(idx).keypoints(51) ==1 %Rkne-Rank
    line(gca,json_dat(idx).keypoints([43 49]),json_dat(idx).keypoints([44 50]),'LineWidth',LiWi,'Color',Col);
end
if json_dat(idx).keypoints(39) == 1 && json_dat(idx).keypoints(36) ==1 %Rhip-Lhip
    line(gca,json_dat(idx).keypoints([37 34]),json_dat(idx).keypoints([38 35]),'LineWidth',LiWi,'Color',Col);
end
end