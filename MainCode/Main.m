%%
%Experiment zones initialization
for i=1:125
    if i<46
        for j=1:9
            for k=1:5
                expe_zone{(j-1)*5+k}{1}=29.6859-(j-1)*0.01285;
                expe_zone{(j-1)*5+k}{2}=106.4710+(k-1)*0.01414;
                expe_zone{(j-1)*5+k}{3}=29.6859-j*0.01285;
                expe_zone{(j-1)*5+k}{4}=106.4710+k*0.01414;
                expe_zone{(j-1)*5+k}{5}=(expe_zone{(j-1)*5+k}{1}+ expe_zone{(j-1)*5+k}{3})/2;
                expe_zone{(j-1)*5+k}{6}=(expe_zone{(j-1)*5+k}{4}+ expe_zone{(j-1)*5+k}{2})/2;
            end
        end
    
    elseif i==46
        expe_zone{i}{1}=29.5703;
        expe_zone{i}{2}=106.5211;
        expe_zone{i}{3}=29.5703-0.01285;
        expe_zone{i}{4}=106.5211+0.01414;
        expe_zone{i}{5}=(expe_zone{i}{1}+expe_zone{i}{1})/2;
        expe_zone{i}{6}=(expe_zone{i}{2}+expe_zone{i}{4})/2;
        
    elseif i<117
        for j=1:10
            for k=1:7
                expe_zone{(j-1)*7+k+46}{1}=29.7486-(j-1)*0.01285;
                expe_zone{(j-1)*7+k+46}{2}=106.5419+(k-1)*0.01414;
                expe_zone{(j-1)*7+k+46}{3}=29.7486-j*0.01285;
                expe_zone{(j-1)*7+k+46}{4}=106.5419+k*0.01414;
                expe_zone{(j-1)*7+k+46}{5}=(expe_zone{(j-1)*7+k+46}{1}+expe_zone{(j-1)*7+k+46}{3})/2;
                expe_zone{(j-1)*7+k+46}{6}=(expe_zone{(j-1)*7+k+46}{2}+expe_zone{(j-1)*7+k+46}{4})/2;
            end
        end
        
    elseif i<125
        for j=1:4
            for k=1:2
                expe_zone{(j-1)*2+k+116}{1}=29.6201-(j-1)*0.01285;
                expe_zone{(j-1)*2+k+116}{2}=106.5419+(k-1)*0.01414;
                expe_zone{(j-1)*2+k+116}{3}=29.6201-j*0.01285;
                expe_zone{(j-1)*2+k+116}{4}=106.5419+k*0.01414;
                expe_zone{(j-1)*2+k+116}{5}=(expe_zone{(j-1)*2+k+116}{1}+expe_zone{(j-1)*2+k+116}{3})/2;
                expe_zone{(j-1)*2+k+116}{6}=(expe_zone{(j-1)*2+k+116}{2}+expe_zone{(j-1)*2+k+116}{4})/2;
            end
        end
    
    else
        expe_zone{i}{1}=29.5687;
        expe_zone{i}{2}=106.5702;
        expe_zone{i}{3}=29.5687-0.01285;
        expe_zone{i}{4}=106.5702+0.01414;
        expe_zone{i}{5}=(expe_zone{i}{1}+expe_zone{i}{1})/2;
        expe_zone{i}{6}=(expe_zone{i}{2}+expe_zone{i}{4})/2;
        
        
    end
end 
%%
%Sensing vehicles initialization
files=dir('*.txt');

for i=1:length(files)
    file_name{i}=files(i).name;
    [Lat{i},Lont{i},time{i},busy{i}]=textread(file_name{i},'%f %f %*f %s %d %*f','delimiter',',');
end
%%
%Parameters initialization
year = 2017;
month = 3;
density=2;
date = 1;
hour = 8;
budget = 500;
task_num=100;
%%
%Pick up probability and expected revenue initialization
count=readtable('count8.csv');
pick=readtable('pick8.csv');    
profit=readtable('profit8.csv');
count = table2cell(count);
pick = table2cell(pick);
profit = table2cell(profit);
for i=1:125
    for j=1:14
        profit{i,j}=profit{i,j}/pick{i,j};
        rate{i,j}=pick{i,j}/count{i,j};
        if isnan(rate{i,j})==1
            rate{i,j}=0;
        end
        if rate{i,j}==Inf
            rate{i,j}=1;
        end
        if isnan(profit{i,j}) == 1
            profit{i,j}=0;                                                                                                                                                                                                                                       
        end
    end
end
%%
%Sensing task initialization
%[task_dist]=uniform_dis(date,hour,density);
[task_dist]=random_dis(date,hour,task_num);             
[free_taxi]=init_free(datenum([year month date hour-1 55 0]),file_name,time,busy,Lat,Lont,minimal_gradularity,expe_zone);
%%
%Calculate sensing cost and original revenue
[distance_time]=calc_dis_time(expe_zone,task_dist,free_taxi);
[cost] = calc_cost(distance_time,rate,profit);
[r_reject] = calc_r_reject(distance_time,rate,profit);
%%
%Perform algorithm
 [result] = MOVE_CS(cost,budget,task_dist,r_reject);








