%% Finding tones: this section makes a plot of force profile, and tone presentations overlaid. 
tones_1= B.data.out.event.tone; 
tone=(tones_1(tones_1(:,2)==1)); %remove NaNs and find only values where tone is HIGH
figure
plot (tone, 0,'mo')
hold on 
plot (B.data.in.ana.force(:,1),B.data.in.ana.force(:,2))
%% Force Profile for one pull (here, it is written as the first pull) 
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
%% plot  force traces 3 seconds before and after each tone 

figure
for ii= 1:length(tone) 
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

%% Need to be able to seperate out pulls and pushes 
%B.data.in.event.pull(1,1)== B.data.in.ana.force(1,1)
%figure
i4traces=any(traces>0.15,2)==0;
traces =traces(i4traces,:); 
x=  linspace (-3, 3,length(traces));
%plot (x,traces);

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


% average 
for ii= 1: length (traces_final)
    average_i(ii)= mean(traces_final(ii,:));
end 
% plot
figure 
x=  linspace (-3, 3,length(traces_final(:,1)));
plot (x, traces_final(:,21),'m--') %here, using event of the 21st tone to plot an example trace of force around that tone (3 s before, and 3 s after), to compare to the average 
hold on 
plot (x, average_i)
title ('force profile example and average')
xlabel('time,s')
ylabel ('force, AU')
legend ('Example force trace', 'average force pull')

