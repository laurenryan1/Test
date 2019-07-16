%% Finding tones
tones_1= B.data.out.event.tone; 
tone=(tones_1(tones_1(:,2)==1)); %remove NaNs and find only values where tone is HIGH
figure
plot (tone, 0,'mo')
hold on 
plot (B.data.in.ana.force(:,1),B.data.in.ana.force(:,2))
%%
%plots 1 force trace for the 1st tone, from the beginning of the session,
%to 3 seconds after the tone 
%window= ((tone(1)-3):tone(1)+3000);
%window_low = (B.data.session_beginning)
window_low= tone(1)-3; %994 
window_high= tone(1)+3; %1000
[c i_low] = min(abs(window_low-B.data.in.ana.force(:,1)));
[c i_high] = min(abs(window_high-B.data.in.ana.force(:,1)));

figure
%plot(B.data.in.ana.force(window_low:window_high,1),B.data.in.ana.force(window_low:window_high,2))
p1= plot(B.data.in.ana.force(i_low:i_high,1),B.data.in.ana.force(i_low:i_high,2))
p1.Color(4) = 0.25;
title ('force profile 1st pull')
xlabel('time,s')
ylabel ('force, AU')
%% plot 3 seconds before and after each tone 

figure
for ii= 21:21
    window_low= tone(ii)-3; 
    window_high= tone(ii)+3; 
    [c i_low] = min(abs(window_low-B.data.in.ana.force(:,1)));
    [c i_high] = min(abs(window_high-B.data.in.ana.force(:,1)));
    traces = B.data.in.ana.force(i_low:i_high,2);
    i4traces=any(traces>0.1,2)==0; %getting rid of pushes for plot
    traces_2 =traces(i4traces,:); %pulls only 
    x=  linspace (-3, 3,length(traces_2));
    plot(x,traces_2)
    hold on 
end 

%%  Need to be able to seperate out pulls and pushes 
%B.data.in.event.pull(1,1)== B.data.in.ana.force(1,1)
figure
i4traces=any(traces>0.15,2)==0;
traces =traces(i4traces,:); 
x=  linspace (-3, 3,length(traces));

plot (x,traces);

%% trying to figure out the average 
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


% average 
for ii= 1: length (traces_final)
    average_i(ii)= mean(traces_final(ii,:));
end 

%% 
figure 
x=  linspace (-3, 3,length(traces_final(:,1)));
plot (x, traces_final(:,21),'m--')
hold on 
plot (x, average_i)
title ('force profile example and average')
xlabel('time,s')
ylabel ('force, AU')
legend ('Example force trace', 'average force pull')

%% putting it all together 

figure
x=  linspace (-3, 3,length(traces_final(:,1)));
p3= plot (x, average_i,'m')
p3.LineWidth=3
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
%% find peak of each pull (minima) and plot the histogram 

for ii= 1: length(tone)
    mini_i(ii)= min(traces_final(:,ii));
end
figure
histogram(mini_i(20:50),20)
xlabel ('trough/minimum of pull')
ylabel ('#occurences')
title ('Peak of Pulls')
%% do the same for pushes? 
figure
i4traces_push=any(traces<-0.15,2)==0;
traces_pushes =traces(i4traces_push,:); 
x=  linspace (-3, 3,length(traces_pushes));

plot (x,traces_pushes);
%% 
for ii =1: length (tone) 
    window_low= tone(ii)-3; 
    window_high= tone(ii)+3; 
    [c i_low] = min(abs(window_low-B.data.in.ana.force(:,1)));
    [c i_high] = min(abs(window_high-B.data.in.ana.force(:,1))); 
    traces= B.data.in.ana.force(i_low:i_high,2);
    i4traces_push=any(traces<-0.15,2)==0; %getting rid of pulls for plot
    traces_pushes =traces(i4traces_push,:); 
    traces_final(1:length(traces_pushes),ii) = traces_pushes;
end 


% average 
for ii= 1: length (traces_final)
    average_i(ii)= mean(traces_final(ii,:));
