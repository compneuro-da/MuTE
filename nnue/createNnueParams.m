function [paramsUniTENearNeighbour] = createNnueParams(varargin)
% 
% Syntax:
% 
% [paramsBinTransferEntropy] = createBinTransferEntropyParams(numSeries)
% 
% Description:
% 
% every method has got its own parameters. Please set a structure as
% follows:
% 
% paramsMethodName                      = struct;
% 
% ******** NECESSARY FIELD ************
% 
% 1)
% 
% paramsMethodName.infoSeries           = for each series please set its
%                                         own: maximum model order 'p',
%                                         lag 'lag', delay 'del' and flag 
%                                         to use its present in a 
%                                         multivariate anlysis when the 
%                                         series is not a target or a 
%                                         driver, as in the following 
%                                         example
% 
%                 ---  --- --- --- ---
%                 |1 | |4 ||1 ||1 ||-1|
%                 |2 | |3 ||2 ||3 ||-1|
%                 |. | |. ||. ||. ||-1|
%                 |. | |. ||. ||. ||-1|
%                 |. | |. ||. ||. ||-1|
%                 |--| |--||--||--||-1|
%                  /\   /\  /\  /\  /\
%                  ||   ||  ||  ||  ||
%       Series Number   p  lag  del flag for the present influence
% 
% N.B. = if you want to use an estimator for your 'p', 'lag' and 'del'
% please specify a pointer to function that returns a matrix as the example
% above. For instance:
% 
% create the variables for generateVarTargetDriversFunc
% 
% paramsMethodName.varTargetDrivers      = @generateVarTargetDriversFunc(data, variables)
% 
% 2)
% 
% paramsMethodName.idTargets             = row vector contanining the
%                                          indeces of the series you want
%                                          to study as target series
% Example:
% 
% paramsMethodName.idTargets             = [1 3];
% 
% 3)
% 
% paramsMethodName.idDrivers             = matrix containing, in each 
%                                          column, the indeces of the 
%                                          series chosen as drivers for the
%                                          target in the corresponding
%                                          column
% Example 1:
% 
% paramsMethodName.idDrivers             = [2 3 4;1 2 3]'; in this way the
%                                          rows 2 3 4 are the drivers of
%                                          the target 1 and the rows 1 2 3
%                                          are the drivers of the target 3.
%                                          If you want to set a different
%                                          number of drivers per target,
%                                          please replace the driver id
%                                          with 0 entry
% Example 2:
% 
% paramsMethodName.idDrivers             = [2 3 4;1 2 0]'; in this way the
%                                          rows 2 3 4 are the drivers of
%                                          the target 1 and only the rows
%                                          1 2 are the drivers of the 
%                                          target 3.
% 
% Example 3:
% 
% paramsMethodName.idDrivers             = [2 2 4;1 1 0]'; in this way the
%                                          row 2 is considered with its
%                                          present
% 
% paramsMethodName.multi_bivAnalysis     = field to perform a multivariate
%                                          or bivariate analysis
% Example:
% 
% - multi_uniAnalysis     = 'biv';       in that case just idTargets and
%                                        idDrivers will be considered
% 
% - multi_uniAnalysis     = 'multiv';    in that case idTarget, idDrivers
%                                        and all the other variables will
%                                        be considered
% 
% **************************************
% paramsMethodName.nameField            = ...   ;

numSeries                                      = varargin{1,1};
paramsUniTENearNeighbour                       = struct;

paramsUniTENearNeighbour.idTargets             = varargin{1,2};
paramsUniTENearNeighbour.idDrivers             = varargin{1,3};
paramsUniTENearNeighbour.idOthersLagZero       = varargin{1,4};
paramsUniTENearNeighbour.modelOrder            = varargin{1,5};
paramsUniTENearNeighbour.infoSeries            = [(1:numSeries)' , ones(numSeries,1).*paramsUniTENearNeighbour.modelOrder , ones(numSeries,2)];
paramsUniTENearNeighbour.multi_bivAnalysis     = varargin{1,6};
paramsUniTENearNeighbour.firstTermCaseVect     = varargin{1,7};
paramsUniTENearNeighbour.numSurrogates         = varargin{1,8};
paramsUniTENearNeighbour.metric                = varargin{1,9};
paramsUniTENearNeighbour.numNearNei            = varargin{1,10};
paramsUniTENearNeighbour.funcDir               = varargin{1,11};
paramsUniTENearNeighbour.homeDir               = varargin{1,12};
paramsUniTENearNeighbour.alphaPercentile       = varargin{1,13};
paramsUniTENearNeighbour.tauMin                = varargin{1,14};
% ******** Set the following fields together *******
paramsUniTENearNeighbour.genCondTermFun        = varargin{1,15};
paramsUniTENearNeighbour.usePresent            = varargin{1,16};
% **************************************************

return;