%% putting it all together (plots 3 seconds before and after each pull, and  then the average of those force traces overlaid on that

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
histogram(mini_i)
xlabel ('trough/minimum of pull')
ylabel ('#occurences')
title ('Peak of Pulls')
%% next: need a histogram of the duration of all movements, not just counted pulls. Idea: does this histogram contain the pull histogram
%% also: may want to change the pull so it only searches for minima in a certain area.
%%
for ii= 1:length(tone)
    window_low= tone(ii)-3; 
    window_high= tone(ii)+3; 
    [c i_low] = min(abs(window_low-B.data.in.ana.force(:,1)));
    [c i_high] = min(abs(window_high-B.data.in.ana.force(:,1)));
    traces (1:length (B.data.in.ana.force(i_low:i_high,2)),ii) = B.data.in.ana.force(i_low:i_high,2);
end

%% an example of a way to find  extrema (note: it finds too many, NOT using for now) 
figure
x= linspace(-3,3, length(traces));
y=traces(:,54);
plot (x, y)
[ymax,imax,ymin,imin] = extrema(y);
hold on
plot(x(imax),ymax,'r*',x(imin),ymin,'g*')
%% Finds all Local Minima, with a given prominence (after mild smoothing)  
y=traces(:,1);
x= linspace(-3,3, length(traces));
y2= smooth(y,20);
TF = islocalmin(y2,'MinProminence',0.009);
TRYME= y2(TF);
figure
plot(x,y2,x(TF),y2(TF),'r*')
%%  This is a histogram of the minima for the FIRST pull 
figure
histogram(y2(TF))
x= linspace (-3, 3,length(TRYME));
%figure 
%scatter (x,TRYME)
%% increase to all traces 
%figure
tohist= [];
for ii= 1:length(tone) %for each force trace
    y= traces(:,ii) ;
    y2= smooth(y,20) ;
    TF = islocalmin(y2,'MinProminence',0.009);
    TF_real= y2(TF) %find local minima
    tohist= vertcat(tohist,TF_real); %concate all the minima into one array
end 
figure 
histogram (tohist) 
hold on 
histogram(mini_i)% overlay with the histogram of the minima of pulls 
%% Now, find all local maxs? 
y=traces(:,54);
x= linspace(-3,3, length(traces));
y2= smooth(y,20);
%TF = islocalmin(y2,'MinProminence',0.009);
TD= islocalmax(y2,'MinProminence', 0.01)
figure
plot(x,y2,x(TD),y2(TD),'r*')

TRYME_max= y2(TD);
%% increase to find max of each trace 
tohist2= [];
for ii= 1:length(tone) %for each force trace
    y= traces(:,ii) ;
    y2= smooth(y,20) ;
    TD = islocalmax(y2,'MinProminence',0.01);
    TD_real= y2(TD); %find local maxs
    tohist2= vertcat(tohist2,TD_real); %concate all the minima into one array
end 
%%
figure 
histogram (tohist2) 
hold on 
histogram(tohist)% overlay with the histogram of the minima of pulls 
hold on 
histogram (mini_i) 
legend ('local maxs', 'local mins','min of pulls')
xlabel ('trough/minimum of pull')
ylabel ('#occurences')
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Pushes 
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
    traces_final2(1:length(traces_pushes),ii) = traces_pushes;
end 


% average 
for ii= 1: length (traces_final2)
    average_i2(ii)= mean(traces_final2(ii,:));
end 
%%
figure 
x=  linspace (-3, 3,length(traces_final2));
%plot (x, traces_final(:,21),'m--')
hold on 
plot (x, average_i2)
title ('force profile example and average')
xlabel('time,s')
ylabel ('force, AU')
legend ('Example force trace', 'average force pull')
%% Putting it all together 
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
%% maximum of pushes 
for ii= 1: length(tone)
    maxi_i(ii)= max(traces_final2(:,ii));
end
 figure
histogram(maxi_i)
xlabel ('max of pull')
ylabel ('#occurences')
title ('Peak of Push')
%% try putting all the histogram stuff together: 
figure 
histogram (tohist2,20) 
hold on 
histogram(tohist,20)% overlay with the histogram of the minima of pulls 
hold on 
histogram(mini_i,5) 
hold on 
histogram(maxi_i,5)
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
%% First pass, at finding the duration of the 21st pull: 
x= linspace (-3, 3,length(traces_final(:,21)))
idxe1= find ((x > -0.5)); idx1_real= idxe1(1);
idxe2= find(x>0.2); idx2_real= idxe2(1); 
x= linspace (-3, 3,length(traces_final(idx1_real:idx2_real,2)))
figure
%pulsewidth(traces_final(idx1_real:idx2_real,21),x2,'StateLevels',[-0.15005, -0.14999])
y= traces_final(idx1_real:idx2_real,2)
pulsewidth(y,x, 'StateLevels', [-0.16 -0.14])
hold on 
midcross(y,x, 'StateLevels', [-0.16 -0.14])
xx=midcross(y,x, 'StateLevels', [-0.16 -0.14])
%total_dur_pull= abs(xx(2))+abs(xx(1))
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



%% lick distribtution: center reward at 0 
figure
plot(soleno(1),0,'m^')
%% 
window_low2= soleno(1)-1; 
window_high2= soleno(1)+1; 
[c i_low] = min(abs(window_low2-lick_left));
[c i_high] = min(abs(window_high2-lick_left));

figure
%plot(B.data.in.ana.force(window_low:window_high,1),B.data.in.ana.force(window_low:window_high,2))
%x= linspace (-1, 1,length(lick_left(i_low:i_high)));
%xxx= normalize(lick_left(i_low:i_high))


xxxx= lick_left(i_low:i_high)
mean(xxxx) 
x3= xxxx-mean(xxxx) 


%hold on 
plot (x3,0,'m*')

title ('force profile 1st pull')
xlabel('time,s')
ylabel ('force, AU')
%% 
figure
hold on 
plot(zeros(1,100), linspace (1, 85))


for ii= 1: 81 
window_low2= soleno(ii)-1.5; 
window_high2= soleno(ii)+1.5; 
 
[c i_low] = min(abs(window_low2-lick_left));
[c i_high] = min(abs(window_high2-lick_left));
xlick= lick_left(i_low:i_high);
x_toplot = xlick-mean(xlick);
plot (x_toplot, ii,'*')
end 

%% STOP HERE FOR NOW %% 
%% try redoing it to be the number of licks in the time window. 

window_low2= soleno(4)-1.5; 
window_high2= soleno(4)+1.5; 
 
[c i_low] = min(abs(window_low2-lick_left));
[c i_high] = min(abs(window_high2-lick_left));
xlick= lick_left(i_low:i_high);
x_toplot = xlick-mean(xlick);

x_one= x_toplot(x_toplot>0);
x_minusone=x_toplot(x_toplot<0);

numposlicks= length(x_one)
numanticipatorylicks= length(x_minusone)

for_sanity= length(x_toplot) 



%% loop this (histogram?) 

for ii=1 :length(soleno)
    window_low2= soleno(ii)-1.5; 
    window_high2= soleno(ii)+1.5; 
 
    [c i_low] = min(abs(window_low2-lick_left));
    [c i_high] = min(abs(window_high2-lick_left));
    xlick= lick_left(i_low:i_high);
    x_toplot = xlick-mean(xlick);
    x_one= x_toplot(x_toplot>0);
    x_minusone=x_toplot(x_toplot<0);

    numposlicks(ii)= length(x_one);
    numanticipatorylicks(ii)= length(x_minusone);
    totallicks(ii)= length(x_toplot);
end 

figure  
histogram(numposlicks)
hold on 
histogram (numanticipatorylicks)
%%
figure 

%h=cdf(numposlicks)

x6=linspace(0,1.5,81)
x7=linspace (-1.5,0,81)
stem (x6,numposlicks) 
hold on 
stem (x7,numanticipatorylicks,'^')
%% 
mean(numposlicks) 
mean(numanticipatorylicks) 
%% 

for ii=1:81
window_low2= soleno(ii)-1; 
window_high2= soleno(ii)+1; 
 
[c i_low] = min(abs(window_low2-lick_left));
[c i_high] = min(abs(window_high2-lick_left));
xlick= lick_left(i_low:i_high);
x_toplot = xlick-mean(xlick);
%%%% 
    
%xTEST= x_toplot(x_toplot>-1&x_toplot< -0.8)
%totlicks(ii)= length(xTEST);

end 
%figure
for jj= 2: length(x) 
        xTEST= x_toplot(x_toplot>x(jj)&x_toplot< x(jj-1))
        totlicks(jj)= length(xTEST);
end 
%bar(-1:-0.75, sum(totlicks)) 

%% 
%figure
%x = -1:1/4:1;
%y = [plotme(1), ];
%bar(x,y)

%% 
%x_toplot (x_toplot>-0.5 & x_toplot<-0.25)
%numlickstimewindow= 

