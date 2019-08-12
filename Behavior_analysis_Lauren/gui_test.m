%LR 
% 190812- this gui analyzes behavioral code given in GUI_Analysis_LR190812 

function varargout =gui_test(varargin)

% GUI_TEST MATLAB code for gui_test.fig
%      GUI_TEST, by itself, creates a new GUI_TEST or raises the existing
%      singleton*.
%
%      H = GUI_TEST returns the handle to a new GUI_TEST or the handle to
%      the existing singleton*.
%
%      GUI_TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_TEST.M with the given input arguments.
%
%      GUI_TEST('Property','Value',...) creates a new GUI_TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_test

% Last Modified by GUIDE v2.5 12-Aug-2019 16:59:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_test_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_test_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui_test is made visible.
function gui_test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_test (see VARARGIN)
% 
% 
B=evalin('base','B'); %this loads B from the workspace. 
%load('Z:\Users\Lauren\data\behavior\m273380\190809\m273380_190809_004.mat')
%basic initializations 
handles.out= B.B.data.out;
handles.in=B.B.data.in;
handles.history=B.B.data.history; 
handles.analysis= B.B.data.analysis;
tones_1= B.B.data.out.event.tone; 
handles.tone=(tones_1(tones_1(:,2)==1));
handles.force= B.B.data.in.ana.force;
% find average PULLS
for ii =1: length (handles.tone) 
    window_low= handles.tone(ii)-3; 
    window_high= handles.tone(ii)+3; 
    [c i_low] = min(abs(window_low-B.B.data.in.ana.force(:,1)));
    [c i_high] = min(abs(window_high-B.B.data.in.ana.force(:,1))); 
    traces= B.B.data.in.ana.force(i_low:i_high,2);
    i4traces=any(traces>0.15,2)==0; %getting rid of pushes for plot
    traces_2 =traces(i4traces,:);
    traces_final(1:length(traces_2),ii) = traces_2;
end 
handles.traces=traces_final; 
for ii= 1: length (traces_final)
    average_i(ii)= mean(traces_final(ii,:));
end 
handles.average= average_i; 
% average pushes 

for ii =1: length (handles.tone) 
    window_low= handles.tone(ii)-3; 
    window_high= handles.tone(ii)+3; 
    [c i_low] = min(abs(window_low-B.B.data.in.ana.force(:,1)));
    [c i_high] = min(abs(window_high-B.B.data.in.ana.force(:,1))); 
    traces= B.B.data.in.ana.force(i_low:i_high,2);
    i4traces_push=any(traces<-0.15,2)==0; %getting rid of pulls for plot
    traces_pushes =traces(i4traces_push,:); 
    traces_final2(1:length(traces_pushes),ii) = traces_pushes;
end 
handles.traces_push= traces_final2; 

% average push 
for ii= 1: length (handles.traces_push)
    average_i2(ii)= mean(handles.traces_push(ii,:));
end 
handles.average_push= average_i2; 

% minima of each pull 
for ii= 1: length(handles.tone)
    mini_i(ii)= min(handles.traces(:,ii)); %peak of each pull 
end
handles.min_pull=mini_i(mini_i<-0.15);
% maximum of each push 
for ii= 1: length(handles.tone)
    maxi_i(ii)= max(handles.traces_push(:,ii));
end
handles.max_push= maxi_i(maxi_i>0.15);
% traces
for ii= 1:length(handles.tone)
    window_low= handles.tone(ii)-3; 
    window_high= handles.tone(ii)+3; 
    [c i_low] = min(abs(window_low-handles.force(:,1)));
    [c i_high] = min(abs(window_high-handles.force(:,1)));
    traces (1:length (handles.force(i_low:i_high,2)),ii) = handles.force(i_low:i_high,2);
end
handles.tracesall= traces; 
% local mins of all traces 
tohist= [];
for ii= 1:length(handles.tone) %for each force trace
    y= handles.tracesall(:,ii) ;
    y2= smooth(y,20) ;
    TF = islocalmin(y2,'MinProminence',0.009);
    TF_real= y2(TF) ;%find local minima
    real= TF_real(TF_real<-0.15) ;
    tohist= vertcat(tohist,real); %concate all the minima into one array
end 
handles.histogram_min= tohist; 
% local max of all traces 
tohist2= [];
for ii= 1:length(handles.tone) %for each force trace
    y= handles.tracesall(:,ii) ;
    y2= smooth(y,20) ;
    TD = islocalmax(y2,'MinProminence',0.01);
    TD_real= y2(TD); %find local maxs
    real2= TD_real(TD_real>0.15) ;

    tohist2= vertcat(tohist2,real2); %concate all the minima into one array
end 
handles.histogram_max= tohist2; 
% duration of pulls
 for ii= 1:length(handles.tone)
     x_thisloop= linspace (-3, 3,length(handles.traces(:,ii)));
     y=handles.traces(:,ii);
     %pulsewidth(y,x_thisloop, 'StateLevels', [-0.16 -0.14]);
     %midcross(y,x_thisloop, 'StateLevels', [-0.16 -0.14]);
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
 
 handles.total_dur_pull= total_dur_pull; 
