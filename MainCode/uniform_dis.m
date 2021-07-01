%发布均匀分布任务
function [task_dist] = uniform_dis(date,start_time,density)
for i=1:125
    %for j=1:end_time-start_time
    task_dist{i}{1}=datestr([2017 3 date start_time-1 0 0]);
    task_dist{i}{2}=datestr([2017 3 date start_time 0 0]);
        %task_dist{i}{j}{2}=num2str(start_time+j-1);
        %task_dist{i}{j}{3}=num2str(start_time+j);
    task_dist{i}{3}=density;
    %end
end
end