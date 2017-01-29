function [fileList, fld_idx] = getAllFiles(dirName, idx_count)
  if ~exist('idx_count', 'var')
        idx_count = 0;
        fld_idx = [];
  end
  dirData = dir(dirName);      %diavazoume ola ta arxeia tou fakelou
  dirIndex = [dirData.isdir];  %pairnoume to index twn directories
  filenames = char(dirData.name);
  rejected_files = strncmpi(mat2cell(filenames, ones(1, size(filenames, 1)), size(filenames, 2)), '.', 1);
  fileList = {dirData(~dirIndex & ~rejected_files').name}';  %pairnoume lista olwn twn arxeiwn
  if ~isempty(fileList)
    fileList = cellfun(@(x) fullfile(dirName,x),...  %xtizoume to path twn arxeiwn
                       fileList,'UniformOutput',false);
  end
  subDirs = {dirData(dirIndex).name};
  validIndex = ~ismember(subDirs,{'.','..'});  %afairoume to . kai ..
  
  for iDir = find(validIndex)
    nextDir = fullfile(dirName,subDirs{iDir});    %path fakelou
    newFiles = getAllFiles(nextDir, idx_count);
    fileList = [fileList; newFiles];  %kaloume th sunarthsh anadromika gia ka8e fakelo
    idx_count = idx_count + 1;
    fld_idx = [repmat(idx_count, size(newFiles,1), 1); fld_idx];
  end
end