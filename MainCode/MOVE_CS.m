function [MOVE_CS_result] = MOVE_CS(cost,budget,task_dist,r_reject)

k=1;
for i=1:1000
    flag(i)=0;
end
total_cost=0;
curr=0;
for i=1:length(cost)
    if cost{i}(6)/cost{i}(5)>curr
        curr =cost{i}(6)/cost{i}(5);
        selection = i;
    end
end
exp_num = curr*cost{selection}(5);

over_ratio = (cost{selection}(7)-r_reject(selection))/r_reject(selection);
if over_ratio<0
    exp_num=0;
end
flag(cost{selection}(3))=1;
total_cost = total_cost+cost{selection}(5);
MOVE_CS_result{1}{k}(1)=cost{selection}(1);
MOVE_CS_result{1}{k}(2)=cost{selection}(2);
MOVE_CS_result{1}{k}(3)=cost{selection}(3);
MOVE_CS_result{1}{k}(4)=cost{selection}(4);
MOVE_CS_result{1}{k}(5)=cost{selection}(5);
MOVE_CS_result{1}{k}(6)=cost{selection}(6);
MOVE_CS_result{1}{k}(7)=exp_num;
MOVE_CS_result{1}{k}(8) = total_cost;
MOVE_CS_result{1}{k}(9) = over_ratio;
MOVE_CS_result{1}{k}(10) = selection;

k=k+1;

curr=0;
for i=1:length(cost)
    if flag(cost{i}(3))==0
        
        new_value=calc_exp_num(MOVE_CS_result{1},cost{i},task_dist);
        if (new_value-exp_num)/cost{i}(5)>curr
            curr = (new_value-exp_num)/cost{i}(5);
            selection=i;
        end
    end
end
over_ratio = (cost{selection}(7)-r_reject(selection))/r_reject(selection);
if over_ratio<0
    curr=0;
end
exp_num = curr*cost{selection}(5)+exp_num;
flag(cost{selection}(3))=1;
total_cost = total_cost+cost{selection}(5);
MOVE_CS_result{1}{k}(1)=cost{selection}(1);
MOVE_CS_result{1}{k}(2)=cost{selection}(2);
MOVE_CS_result{1}{k}(3)=cost{selection}(3);
MOVE_CS_result{1}{k}(4)=cost{selection}(4);
MOVE_CS_result{1}{k}(5)=cost{selection}(5);
MOVE_CS_result{1}{k}(6)=cost{selection}(6);
MOVE_CS_result{1}{k}(7)=exp_num;
MOVE_CS_result{1}{k}(8) = total_cost;
MOVE_CS_result{1}{k}(9) = over_ratio;
MOVE_CS_result{1}{k}(10) = selection;
k=k+1;

added=1;
gap = 1 + (1/(exp(2)-1))/(6005);