end 
%%
figure 
x=  linspace (-3, 3,length(traces_final(:,1)));
%plot (x, traces_final(:,21),'m--')
hold on 
plot (x, average_i)
title ('force profile example and average')
xlabel('time,s')
ylabel ('force, AU')
legend ('Example force trace', 'average force pull')
%%
figure
x=  linspace (-3, 3,length(traces_final(:,1)));
p3= plot (x, average_i,'m')
p3.LineWidth=5
hold on
title ('Average Force Profile: Pushes')
xlabel('time,s')
ylabel ('force, AU')
for ii= 10:length(tone)-10
    window_low= tone(ii)-3; 
    window_high= tone(ii)+3; 
    [c i_low] = min(abs(window_low-B.data.in.ana.force(:,1)));
    [c i_high] = min(abs(window_high-B.data.in.ana.force(:,1)));
    traces = B.data.in.ana.force(i_low:i_high,2);
    i4traces_push=any(traces<-0.15,2)==0; %getting rid of pushes for plot
    traces_pushes =traces(i4traces_push,:); %pulls only 
    x=  linspace (-3, 3,length(traces_pushes));
    p2= plot(x,traces_pushes)
    p2.Color(4) = 0.10;
    hold on
end 
%% completely stuck/ everything below is preliminary/wrong
%% find duration of each pull 
for ii= 1: length (tone) 
    mini_i(ii)= min(traces_final(:,ii));
end
traces_final(:,1)
linear_indices= find(traces_final(:,1)<-0.15)
find (traces_final(:,1)==-0.15)

nnz(traces_final(:,3)< -0.15)

%% 
[row, col] = find(traces_final(:, 1:end-1) <-0.15 & traces_final(:, 2:end) < -0.15)
[~, idx] = unique(col, 'first');
rows = row(idx)
%% 
mini_i(21) %Minimum for the twenty first force trace . 
[idx]= find (traces_final (:,21) == mini_i(21)) %idx gives the id on the force trace of the minimum of the trace. 
traces_final (idx,21) %should be minimum 

[idx2]= find(traces_final(:,1) <-0.15)
idx3= min( (idx2-idx) )
idx4= idx+idx3

x1=x(idx) % time of minimum 
x2= x(idx4) %time of first 0.15 crossing 

xtot= abs(x1) +abs(x2) %total duration so far of the push, still need to add deltat2

[index_test] = find ((traces_final(:,1) >0.15) & (traces_final(:,1) >-0.12))
%now, go in the other direction

A= traces_final (:,1) ;
A((A-1)<-0.15 & (A-1)>-0.16& A>-0.15);

%% First pass, at finding the duration of the 21st pull: 
x= linspace (-3, 3,length(traces_final(:,21)))
idxe1= find ((x > -0.5)); idx1_real= idxe1(1);
idxe2= find(x>0.2); idx2_real= idxe2(1); 
x= linspace (-3, 3,length(traces_final(idx1_real:idx2_real,21)))
figure
%pulsewidth(traces_final(idx1_real:idx2_real,21),x2,'StateLevels',[-0.15005, -0.14999])
y= traces_final(idx1_real:idx2_real,21)
pulsewidth(y,x, 'StateLevels', [-0.16 -0.14])
hold on 
midcross(y,x, 'StateLevels', [-0.16 -0.14])
xx=midcross(y,x, 'StateLevels', [-0.16 -0.14])
total_dur_pull= abs(xx(2))+abs(xx(1))
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
%% Find when the solenoid opens 
solenoid= B.data.out.event.left; 
soleno=(solenoid(solenoid(:,2)==1)); %remove NaNs and find only values where tone is HIGH'
lick_l= B.data.in.event.lick_left; 
lick_left= (lick_l(lick_l(:,2)==1));
%% plotting tone, reward, and licks. 
figure
p=plot (soleno, 0,'mo')
hold on
%set(p(2:74),'HandleVisibility', 'off');
q=plot (tone, 0, 'b*')
%set (z(2:74),'HandleVisibility','off');
r=plot (lick_left, 1, 'r^')
%set (q(2:74),'HandleVisibility','off');
hold off 
xlabel  ('time(s)') 
ylim ([-0.5,1.5])
set(get(get(p(2:74),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
set(get(get(q(2:74),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
legend ('sol', 'tone','lick')


%% 
