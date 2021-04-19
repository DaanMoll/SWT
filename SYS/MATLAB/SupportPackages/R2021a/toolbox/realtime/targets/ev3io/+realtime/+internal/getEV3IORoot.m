function rootDir = getEV3IORoot
% getEV3IORoot - returns the root path of EV3 I/O support package

%   Copyright 2014 The MathWorks, Inc.


rootDir = fileparts(fileparts(fileparts(mfilename('fullpath'))));


%     s = fileparts(which('legoev3'));
%     pat = '(?<root>.*)legomindstormsev3io.*';
%     rootstr = regexp(s, pat, 'names');
%     result = rootstr.root;
end