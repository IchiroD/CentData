function [wave,time,Header]=readCentKyowaCSVfile_(dirname,filename)
%{
% Sample Script
dirname='/Users/s_k/Documents/MyMBPbig/C1808Cent/C1808CentWE/CSV_180804/SKK180810/';
filename='_20180810_0021.csv';

[Header,wave]=readCentKyowaCSVfile_(dirname,filename);

%}
    DrFn=[dirname filename];
    
    wave=csvread(DrFn,15,1);        
    %temp=dlmread(DrFn,[0 1 0 1],'delimiter',',')

    fid = fopen(DrFn);
    for ii=1:15, 
        tline = fgetl(fid);
        %disp(tline)
        temp=textscan(tline,'%s','delimiter',',');
        Headers{ii}=temp{1};
    end
    fclose(fid);
   
   Header.FileName=filename;
   %"データ種類","動的データ"
   Header.Type=Headers{1}{2}(2:end-1);
   %"試験番号","170530"
   Header.TestNumber=str2num(Headers{2}{2}(2:end-1));
   %"試験名称","test"
   Header.Name=Headers{3}{2}(2:end-1);
   %"測定チャンネル",8
   Header.NumberOfChannel=str2num(Headers{5}{2});
   %"デジタル入力","---"
   %"試験日時","2017/09/08","15:12:23"
   Header.DT0_str0=[Headers{4}{2}(2:end-1) ' ' Headers{4}{3}(2:end-1)];
   Header.DT0_num=datenum(Header.DT0_str0);
   
   % "サンプリング周波数",10000.000000
   Header.Fs=str2num(Headers{7}{2});
   
   % "データ/ch",200000
   Header.NT0=str2num(Headers{8}{2});
   
   % "測定時間", 20.000000
   Header.T0s=str2num(Headers{9}{2});

   %"計測点名称","A-T","A-1","A-2","A-3","A-4","A-E4","DVS1","GRAVITY"
   for ii=1:Header.NumberOfChannel,
       Header.Items{ii}=Headers{10}{ii+1}(2:end-1);
   end

   %"チャンネル No","A-001","A-002","A-003","A-004","A-005","A-006","A-043","A-100"
   for ii=1:Header.NumberOfChannel,
       Header.ChNum{ii}=Headers{11}{ii+1}(2:end-1);
   end
   
   %12: "レンジ",1000.000,1000.000,1000.000,1000.000,1000.000,1000.000,10.000,500.000
   for ii=1:Header.NumberOfChannel,
       Header.Range(ii)=str2num(Headers{12}{ii+1}(1:end));
   end
    
   %"13:校正係数",0.441,0.498,0.463,0.498,0.521,0.532,6.000,0.209
   for ii=1:Header.NumberOfChannel,
       Header.Coef(ii)=str2num(Headers{13}{ii+1}(1:end));
   end
   
   %"オフセット",0.000,0.000,0.000,0.000,0.000,0.000,0.000,0.000
   for ii=1:Header.NumberOfChannel,
       Header.Offset(ii)=str2num(Headers{14}{ii+1}(1:end));
   end
   
   %"単位","m/s2","m/s2","m/s2","m/s2","m/s2","m/s2","mm",""
   for ii=1:Header.NumberOfChannel,
       Header.Units{ii}=Headers{15}{ii+1}(2:end-1);
   end

   tmp=dir(DrFn);
   Header.FileInfo=tmp;
   
   T0.str_ori_file=tmp.date;
   T0.num_file=tmp.datenum;
   
   
   T0.str_ori1=Header.DT0_str0;
   T0.num=datenum(T0.str_ori1,'yyyy/mm/dd HH:MM:SS');
   T0.str_mat=datestr(T0.num,'yyyy/mm/dd HH:MM:SS.FFF');
   time.T0=T0;
   time.dt0=1/Header.Fs;
   time.NT0=Header.NT0;
   time.DT0=Header.T0s; 
   
end