% push durations
for ii= 1:length(handles.tone)
     x_thisloop= linspace (-3, 3,length(handles.traces_push(:,ii)));
     %idxe1= find ((x_thisloop > -1.5)); idx1_real= idxe1(1);
     %idxe2= find(x_thisloop>1.5); idx2_real= idxe2(1); 
     %x= linspace (-3, 3,length(traces_final(idx1_real:idx2_real,ii)));
     %y= traces_final(idx1_real:idx2_real,ii);
     y=handles.traces_push(:,ii);
     %pulsewidth(y,x_thisloop, 'StateLevels', [0.14 0.16]);
     %midcross(y,x_thisloop, 'StateLevels', [0.14 0.16]);
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
 
handles.total_dur_pull2= total_dur_pull2;

% lick distribution
solenoid= B.B.data.out.event.left; 
handles.soleno=(solenoid(solenoid(:,2)==1)); %remove NaNs and find only values where tone is HIGH'
lick_l= B.B.data.in.event.lick_left; 
handles.lick_left= (lick_l(lick_l(:,2)==1));

%num rewards 
handles.tot_rewards= length(handles.soleno)

% printing number of rewarded push/pulls
myString= num2str(handles.tot_rewards); 
handles.text6.String = myString;
%import filename from workspace
filename=evalin('base','filename');
% print filename 
handles.text8.String= filename; 
% Choose default command line output for gui_test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_test wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Plot Tone(Preview).
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 %remove NaNs and find only values where tone is HIGH
%figure
%hold on 
%plot (B.data.in.ana.force(:,1),B.data.in.ana.force(:,2))
cla reset
plot (handles.tone, 0,'mo')
title ('Trials when tone is high')

% --- Executes on button press in Plot Tone (Create Figure).
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure 
plot (handles.tone, 0,'mo')
title ('Trials when tone is high')

% --- Executes on button press in Plot tone/force (Preview) .
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla reset
hold on 
plot (handles.force(:,1),handles.force(:,2))
plot (handles.tone, 0,'mo')
title ('Tone and force profile')
xlabel('trials')
ylabel ('force, AU')

% --- Executes on button press in Plot tone/force (Create Figure).
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure 
hold on 
plot (handles.force(:,1),handles.force(:,2))
plot (handles.tone, 0,'mo')
title ('Tone and force profile')
xlabel('trials')
ylabel ('force, AU')

% --- Executes on button press in Average and all Pulls (preview) .
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla reset

for ii= 10:length(handles.tone)-10
    window_low= handles.tone(ii)-3; 
    window_high= handles.tone(ii)+3; 
    [c i_low] = min(abs(window_low-handles.force(:,1)));
    [c i_high] = min(abs(window_high-handles.force(:,1)));
    traces = handles.force(i_low:i_high,2);
    i4traces=any(traces>0.1,2)==0; %getting rid of pushes for plot
    handles.traces_2 =traces(i4traces,:); %pulls only 
    handles.x=  linspace (-3, 3,length(handles.traces_2));
    p2= plot(handles.x,handles.traces_2)
    p2.Color(4) = 0.15;
    hold on
end 
x=  linspace (-3, 3,length(handles.traces(:,1)));
p3= plot (x, handles.average,'m')
p3.LineWidth=3
title ('Average Force Profile: Pulls')
xlabel('time,s')
ylabel ('force, AU')
% --- Executes on button press in  Average and all Pulls (create figure).
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure
hold on
title ('Average Force Profile: Pulls')
xlabel('time,s')
ylabel ('force, AU')
for ii= 10:length(handles.tone)-10
    window_low= handles.tone(ii)-3; 
    window_high= handles.tone(ii)+3; 
    [c i_low] = min(abs(window_low-handles.force(:,1)));
    [c i_high] = min(abs(window_high-handles.force(:,1)));
    traces = handles.force(i_low:i_high,2);
    i4traces=any(traces>0.15,2)==0; %getting rid of pushes for plot
    handles.traces_2 =traces(i4traces,:); %pulls only 
    handles.x=  linspace (-3, 3,length(handles.traces_2));
    p2= plot(handles.x,handles.traces_2)
    p2.Color(4) = 0.15;
    hold on
end 
x=  linspace (-3, 3,length(handles.traces(:,1)));
p3= plot (x, handles.average,'m')
p3.LineWidth=3

% --- Executes on button press in Average and all Pushes (preview) .
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla reset
hold on
title ('Average Force Profile: Pushes')
xlabel('time,s')
ylabel ('force, AU')
for ii= 10:length(handles.tone)-10
    window_low= handles.tone(ii)-3; 
    window_high= handles.tone(ii)+3; 
    [c i_low] = min(abs(window_low-handles.force(:,1)));
    [c i_high] = min(abs(window_high-handles.force(:,1)));
    traces = handles.force(i_low:i_high,2);
    i4traces_push=any(traces<-0.15,2)==0; %getting rid of pushes for plot
    handles.traces_pushes =traces(i4traces_push,:); %pulls only 
    handles.x2=  linspace (-3, 3,length(handles.traces_pushes));
    p2= plot(handles.x2,handles.traces_pushes)
    p2.Color(4) = 0.10;
    hold on
