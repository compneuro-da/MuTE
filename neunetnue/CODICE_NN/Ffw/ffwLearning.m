function [ffwNet learnParams E_T RMSE_T E_V RMSE_V]=ffwLearning(ffwNet,learnParams,debug)
%function [ffwNet RSE_T RMSE_T RSE_V RMSE_V]=ffwLearning(ffwNet,learnParams,debug)
	if nargin<3
		if isfield (learnParams,'debug')
			debug = learnParams.debug;
		else
			debug = 0;
		end
	end

	maxEpochs=learnParams.maxEpochs;

	%% Learning loop
	E_T                         = zeros(1,maxEpochs);
	RMSE_T                      = zeros(1,maxEpochs);

	E_V                         = zeros(1,maxEpochs);
	RMSE_V                      = zeros(1,maxEpochs);

	learnParams.actFunctions    = ffwNet.actFunctions;
	learningAlgorithm           = learnParams.learningAlgorithm;
    if isfield (learnParams,'inputUpdate')
		inputUpdate = learnParams.inputUpdate;
	else
		inputUpdate = 0;
    end
	WLength=length(ffwNet.W);
	%BLength=length(ffwNet.B);

	if isfield(learnParams,'wLayersToBeUpdated')
		wLayersToBeUpdated=learnParams.wLayersToBeUpdated;
	else
		wLayersToBeUpdated=[1:WLength];
	end
	WLength=length(wLayersToBeUpdated);
    if learnParams.batch==1
		
      for i=1:maxEpochs
            if (inputUpdate==0)
                [gradW gradB]                       = computeGradient(ffwNet,learnParams,'compWeightGradient',1,'compInputGradient',0);
                [ffwNet learnParams]                = compWeightUpdate(ffwNet,learnParams,wLayersToBeUpdated,WLength,learningAlgorithm,gradW,gradB);
            elseif (weightAndBiasUpdate==0)
                derI                                = computeGradient(ffwNet,learnParams,'compWeightGradient',0,'compInputGradient',1);
                [learnParams newTrainSet]           = compInputUpdate(learnParams,learningAlgorithm,derI);
                learnParams.trainSet=newTrainSet;

            else
                [gradW gradB derI]                  = computeGradient(ffwNet,learnParams,'compWeightGradient',1,'compInputGradient',1);
                [ffwNet learnParams]                = compWeightUpdate(ffwNet,learnParams,wLayersToBeUpdated,WLength,learningAlgorithm,gradW,gradB);
                [learnParams  newTrainSet]          = compInputUpdate(learnParams,learningAlgorithm,derI);
                learnParams.trainSet=newTrainSet;
            end
 
            [E_T(i) RMSE_T(i) E_V(i) RMSE_V(i)]     = computePerformace(ffwNet,learnParams);    
      
        if (mod(i,debug) == 0)
          fprintf('Epochs %4d/%d | E_T: %20.20g | RMS_T: %20.20g | E_V: %6.3f | RMS_V: %6.3f\n',i,maxEpochs,E_T(i), RMSE_T(i), E_V(i), RMSE_V(i));
        end
      end
	else
		N=size(learnParams.trainSet,1);
		for i=1:maxEpochs
            if (inputUpdate==0)

                for n=1:N
                    [gradW gradB]           = computeGradient(ffwNet,learnParams,'pointIndexes',n, 'compWeightGradient',1,'compInputGradient',0);
                    [ffwNet learnParams]	= compWeightUpdate(ffwNet,learnParams,wLayersToBeUpdated,WLength,learningAlgorithm,gradW,gradB);
                end
            elseif (weightAndBiasUpdate==0)
                for n=1:N
                    derI                = computeGradient(ffwNet,learnParams,'pointIndexes',n,'compWeightGradient',0,'compInputGradient',1);
                    [learnParams newTrainSet]         = compInputUpdate(learnParams,learningAlgorithm,derI);
                    learnParams.trainSet(n,:)=newTrainSet;
                end
            else
                for n=1:N
                    [gradW gradB derI]                  = computeGradient(ffwNet,learnParams,'pointIndexes',n,'compWeightGradient',1,'compInputGradient',1);
                    [ffwNet learnParams]                = compWeightUpdate(ffwNet,learnParams,wLayersToBeUpdated,WLength,learningAlgorithm,gradW,gradB);    
                    [learnParams newTrainSet]           = compInputUpdate(learnParams,learningAlgorithm,derI);
                    learnParams.trainSet(n,:)=newTrainSet;
                end
            end
			[E_T(i) RMSE_T(i) E_V(i) RMSE_V(i)]       =  computePerformace(ffwNet,learnParams);
			if (mod(i,debug) == 0)
				fprintf('Epochs %4d | E_T: %6.10f | RMS_T: %6.3f | E_V: %6.3f | RMS_V: %6.3f\n',i,E_T(i), RMSE_T(i), E_V(i), RMSE_V(i));
			end
		end
    end
return;    
function [ffwNet learnParams]= compWeightUpdate(ffwNet,learnParams,wLayersToBeUpdated,WLength,learningAlgorithm,gradW,gradB)
%function [ffwNet learnParams]= compWeightUpdate

    W=[ffwNet.W(wLayersToBeUpdated) ffwNet.B(wLayersToBeUpdated)];
    gradW=gradW(wLayersToBeUpdated);
    gradB=gradB(wLayersToBeUpdated); 
            
    [W learnParams]     = learningAlgorithm(W, [gradW gradB],learnParams);
    ffwNet.W(wLayersToBeUpdated)=W(1,1:WLength);
    ffwNet.B(wLayersToBeUpdated)=W(1,WLength+1:end);
return;
function [learnParams newTrainSet]= compInputUpdate(learnParams,learningAlgorithm,derI)        
%function [learnParams newTrainSet]= compInputUpdate        

    [train learnParams]     = learningAlgorithm({learnParams.trainSet}, {derI},learnParams);
    newTrainSet=train{1};
return;

    

