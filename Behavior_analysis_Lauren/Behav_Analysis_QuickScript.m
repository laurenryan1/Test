%% Drag whichever day of data you wish to analyze into the Workspace, it will show up as variable "B". 
%% 
clearvars -except B
%close all 
%clc 
%% Want to try and make one script that makes all the necessary graphs without all the extra stuff. 
%% 1: Find tones, make a plot of the tone/force profile
tones_1= B.data.out.event.tone; 
tone=(tones_1(tones_1(:,2)==1)); %remove NaNs and find only values where tone is HIGH
figure
hold on 
plot (B.data.in.ana.force(:,1),B.data.in.ana.force(:,2))
plot (tone, 0,'mo')
%% 2: Average and Plot
%%  the average of force traces 
for ii =1: length (tone) 
    window_low= tone(ii)-3; 
    window_high= tone(ii)+3; 
    [c i_low] = min(abs(window_low-B.data.in.ana.force(:,1)));
    [c i_high] = min(abs(window_high-B.data.in.ana.force(:,1))); 
    traces= B.data.in.ana.force(i_low:i_high,2);
    i4traces=any(traces>0.1,2)==0; %getting rid of pushes for plot
    traces_2 =traces(i4traces,:);
    traces_final(1:length(traces_2),ii) = traces_2;
end 
%% 
% average 
for ii= 1: length (traces_final)
    average_i(ii)= mean(traces_final(ii,:));