while added==1

    old_value=exp_num;
    added=0;
    %generate swaps
    clear swap;
    m=1;
    for i=1:length(MOVE_CS_result{1})
        %MOVE_CS_result{1}{i}(10)
        for j=1:length(cost)
            
            if flag(cost{j}(3))==0&&j~=MOVE_CS_result{1}{i}(10)
                swap{1}(m,1)=i;
                swap{1}(m,2)=MOVE_CS_result{1}{i}(10);
                swap{1}(m,3)=j;
                m=m+1;
            end
        end
    end
    n=1;
    for j=1:length(cost)
            if flag(cost{j}(3))==0
                swap{2}(n)=j;
                n=n+1;
            end
    end
    
    while(added==0&&m+n-2>0)
        clear rat1
        clear rat2
        for i=1:n-1
            if total_cost+cost{swap{2}(i)}(5)<budget
                rat2{1}(i)=calc_exp_num(MOVE_CS_result{1},cost{swap{2}(i)},task_dist);
                rat2{2}(i)=(rat2{1}(i)-old_value)/cost{swap{2}(i)}(5);
            else
                rat2{1}(i)=0;
                rat2{2}(i)=0;
            end
        end
        [mr2,mr2_pos]=max(rat2{2});
        
        
        
        for i=1:m-1
            if total_cost-cost{swap{1}(i,2)}(5)+cost{swap{1}(i,3)}(5)<budget
                
                
                curr_result = MOVE_CS_result{1};
                curr_result(swap{1}(i,1))=[];
                
                
                rat1{1}(i) = calc_exp_num(curr_result,cost{swap{1}(i,3)},task_dist);
                rat1{2}(i) = (rat1{1}(i)-old_value)/cost{swap{1}(i,3)}(5);
            else
                rat1{1}(i)=0;
                rat1{2}(i)=0;
            end
        end
        if m-1>0
            [mr1,mr1_pos]=max(rat1{2});
        else
            mr1=0;
            mr1_pos=0;
        end
        if mr1==0&&mr2==0
            break;
        end
        
        if mr2>mr1
                selection=swap{2}(mr2_pos);
                new_value = rat2{1}(mr2_pos);
                flag(cost{selection}(3))=1;
                total_cost = total_cost+cost{selection}(5);
                increment=new_value-exp_num;
                over_ratio = (cost{selection}(7)-r_reject(selection))/r_reject(selection);
                if over_ratio<0
                    increment=0;
                end
                exp_num = exp_num+increment;
                MOVE_CS_result{1}{k}(1)=cost{selection}(1);
                MOVE_CS_result{1}{k}(2)=cost{selection}(2);
                MOVE_CS_result{1}{k}(3)=cost{selection}(3);
                MOVE_CS_result{1}{k}(4)=cost{selection}(4);
                MOVE_CS_result{1}{k}(5)=cost{selection}(5);
                MOVE_CS_result{1}{k}(6)=cost{selection}(6);
                MOVE_CS_result{1}{k}(7)=exp_num;
                MOVE_CS_result{1}{k}(8) = total_cost;
                MOVE_CS_result{1}{k}(9) = over_ratio;
                MOVE_CS_result{1}{k}(10) = selection;
                k=k+1;
                added=1;
                mr1=0;
                mr2=0;
                mr1_pos=0;
                mr2_pos=0;

            
        elseif mr1>mr2
            if mr1/old_value>gap
                total_cost = total_cost-MOVE_CS_result{1}{swap{1}(mr1_pos,1)}(5);
                flag(MOVE_CS_result{1}{swap{1}(mr1_pos,1)}(3))=0;
                MOVE_CS_result{1}(swap{1}(mr1_pos,1))=[];
                k=k-1;
                selection = swap{1}(mr1_pos,3);
                flag(cost{selection}(3))=1;
                total_cost = total_cost+cost{selection}(5);
                new_value = rat1{1}(mr1_pos);
                increment=new_value-exp_num;
                over_ratio = (cost{selection}(7)-r_reject(selection))/r_reject(selection);
                if over_ratio<0
                    increment=0;
                end
                exp_num = exp_num+increment;
                MOVE_CS_result{1}{k}(1)=cost{selection}(1);
                MOVE_CS_result{1}{k}(2)=cost{selection}(2);
                MOVE_CS_result{1}{k}(3)=cost{selection}(3);
                MOVE_CS_result{1}{k}(4)=cost{selection}(4);
                MOVE_CS_result{1}{k}(5)=cost{selection}(5);
                MOVE_CS_result{1}{k}(6)=cost{selection}(6);
                MOVE_CS_result{1}{k}(7)=exp_num;
                MOVE_CS_result{1}{k}(8) = total_cost;
                MOVE_CS_result{1}{k}(9) = over_ratio;
                MOVE_CS_result{1}{k}(10) = selection;
                k=k+1;
                added=1;
                mr1=0;
                mr2=0;
                mr1_pos=0;
                mr2_pos=0;
                
            else
                m=m-1;
               
                swap{1}(mr1_pos,:)=[];
                mr1=0;
                mr2=0;
                mr1_pos=0;
                mr2_pos=0;
                continue
            end
        end
        
    end
    
end
MOVE_CS_result{2}=exp_num;
end


