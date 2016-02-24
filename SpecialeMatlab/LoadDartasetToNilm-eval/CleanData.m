
path = 'downloadedData';
savepath = 'downloadedDataClean';
ports = [85;87;89;91;93;1206;1207;1208;1209;1210;1211;1212;1213;1214;1215;1216;1328;1329;1330;1331;1332]';
sampleRate = 1;

mkdir(savepath); 
for port = ports
    disp(['Cleaning Port ' num2str(port)]);
    listing = dir([path '\' num2str(port)]);
    mkdir([savepath '\' num2str(port)]); 
    for index = 3:length(listing)
        file = listing(index).name;
        
        values = load([path '\' num2str(port) '\' file]);
        data = values.data;
        cleanData = ones(1,(60*60*24/sampleRate))*-1;
        if( size(data,1) > 2 )
            %find time ranges
            [pathstr,name,ext] = fileparts(file);
            date = datetime(name);
            startTimeepox = (datenum(date)-datenum(datetime(1970,1,1)))*24*60*60 - (60*60*2);
            EndTimeepox = ((datenum(date)+day(1))-datenum(datetime(1970,1,1)))*24*60*60 - (60*60*2);
            
            
            % find fist sample timestamp
            firstSampleTime = data{1,1}-startTimeepox;
            while(firstSampleTime>sampleRate*1.2)
                firstSampleTime = firstSampleTime - sampleRate;
            end;
            
            %Create smooth samples
            samples_n = firstSampleTime+startTimeepox:sampleRate:(EndTimeepox+sampleRate/2);
            val = [];
            [val(:,1),IA,IC] = unique(data{:,1});
             val(:,2) = data{IA,2}  / 1000;
            cleanData = interp1(val(:,1), val(:,2), samples_n);
            
            %Introduce the correct errors
            realSamplerate = round(median(val(2:end,1)-val(1:end-1,1))); 
            
            delay = max((round(val(2:end,1)-val(1:end-1,1))/realSamplerate)-1,0);
            e_id_start = [delay > 0; false];
            e_id_end = [false ; delay > 0];
            
            e_n_start = val(e_id_start,1);
            e_n_end = val(e_id_end,1);
            
            for i = 1:length(e_n_start)
                start_time = e_n_start(i)+(0.4*realSamplerate);
                end_time = e_n_end(i)-(0.4*realSamplerate);
                
                erroIDS = samples_n > start_time & samples_n < end_time;
                cleanData(erroIDS) = -1; % error symbol
            end
            
            cleanData(isnan(cleanData)) = -1;
            
        end %end if    
        
        
        data = cleanData';
        data = data(1:(60*60*24/sampleRate));
        save([savepath '\' num2str(port) '\' file], 'data');
    end % end day loop 
    
end % end meter port loop 