end 
%% putting it all together (plots 3 seconds before and after each pull, and  then the average of those force traces overlaid on that

figure
hold on
title ('Average Force Profile: Pulls')
xlabel('time,s')
ylabel ('force, AU')
for ii= 10:length(tone)-10
    window_low= tone(ii)-3; 
    window_high= tone(ii)+3; 
    [c i_low] = min(abs(window_low-B.data.in.ana.force(:,1)));
    [c i_high] = min(abs(window_high-B.data.in.ana.force(:,1)));
    traces = B.data.in.ana.force(i_low:i_high,2);
    i4traces=any(traces>0.1,2)==0; %getting rid of pushes for plot
    traces_2 =traces(i4traces,:); %pulls only 
    x=  linspace (-3, 3,length(traces_2));
    p2= plot(x,traces_2)
    p2.Color(4) = 0.15;
    hold on
end 
x=  linspace (-3, 3,length(traces_final(:,1)));

p3= plot (x, average_i,'m')
p3.LineWidth=3

%% 3: Peak of Each Pull 
%% 
for ii= 1: length(tone)
    mini_i(ii)= min(traces_final(:,ii)); %peak of each pull 
end
mini_me=mini_i(mini_i<-0.15)
%% 
for ii= 1:length(tone)
    window_low= tone(ii)-3; 
    window_high= tone(ii)+3; 
    [c i_low] = min(abs(window_low-B.data.in.ana.force(:,1)));
    [c i_high] = min(abs(window_high-B.data.in.ana.force(:,1)));
    traces (1:length (B.data.in.ana.force(i_low:i_high,2)),ii) = B.data.in.ana.force(i_low:i_high,2);
end
%%  all Local Minima, with a given prominence (after mild smoothing)  
y=traces(:,1);
x= linspace(-3,3, length(traces));
y2= smooth(y,20);
TF = islocalmin(y2,'MinProminence',0.009);
TRYME= y2(TF);
figure
plot(x,y2,x(TF),y2(TF),'r*')
%% 
%% increase to all traces 
%figure
tohist= [];
for ii= 1:length(tone) %for each force trace
    y= traces(:,ii) ;
    y2= smooth(y,20) ;
    TF = islocalmin(y2,'MinProminence',0.009);
    TF_real= y2(TF) %find local minima
    real= TF_real(TF_real<-0.1) 
    tohist= vertcat(tohist,real); %concate all the minima into one array
end 
figure 
histogram (tohist) 
hold on 
histogram(mini_me)% overlay with the histogram of the minima of pulls 
legend ('min all mvmmts', 'min of pulls')
%% 
y=traces(:,length(tone));
x= linspace(-3,3, length(traces));
y2= smooth(y,20);
%TF = islocalmin(y2,'MinProminence',0.009);
TD= islocalmax(y2,'MinProminence', 0.01)
%figure
%plot(x,y2,x(TD),y2(TD),'r*')

TRYME_max= y2(TD);
%% 
%% increase to find max of each trace 
tohist2= [];
for ii= 1:length(tone) %for each force trace
    y= traces(:,ii) ;
    y2= smooth(y,20) ;
    TD = islocalmax(y2,'MinProminence',0.01);
    TD_real= y2(TD); %find local maxs
    real2= TD_real(TD_real>0.1) 

    tohist2= vertcat(tohist2,real2); %concate all the minima into one array
end 
%% 4: pushes 
%figure
i4traces_push=any(traces<-0.15,2)==0;
traces_pushes =traces(i4traces_push,:); 
x=  linspace (-3, 3,length(traces_pushes));

%plot (x,traces_pushes);
%% 
for ii =1: length (tone) 
    window_low= tone(ii)-3; 
    window_high= tone(ii)+3; 
    [c i_low] = min(abs(window_low-B.data.in.ana.force(:,1)));
    [c i_high] = min(abs(window_high-B.data.in.ana.force(:,1))); 
    traces= B.data.in.ana.force(i_low:i_high,2);
    i4traces_push=any(traces<-0.15,2)==0; %getting rid of pulls for plot
    traces_pushes =traces(i4traces_push,:); 
    traces_final2(1:length(traces_pushes),ii) = traces_pushes;
end 


% average 
for ii= 1: length (traces_final2)
    average_i2(ii)= mean(traces_final2(ii,:));
end 
%%

%% Putting it all together 
%figure
%x=  linspace (-3, 3,length(traces_final(:,1)));
%p3= plot (x, average_i,'m')
%p3.LineWidth=5
%hold on
%title ('Average Force Profile: Pushes')
%xlabel('time,s')
%ylabel ('force, AU')
for ii= 10:length(tone)-10
    window_low= tone(ii)-3; 
    window_high= tone(ii)+3; 
    [c i_low] = min(abs(window_low-B.data.in.ana.force(:,1)));
    [c i_high] = min(abs(window_high-B.data.in.ana.force(:,1)));
    traces = B.data.in.ana.force(i_low:i_high,2);
    i4traces_push=any(traces<-0.15,2)==0; %getting rid of pushes for plot
    traces_pushes =traces(i4traces_push,:); %pulls only 
    x=  linspace (-3, 3,length(traces_pushes));
   % p2= plot(x,traces_pushes)
   % p2.Color(4) = 0.10;
    %hold on
end 
%% maximum of pushes 
for ii= 1: length(tone)
    maxi_i(ii)= max(traces_final2(:,ii));
end
maxi_me= maxi_i(maxi_i>0.15)
%%
%% try putting all the histogram stuff together: 
figure 
histogram (tohist2,20) 
hold on 
histogram(tohist,20)% overlay with the histogram of the minima of pulls 
hold on 
histogram(mini_i,5) 
hold on 
histogram(maxi_me,5)
legend ('local maxs', 'local mins','min of pulls','max of pushes')
xlabel ('Local extrema')
ylabel ('#occurences')
%% one more histogram 
histplot= vertcat(tohist, tohist2);
figure
histogram(histplot,20)
hold on 
histogram (mini_i,5) 
histogram (maxi_i,5) 
legend ('all movements', 'pull mins', 'push maxes') 
xlabel ('Local extrema')
ylabel ('#occurences')
%% 
%% try for all pulls, and then histogram. 
 
 for ii= 1:length(tone)
     x_thisloop= linspace (-3, 3,length(traces_final(:,ii)));
     %idxe1= find ((x_thisloop > -1.5)); idx1_real= idxe1(1);
     %idxe2= find(x_thisloop>1.5); idx2_real= idxe2(1); 
     %x= linspace (-3, 3,length(traces_final(idx1_real:idx2_real,ii)));
     %y= traces_final(idx1_real:idx2_real,ii);
     y=traces_final(:,ii);
     pulsewidth(y,x_thisloop, 'StateLevels', [-0.16 -0.14]);
     midcross(y,x_thisloop, 'StateLevels', [-0.16 -0.14]);
     xx=midcross(y,x_thisloop, 'StateLevels', [-0.16 -0.14]);
    [idxs]= find ((xx>-0.6)& (xx<0.6));
    isidxsempty= isempty(idxs);
    if isidxsempty==1
        total_dur_pull(ii)= 0;
      
    elseif  isequal(size(idxs),[1,1]) 
          total_dur_pull(ii)= 0;
          
    elseif isequal( size (idxs), [3,1])
         if (abs(xx(idxs(1)))+abs(xx(idxs(3)))) <1 
            if (xx(idxs(1))<0 && xx(idxs(3))<0)
                total_dur_pull(ii)= abs(xx(idxs(1)))+ xx(idxs(3));
            else 
                total_dur_pull (ii)= abs(xx(idxs(3)))+ abs(xx(idxs(1)));
            end  
        end 
    elseif isequal( size (idxs), [4,1])
        if (abs(xx(idxs(1)))+abs(xx(idxs(4)))) <1 
            if (xx(idxs(1))<0 && xx(idxs(4))<0)
                total_dur_pull(ii)= abs(xx(idxs(1)))+ xx(idxs(4));
            else 
                total_dur_pull (ii)= abs(xx(idxs(4)))+ abs(xx(idxs(1)));
            end  
        end 
     elseif isequal( size (idxs), [5,1])
         if (abs(xx(idxs(1)))+abs(xx(idxs(5)))) <1 
            if (xx(idxs(1))<0 && xx(idxs(5))<0)
                total_dur_pull(ii)= abs(xx(idxs(1)))+ xx(idxs(5));
            else 
                total_dur_pull (ii)= abs(xx(idxs(5)))+ abs(xx(idxs(1)));
            end  
        end 
    
    elseif isequal( size (idxs), [6,1])
         if (abs(xx(idxs(1)))+abs(xx(idxs(6)))) <1 
            if (xx(idxs(6))<0 && xx(idxs(6))<0)
                total_dur_pull(ii)= abs(xx(idxs(1)))+ xx(idxs(6));
            else 
                total_dur_pull (ii)= abs(xx(idxs(6)))+ abs(xx(idxs(1)));
            end  
        end 
    else 
        if (xx(idxs(1))<0 && xx(idxs(2))<0)
             total_dur_pull(ii)= abs(xx(idxs(1)))+ xx(idxs(2));
        else 
             total_dur_pull(ii)=abs(xx(idxs(1)))+abs(xx(idxs(2)));
        end 
    end
 end 
%% durations hist
figure
hist(total_dur_pull)
xlabel ('duration of pull')
ylabel ('#occurences')
title ('Duration of Pulls')
%% 5: Rewards and Licks 
%% Find when the solenoid opens 
solenoid= B.data.out.event.left; 
soleno=(solenoid(solenoid(:,2)==1)); %remove NaNs and find only values where tone is HIGH'
lick_l= B.data.in.event.lick_left; 
lick_left= (lick_l(lick_l(:,2)==1));
%% 
figure
hold on 
plot(zeros(1,100), linspace (1, length(tone)))
title ('Lick Distribution') 
xlabel('Time(s), Reward at t=0') 
ylabel ('Trials') 

for ii= 1: length (soleno)
window_low2= soleno(ii)-1.5; 
window_high2= soleno(ii)+1.5; 
 
[c i_low] = min(abs(window_low2-lick_left));
[c i_high] = min(abs(window_high2-lick_left));
xlick= lick_left(i_low:i_high);
x_toplot = xlick-mean(xlick);
plot (x_toplot, ii,'*')
xlim ([-2 2])
end 
%% count rewarded pulls? 

tot_rewards= length(soleno)

%% duration of pushes. 
for ii= 1:length(tone)
     x_thisloop= linspace (-3, 3,length(traces_final2(:,ii)));
     %idxe1= find ((x_thisloop > -1.5)); idx1_real= idxe1(1);
     %idxe2= find(x_thisloop>1.5); idx2_real= idxe2(1); 
     %x= linspace (-3, 3,length(traces_final(idx1_real:idx2_real,ii)));
     %y= traces_final(idx1_real:idx2_real,ii);
     y=traces_final2(:,ii);
     pulsewidth(y,x_thisloop, 'StateLevels', [0.14 0.16]);
     midcross(y,x_thisloop, 'StateLevels', [0.14 0.16]);
     xx=midcross(y,x_thisloop, 'StateLevels', [0.14 0.16]);
    [idxs]= find ((xx>-0.6)& (xx<0.6));
    isidxsempty= isempty(idxs);
    if isidxsempty==1
        total_dur_pull2(ii)= 0;
      
    elseif  isequal(size(idxs),[1,1]) 
          total_dur_pull2(ii)= 0;
          
    elseif isequal( size (idxs), [3,1])
         if (abs(xx(idxs(1)))+abs(xx(idxs(3)))) <1 
            if (xx(idxs(1))<0 && xx(idxs(3))<0)
                total_dur_pull2(ii)= abs(xx(idxs(1)))+ xx(idxs(3));
            else 
                total_dur_pull2 (ii)= abs(xx(idxs(3)))+ abs(xx(idxs(1)));
            end  
        end 
    elseif isequal( size (idxs), [4,1])
        if (abs(xx(idxs(1)))+abs(xx(idxs(4)))) <1 
            if (xx(idxs(1))<0 && xx(idxs(4))<0)
                total_dur_pull2(ii)= abs(xx(idxs(1)))+ xx(idxs(4));
            else 
                total_dur_pull2 (ii)= abs(xx(idxs(4)))+ abs(xx(idxs(1)));
            end  
        end 
     elseif isequal( size (idxs), [5,1])
         if (abs(xx(idxs(1)))+abs(xx(idxs(5)))) <1 
            if (xx(idxs(1))<0 && xx(idxs(5))<0)
                total_dur_pull2(ii)= abs(xx(idxs(1)))+ xx(idxs(5));
            else 
                total_dur_pull2 (ii)= abs(xx(idxs(5)))+ abs(xx(idxs(1)));
            end  
        end 
    
    elseif isequal( size (idxs), [6,1])
         if (abs(xx(idxs(1)))+abs(xx(idxs(6)))) <1 
            if (xx(idxs(6))<0 && xx(idxs(6))<0)
                total_dur_pull2(ii)= abs(xx(idxs(1)))+ xx(idxs(6));
            else 
                total_dur_pull2 (ii)= abs(xx(idxs(6)))+ abs(xx(idxs(1)));
            end  
        end 
    else 
        if (xx(idxs(1))<0 && xx(idxs(2))<0)
             total_dur_pull2(ii)= abs(xx(idxs(1)))+ xx(idxs(2));
        else 
             total_dur_pull2(ii)=abs(xx(idxs(1)))+abs(xx(idxs(2)));
        end 
    end
 end 
%% durations hist
figure
hist(total_dur_pull2)
xlabel ('duration of pull')
ylabel ('#occurences')
title ('Duration of Pulls')