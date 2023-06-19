function compact_data = compacting(data, subject, column2develop,columnDate,VD_column)
% Change the format of data from developped format (long), with one observation on each
% line to compact format (wide), with one subject with all the observations on each line.
% Use dates in case of duplicates, and keep only the latest data.
% data should be a developped (long) table
% subject indicates the name of the subject's ID column
% column2develop indicates the name of the column to develop. It should store the values that will be developped as columns 
% in the compact (wide) format.
% columnDate indicates the name of the column with dates
% VD_columns indicates the name or a cell of names with the variables to use as VD - for the moment, the code only tolerates one column.
try
values = table2array(unique(data(:,column2develop))); % values of the column to develop.
if isnumeric(values(1)) || istr(values(1))
    values(isempty(values))=[];
    if isnumeric(values(1))
        values=cellstr(num2str(values));
        tmp = cellstr(num2str(table2array(data(:,column2develop))));
        data(:,column2develop) = [];
        data(:,column2develop) = tmp;
    else
        values=cellstr(values); 
    end
else
    values(cellfun(@isempty,values))=[]; %clean up empty values
end

if isdatetime(data(1,columnDate))==0
    tmp = datetime(table2array(data(:,columnDate)));
    data(:,columnDate) = [];
    data(:,columnDate) = table(tmp);
end
    
develop_values = table2array(data(:,column2develop));
    for i=1:numel(values)
        dateCol = [columnDate,'_',values{i}];
        pp1 = table(table2array(data(strcmp(develop_values,values(i)),subject)),table2array(data(strcmp(develop_values,values(i)),VD_column)),table2array(data(strcmp(develop_values,values(i)),columnDate)),'VariableNames',{subject,[VD_column,'_',values{i}],dateCol});
        pp2 = sortrows(pp1,dateCol); %sort by ascending dates
        pp3 = pp2(isnat(table2array(pp2(:,dateCol))),:); %separate NaT values
        pp4 = pp2(~isnat(table2array(pp2(:,dateCol))),:);
        pp5 = [pp3;pp4];
        pp6 = pp5(:,dateCol);
        pp5(:,dateCol)=[];
        pp5(:,dateCol)=cellstr(datestr(table2array(pp6),'dd/mm/yyyy'));%retransform the date column as string again
        pp6 = removeDuplicates(pp5); % remove duplicates with NaT given first (removeDuplicates takes the last values)
        if i==1
            compact_data = pp6;
        else
            compact_data = outerjoin(compact_data,pp6,'Type','full','Keys',subject,'MergeKeys',true); 
        end
    end
catch err
   keyboard
   rethrow(err)
end
end