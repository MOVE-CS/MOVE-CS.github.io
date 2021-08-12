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
%Initialization
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
%[task_dist]=Task_Dist(date,hour,density);           
[free_taxi]=Candi_Init(datenum([year month date hour-1 55 0]),file_name,time,busy,Lat,Lont,minimal_gradularity,expe_zone);
%%
%Calculate sensing cost and original revenue
[distance_time]=Calc_Dis_Time(expe_zone,task_dist,free_taxi);
[cost] = Calc_Reward(distance_time,rate,profit);
[r_reject] = Calc_Profit_Origin(distance_time,rate,profit);
%%
%Perform algorithm
 [result] = LSTRec(cost,budget,task_dist,r_reject);








