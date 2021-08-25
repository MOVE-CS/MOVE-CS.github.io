function [task_dist] = uniform_dis(date,start_time,density)
for i=1:125
    task_dist{i}{1}=datestr([2017 3 date start_time-1 0 0]);
    task_dist{i}{2}=datestr([2017 3 date start_time 0 0]);
    task_dist{i}{3}=density;
end
end
