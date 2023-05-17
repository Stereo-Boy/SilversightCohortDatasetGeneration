function process_Audiogram(PROCESSED_DATA_DIR,AUDIO_VARIABLE_NAMES)
    
   % [PROCESSED_DATA_DIR,AUDIO_VARIABLE_NAMES]=getAudioConf();
   % config();
    
    % GUI window
    width=1000;
    height=500;
    f = figure('Visible','off','Position',[0,0,width,height]);

    % buttons
    uicontrol(f, 'Style','text','String', 'Subject ID', 'HorizontalAlignment','left','Position', [width/2-100, 70, 90, 12]);
    uicontrol(f, 'Style','edit','String', '', 'Position', [width/2-40, 70, 150, 20],'Callback', @SubjectIdFieldCallback);
    uicontrol(f,'Style','pushbutton','String','Add data','Position',[width/2-85,10,75,20],'Callback', @SaveBtnCallback);
    uicontrol(f,'Style','pushbutton','String','Store to file','Position',[width/2+10,10,75,20],'Callback', @ExtractBtnCallback );
    uicontrol(f,'Style','pushbutton','String','Mark for correction','Position',[width/2-250,10,150,20],'Callback', @MarkBtnCallback);
    uicontrol(f,'Style','pushbutton','String','Show data','Position',[width/2+100,10,100,20],'Callback', @ShowBtnCallback);
    uicontrol(f,'Style','pushbutton','String','Remove last','Position',[width/2+230,10,100,20],'Callback', @RemoveBtnCallback);

    % axes on the left (right ear)
    rightEarAx = axes(f);
    rightEarAx.Units = 'pixels';
    rightEarAx.Position = [75 120 370 350];
    grid on
    rightEarAx.YAxis.MinorTick = 'on';
    rightEarAx.YAxis.MinorTickValues = -115:10:15;
    rightEarAx.YMinorGrid = 'on';
    ylim([-110,+20]);
    xlim([0,8]);
    yticks(-110:10:20);
    xticks(0:8);
    xticklabels({'','125','250','500','1000','2000','4000','8000','16000'});
    set(gca,'XAxisLocation','top');

    % axes on the right (left ear)
    leftEarAx = axes(f);
    leftEarAx.Units = 'pixels';
    leftEarAx.Position = [width-420  120 370 350];
    grid on
    leftEarAx.YAxis.MinorTick = 'on';
    leftEarAx.YAxis.MinorTickValues = -115:10:15;
    leftEarAx.YMinorGrid = 'on';
    ylim([-110,+20]);
    xlim([0,8]);
    yticks(-110:10:20);
    xticks(0:8);
    xticklabels({'','125','250','500','1000','2000','4000','8000','16000'});
    set(gca,'XAxisLocation','top');

    % initialization
    subjectID='';
    x=[1,2,3,4,5,5.5,6,6.5,7];  % these x values correspond to frequencies from 125 to 8000
    yRight=[];
    yLeft=[];
    data=cell(0);
    t=table();
    correct='false'; % whether to mark subject data for correction

    f.Name = 'Audiogram Made Easy';
    movegui(f,'north');
    set(f,'menubar','none');
    f.Visible = 'on';

    function SubjectIdFieldCallback(source, eventdata)
        % record subject data from mouse clicks
    
        subjectID= get(source,'String');

        % mark data for this subject for correction afterwards
        correct = 'false';
        
        % clear axes
        cla(rightEarAx);
        cla(leftEarAx);
        
        % focus on the right ear axes
        axes(rightEarAx);
        yRight = [];
        for i=1:9
            hold on
            plot([x(i),x(i)],[-110,20],':','Color','g', 'linewidth',2);
            [~,yr]=ginput(1);
            yr=roundX(yr)
            yRight = [yRight, yr];
            plot(x(i),yr,'-*','Color','r');
            %disp(yRight)
        end
        plot(x,yRight,'r-','linewidth',2);
        
        
        % focus on the left ear axes
        axes(leftEarAx);
        yLeft = [];
        for i=1:9
            hold on
            plot([x(i),x(i)],[-110,20],':','Color','g', 'linewidth',2);
            [~,yr]=ginput(1);
            yr=roundX(yr)            
            yLeft = [yLeft, yr];
            plot(x(i),yr,'-*','Color','r');
            %disp(yRight)
        end
        plot(x,yLeft,'r-','linewidth',2);
    end

    function MarkBtnCallback(source, eventdata)
        % mark this subject for correction afterwards
        if size(yRight,1)==0
            fprintf('Subject data empty, nothing to mark\n')
        else
            correct = 'true';
        end
        
    end

    function ShowBtnCallback(source, eventdata)
        % show current data
        disp('Data:')
        data
    end

    function RemoveBtnCallback(source, eventdata)
        % remove data from last subject in the list
        if size(data,1)==0
            disp('No data to remove')
        else
            data(size(data,1),:) = []
            fprintf('Data from subject %s removed form the list\n', subjectID)
        end
    end

    function SaveBtnCallback(source, eventdata)
        
        if (size(yRight,1)==0 || size(yLeft,1)==0)
            fprintf('Subject data empty, nothing to save\n')
        else
            % add data for the subject to the list
            newEntry=[{subjectID}, num2cell(yRight), num2cell(yLeft), {correct}];
            if(size(data,1)==0)
                data=newEntry;
            else
                data=[data;newEntry];
            end

            % clear coordinates
            yRight=[];
            yLeft=[];

            fprintf('Data from subject %s added (%d subjects with %d columns)\n', subjectID, size(data,1), size(data,2))
        end
    end

    function ExtractBtnCallback(source,eventdata)
        % store list of subject data to CSV table 'data.csv'
        % if the table does not exist it is created, otherwise data is
        % added to it
            
        
        if size(data,1)==0
            disp('Data empty, nothing to write')
        else
            filename = 'audiograms.xlsx';
            try
                oldT=readtable(fullfile(PROCESSED_DATA_DIR, filename));
                t=cell2table(data);
                t.Properties.VariableNames=AUDIO_VARIABLE_NAMES;
                t=[oldT;t];
                writetable(t,fullfile(PROCESSED_DATA_DIR, filename), 'Sheet',1);
                fprintf('Data written to existing file %s\n', filename)
            catch
                t=cell2table(data);
                t.Properties.VariableNames=AUDIO_VARIABLE_NAMES;
                writetable(t,fullfile(PROCESSED_DATA_DIR, filename), 'Sheet',1);
                fprintf('Data written to newly created file %s\n', filename)
            end
            data=cell(0);
        end
    end

    function rounded = roundX(x)
        % round value x to the closest value which multiple of 5
        r = rem(x,5);
        y=x-r
        
        if x<0
            if abs(r)>2.5
                y=y-5
            end
        else
            if abs(r)>2.5
                y=y+5
            end
        end
        rounded=y
    end
end