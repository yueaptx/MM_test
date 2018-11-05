clear
close all
clc

elemType = 4;
% 1: 2-node line; 2: 3-node triangle; 3: 4-node quadrangle; 4: 4-node
% tetrahedraon

meshID=0;

burgers=0.2722e-9;  % burgers vector magnitude [m] 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MSH ASCII file format 
% $MeshFormat
% version-number | file-type | data-size
%       %f             %d          %d
% $PhysicalName
% number of names
%       %d
% physical-dimension | physical-number | physical-name
%       %d                    %d               %s
% $Nodes
% number of nodes
%       %d
% node-number | x-coord | y-coord | z-coord
%       %d        %f        %f        %f
% $Elements
% numbwe of elements   
%       %d
% elem-number | elem-type | number-of-tags | first-tag | second-tag | node-number-list
%       %d         %d            %d             %d          %d           %d

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Open the .txt file
fileID = fopen('block_structured1.txt', 'r');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Read the data
% $MeshFormat (%f %d %d)
textscan(fileID, '$%s');                    % header
textscan(fileID, '%f %d %d');               % version-number file-type data-size

% $PhysicalNames
textscan(fileID, '$%s');                    % header
textscan(fileID, '%d %d %s');               % physical-dimension physical-number physical-name    

% $Nodes
textscan(fileID, '$%s');                    % header
nodes = textscan(fileID, '%d %f %f %f');    % node-number x-coord y-coord z-coord

% $Elements
textscan(fileID, '$%s');                    % header
elems = textscan(fileID, '%d %d %d %d %d %d %d %d %d');
                                            % elem-number elem-type num-of-tags first-tag second-tag node-number-list    

fclose(fileID);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Post-processing
% nodes
numNode = nodes{1}(1);                                                      % number of nodes
nodeID = double(nodes{1}(2:end)-1);                                         % node ID
nodeCoord = [nodes{2}(2:end), nodes{3}(2:end), nodes{4}(2:end)]/burgers;    % nodal coordinates [x, y, z]
N = [nodeID, nodeCoord]';                                                   % prepare for N.txt

% elements
elemTet = elems{2}==elemType;
numElem = sum(elemTet);                                                     % number of elements
elemID = [0:numElem-1]';                                                    % element ID
elemNode = zeros(numElem, size(elems,2)-5);                                 % element connectivity
for i = 1:size(elems,2)-5
    elemNode(:,i) = elems{5+i}(elemTet)-1;                                  
end
T = [elemID, elemNode, ones(numElem,1)*meshID]';                             % prepare for T.txt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create N and T files
% N file
if (exist('../N','dir') ~= 7)
    error('Please create the N folder in the main directory first!');
end
fileID = fopen(['../N/N_' num2str(meshID) '.txt'],'w');
fprintf(fileID, '%d %12.8f %12.8f %12.8f\n', N);
fclose(fileID);

% T file
if (exist('../T','dir') ~= 7)
    error('Please create the T folder in the main directory first!');
end
fileID = fopen(['../T/T_' num2str(meshID) '.txt'],'w');
fprintf(fileID, '%4d %5d %5d %5d %5d %2d\n', T);
fclose(fileID);