end 

x=  linspace (-3, 3,length(handles.traces_push(:,1)));
p3= plot (x, handles.average_push,'m')
p3.LineWidth=3

% --- Executes on button press in Average and all Pushes (create figure). 
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure 
hold on
title ('Average Force Profile: Pushes')
xlabel('time,s')
ylabel ('force, AU')
for ii= 10:length(handles.tone)-10
    window_low= handles.tone(ii)-3; 
    window_high= handles.tone(ii)+3; 
    [c i_low] = min(abs(window_low-handles.force(:,1)));
    [c i_high] = min(abs(window_high-handles.force(:,1)));
    traces = handles.force(i_low:i_high,2);
    i4traces_push=any(traces<-0.15,2)==0; %getting rid of pushes for plot
    handles.traces_pushes =traces(i4traces_push,:); %pulls only 
    handles.x2=  linspace (-3, 3,length(handles.traces_pushes));
    p2= plot(handles.x2,handles.traces_pushes)
    p2.Color(4) = 0.10;
    hold on
end 

x=  linspace (-3, 3,length(handles.traces_push(:,1)));
p3= plot (x, handles.average_push,'m')
p3.LineWidth=3

% --- Executes on button press in Histogram: Peaks of Push/Pull (Preview).
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla reset
histogram (handles.histogram_max) 
hold on 
histogram(handles.histogram_min)% overlay with the histogram of the minima of pulls 
hold on 
histogram(handles.min_pull) 
hold on 
histogram(handles.max_push)
legend ('local maxs', 'local mins','min of pulls','max of pushes')
xlabel ('Local extrema')
ylabel ('#occurences')
title ('Local Max and Mins, versus Max/Min of each pull/push')

% --- Executes on button press in Histogram: Peaks of Push/Pull (create figure).
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure 
histogram (handles.histogram_max) 
hold on 
histogram(handles.histogram_min)% overlay with the histogram of the minima of pulls 
hold on 
histogram(handles.min_pull) 
hold on 
histogram(handles.max_push)
legend ('local maxs', 'local mins','min of pulls','max of pushes')
xlabel ('Local extrema')
ylabel ('#occurences')
title ('Local Max and Mins, versus Max/Min of each pull/push')




% --- Executes on button press in duration of pulls (preview) .
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla reset
hist(handles.total_dur_pull)
xlabel ('duration of pull')
ylabel ('#occurences')
title ('Duration of Pulls')

% --- Executes on button press in duration of pulls (create figure).
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure 
hist(handles.total_dur_pull)
xlabel ('duration of pull')
ylabel ('#occurences')
title ('Duration of Pulls')


% --- Executes on button press in duration of pushes (preview).
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla reset
hist(handles.total_dur_pull2)
xlabel ('duration of push')
ylabel ('#occurences')
title ('Duration of Pushes')

% --- Executes on button press in duration of pushes (create figure) .
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure
hist(handles.total_dur_pull2)
xlabel ('duration of push')
ylabel ('#occurences')
title ('Duration of Pushes')

% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla reset
hold on 
plot(zeros(1,100), linspace (1, length(handles.tone)))
title ('Lick Distribution') 
xlabel('Time(s), Reward at t=0') 
ylabel ('Trials') 

for ii= 1: length (handles.soleno)
window_low2= handles.soleno(ii)-1.5; 
window_high2= handles.soleno(ii)+1.5; 
 
[c i_low] = min(abs(window_low2-handles.lick_left));
[c i_high] = min(abs(window_high2-handles.lick_left));
xlick= handles.lick_left(i_low:i_high);
x_toplot = xlick-mean(xlick);
plot (x_toplot, ii,'*')
xlim ([-2 2])
end 

% --- Executes on button press in Lick distribution (create figure).
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure
hold on 
plot(zeros(1,100), linspace (1, length(handles.tone)))
title ('Lick Distribution') 
xlabel('Time(s), Reward at t=0') 
ylabel ('Trials') 

for ii= 1: length (handles.soleno)
window_low2= handles.soleno(ii)-1.5; 
window_high2= handles.soleno(ii)+1.5; 
 
[c i_low] = min(abs(window_low2-handles.lick_left));
[c i_high] = min(abs(window_high2-handles.lick_left));
xlick= handles.lick_left(i_low:i_high);
x_toplot = xlick-mean(xlick);
plot (x_toplot, ii,'*')
xlim ([-2 2])
end 


% --- Executes on button press in clear analysis and start a new animal.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all
GUI_Analysis_LR190812;
close(gui_test);