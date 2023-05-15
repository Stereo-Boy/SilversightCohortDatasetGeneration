function [outputTable] = removeDuplicities(inputTable)
%REMOVEDUPLICITIES this function remove duplicties of q given table. used by ;ost of Cohort experiment data importing functions 
    [~,idx]=unique(inputTable(:,1),'last'); % remove duplicities if any
    outputTable=inputTable(idx,:);
end

