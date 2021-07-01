%¼ÆËã¿ªÏú
function [r_reject] = calc_r_reject(distance_time,rate,profit)
for i=1:length(distance_time)
    
    I_old1 = rate{distance_time{i}(4),1}*profit{distance_time{i}(4),1}+(1-rate{distance_time{i}(4),1})*rate{distance_time{4}(1),2}*profit{distance_time{4}(1),2};
    time = distance_time{i}(6)*rand;
    distance = time*30;
    if distance<=3000
        I_old2= 10;
    else
        I_old2= (distance-3000)*2/1000+10;
    end
    r_reject(i)=I_old1+I_old2;

end
end