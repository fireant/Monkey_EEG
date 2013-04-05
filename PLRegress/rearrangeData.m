%Clear all the previous data
clear
%Load the motion matrix as in the downloaded files in the Wiki
%You have to change the location of the files depending on where you have them
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
Mean=mean(NewData);
Std=std(NewData);
[time,dims]=size(NewData);
NewData=NewData-repmat(Mean,time,1);
NewData=NewData./repmat(Std,time,1);
for i=1:1036
eegT(i)=featTime{i,2};
end
[trash startIdx]=min(abs(eegT));
eegT=eegT(startIdx:end);
for i=1:length(eegT)
        [mi midx]=min(abs(MotionTime-eegT(i)));
        MIdx(i)=midx;
        NewMotion(i)=MotionTime(midx);
end
NewMotionData=NewData(MIdx,:);
MasterArray=MasterArray(startIdx:end,:);
