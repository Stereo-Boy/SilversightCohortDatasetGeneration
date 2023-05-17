function [outputTable] = removeDuplicates(inputTable)
%REMOVEDUPLICATES this function remove duplicates of q given table. used by most of Cohort experiment data importing functions 
    [~,idx]=unique(inputTable(:,1),'last'); % remove duplicities if any
    outputTable=inputTable(idx,:);
end

