function data7 = sort_date_remove_duplicates(data,datefield)
% Sorting data with ascending dates in the field datefield, even when some are missing, in which case, missing date
% lines are put in the beginning rather than the end
% Then remove duplicates, keeping the last lines when duplicates in the first column value.
% Finally, reconvert the output with string data fields.
        % sort the data by ascending dates after converting dates to date format
        try
        dates = datetime(table2array(data(:,datefield)),'InputFormat','dd/MM/yyyy');
        data(:,datefield) = []; 
        data{:,datefield} = dates;
        data2 = sortrows(data,datefield);
        % split by nat and dates, and put the nat first
        data3 = data2(isnat(table2array(data2(:,datefield))),:);
        data4 = data2(~isnat(table2array(data2(:,datefield))),:);
        data5 = [data3;data4];
        % remove duplicates
        data6 = removeDuplicates(data5);
        % retransform the date column as string again
        data7 = data6;
        data7(:,datefield)=[];
        data7(:,datefield)=cellstr(datestr(table2array(data6(:,datefield)),'dd/mm/yyyy'));
        catch err
            keyboard
        end
end