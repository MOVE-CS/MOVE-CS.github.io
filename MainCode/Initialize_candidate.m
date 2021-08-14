function [free_taxi] = init_free(schedule_time,file_name,time,busy,Lat,Lont,minimal_gradularity,expe_zone)
k=1;
time2num = schedule_time;
    for i=1:length(file_name)
        length(file_name)
        i
        for j=1:length(time{i})
            curr_time = datenum([str2double([time{i}{j}(1),time{i}{j}(2),time{i}{j}(3),time{i}{j}(4)]) str2double([time{i}{j}(6),time{i}{j}(7)]) str2double([time{i}{j}(9),time{i}{j}(10)]) str2double([time{i}{j}(12),time{i}{j}(13)]) str2double([time{i}{j}(15),time{i}{j}(16)]) str2double([time{i}{j}(18),time{i}{j}(19)])]);
            if abs(curr_time-time2num)<minimal_gradularity&&busy{i}(j)==0
                free_taxi{k}(1)=i;
                free_taxi{k}(2)=Lat{i}(j);
                free_taxi{k}(3)=Lont{i}(j);
                free_taxi{k}(4)=rand;
                for l=1:length(expe_zone)
                    if expe_zone{l}{3}<free_taxi{k}(2)&&free_taxi{k}(2)<expe_zone{l}{1}&&expe_zone{l}{2}<free_taxi{k}(3)&&free_taxi{k}(3)<expe_zone{l}{4}
                        free_taxi{k}(5) = l;
                        break;
                    else
                        free_taxi{k}(5) = 126;
                    end
                end
                k=k+1;
                break
            end
        end
    end
end