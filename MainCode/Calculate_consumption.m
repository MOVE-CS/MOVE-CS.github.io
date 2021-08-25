function [distance_time] = calc_dis_time(expe_zone,task_dist,free_taxi)
l=1;
for i=1:length(task_dist)
    for j=1:task_dist{i}{3}
        for k=1:length(free_taxi)
            dis_lat = abs(free_taxi{k}(2)-expe_zone{i}{5});
            dis_lon = abs(free_taxi{k}(3)-expe_zone{i}{6});
            dis = ((dis_lat*111320)^2+(dis_lon*100000)^2)^0.5;
            if dis/300<60&&free_taxi{k}(5)~=126
                distance_time{l}(1)=i;
                distance_time{l}(2)=j;
                distance_time{l}(3)=free_taxi{k}(1);
                distance_time{l}(4)=free_taxi{k}(5);
                distance_time{l}(5)=dis;
                distance_time{l}(6)=dis/300;
                distance_time{l}(7)=free_taxi{k}(4);
                l=l+1;
            end
        end
    end
end
end
