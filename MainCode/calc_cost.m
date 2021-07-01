%¼ÆËã¿ªÏú
function [cost] = calc_cost(distance_time,rate,profit)
for i=1:length(distance_time)
    cost{i}(1)=distance_time{i}(1);
    cost{i}(2)=distance_time{i}(2);
    cost{i}(3)=distance_time{i}(3);
    cost{i}(4)=distance_time{i}(4);
    if distance_time{i}(5)<=3000
        basic_cost = 10;
    else
        basic_cost = (distance_time{i}(5)-3000)*2/1000+10;
    end
    incent_period =  ceil(distance_time{i}(6)/5);
    I_old = rate{distance_time{i}(4),1}*profit{distance_time{i}(4),1}+(1-rate{distance_time{i}(4),1})*rate{distance_time{4}(1),2}*profit{distance_time{4}(1),2};
    I_new = rate{distance_time{i}(1),incent_period+1}*profit{distance_time{i}(1),incent_period+1}+(1-rate{distance_time{i}(1),incent_period+1})*rate{distance_time{i}(1),incent_period+2}*profit{distance_time{i}(1),incent_period+2};
    potential_incentive = I_new -I_old;
    %if potential_incentive > 0
        cost{i}(5)=basic_cost-potential_incentive;
    %else
    %    cost{i}(5)=basic_cost;
    %end
    if cost{i}(5)<2
        cost{i}(5)=2;
    end
    cost{i}(6)=distance_time{i}(7);
    cost{i}(7)=basic_cost+I_old;

end
end