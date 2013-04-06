%Clear all the previous data from the workspace
clear
%Load the motion matrix as in the downloaded files in the Wiki
%You have to change the location of the files depending on where you have them
%This first line loads the motion data
load('/home/leon/Data/Monkey/20090611S1_FTT_A_ZenasChao_mat_ECoG32-Motion12/Motion.mat')
%Specify the number of channels
NoChannels=32
%Declare an empty array to store the data
MasterArray=[]
%This part iterates over all the files and append them in MasterArray, these files have been previously processed by 
for i=1:NoChannels
        direct='/home/leon/Data/Monkey/Features/features_ch';
        infile=strcat(direct,num2str(i),'.mat'); %This just createes the dynamic filenames (infile)
        load(infile);
        for j=1:length(featTime)
                Temp(j,:)=featTime{j,1}; %Store everything in a temporal matrix
        end
        MasterArray=[MasterArray Temp]; %Concatenate the temporal array in the Master Input data
end


%NewData is an array that extracts the information 
NewData=[];
for i=7:7
        NewData=[NewData MotionData{i}];
end
%Normalization of newdata
%The normalization of the data is done substractin the mean and dividing by the Standard Deviation, as donde in the paper
%Other Normalization methods could also be used
Mean=mean(NewData);%Calculate the mean
Std=std(NewData);%Calculate the standard deviation
[time,dims]=size(NewData);%get the properties of the data
NewData=NewData-repmat(Mean,time,1); %rest the mean
NewData=NewData./repmat(Std,time,1); %rest the stdv
for i=1:length(featTime) %iterate over all the cells in the featime structure
        eegT(i)=featTime{i,2}; %Extract the timestamp from the cells
end
[trash startIdx]=min(abs(eegT));%Obtain the minimum timestamp
%The minimum timestamp has to be done, since the EEG starts before the motion, 
%the motion starts at time 0, but the EEG has not ime 0 
%startidx contains the first timestamp
eegT=eegT(startIdx:end);%rearrange the array
MasterArray=MasterArray(startIdx:end,:);%Master array need to be rezised as well
for i=1:length(eegT)
        [mi midx]=min(abs(MotionTime-eegT(i)));%Find the closest timestamp in motion to the one in the EEG
        MIdx(i)=midx;%Create an array with all the indexes of the motion
        NewMotion(i)=MotionTime(midx);
end
NewMotionData=NewData(MIdx,:);%Use the indexes to get the correspondent motion array

