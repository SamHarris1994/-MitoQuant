function varargout = SegmentThresh(varargin)
% SEGTHRESH MATLAB code for SegThresh.fig
%      SEGTHRESH, by itself, creates a new SEGTHRESH or raises the existing
%      singleton*.
%
%      H = SEGTHRESH returns the handle to a new SEGTHRESH or the handle to
%      the existing singleton*.
%
%      SEGTHRESH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEGTHRESH.M with the given input arguments.
%
%      SEGTHRESH('Property','Value',...) creates a new SEGTHRESH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SegThresh_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SegThresh_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SegThresh

% Last Modified by GUIDE v2.5 01-Feb-2016 10:43:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SegmentThresh_OpeningFcn, ...
                   'gui_OutputFcn',  @SegmentThresh_OutputFcn, ...
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


% --- Executes just before SegThresh is made visible.
function SegmentThresh_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SegThresh (see VARARGIN)

% Choose default command line output for SegThresh
global img
global frame
global st
global hFigure
global checked
global Detection
global currentframe

img = varargin{1};
checked = 1;
frame=img.framesNum;

set(handles.slider1,'Max',frame);
set(handles.slider1,'Min',1);
set(handles.slider1,'Value',1);
set(handles.edit1,'string',10)
currentframe=get(handles.slider1,'Value');

frame=size(img.data,4);
st(1:frame)=10;

set(handles.edit1,'value',st(currentframe))

handles.output = hObject;

hFigure=figure;

figure(hFigure)
hold off
imshow(max(img.data(:,:,:,1),[],3),[])

if checked
    hold on
    Detection = ParticleSegment(img.data(:,:,:,currentframe),st(currentframe));
    for i=1:size(Detection,1)
        co= Detection(i).Centroid;
        plot(co(1), co(2), '*')
    end
    hold off
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SegThresh wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SegmentThresh_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1

global hFigure
global img
global checked
global Detection
global currentframe

figure(hFigure)
hold off
imshow(max(img.data(:,:,:,currentframe),[],3),[])
checked=get(handles.checkbox1,'Value');

if checked
    hold on
    for i=1:size(Detection,1)
        co= Detection(i).Centroid;
        plot(co(1), co(2), '*')
    end
    hold off
end

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

global hFigure
global img
global checked
global Detection
global st
global currentframe

currentframe=round(get(handles.slider1,'value'));
st(currentframe:end)=str2num(get(handles.edit1,'string'));
set(handles.edit1,'string',st(currentframe));

figure(hFigure)
hold off
imshow(max(img.data(:,:,:,currentframe),[],3),[])
checked=get(handles.checkbox1,'Value');

if checked
    hold on
    Detection = ParticleSegment(img.data(:,:,:,currentframe),st(currentframe));
    for i=1:size(Detection,1)
        co= Detection(i).Centroid;
        plot(co(1), co(2), '*')
    end
    hold off
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hFigure
global st
close(hFigure)
close(gcf)
save st st

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global hFigure
global currentframe
global img
global checked
global Detection
global st
currentframe=round(get(handles.slider1,'Value'));
set(handles.edit1,'string',st(currentframe))

figure(hFigure)
hold off
imshow(max(img.data(:,:,:,currentframe),[],3),[])
checked=get(handles.checkbox1,'Value');



if checked
    hold on
    Detection = ParticleSegment(img.data(:,:,:,currentframe),st(currentframe));
    for i=1:size(Detection,1)
        co= Detection(i).Centroid;
        plot(co(1), co(2), '*')
    end
    hold off
end

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
