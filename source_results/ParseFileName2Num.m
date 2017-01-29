function [ number ] = ParseFileName2Num( fileName )

fileName_ascii = double(fileName);
numMask = (fileName_ascii <= double('9')).*(fileName_ascii >= double('0'));
numChars = fileName_ascii.*numMask;
numChars(numChars == 0) = double(' ');
number = str2num(char(numChars));

end

