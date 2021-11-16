function [Subset,time] = GAHSS(objVal,selNum,r)
            tic
            num_vec = 100; 
            [solNum,M] = size(objVal);            
            [W,num_vec] = UniformVector(num_vec, M);
            tensor = zeros(solNum,num_vec);
            r = r*max(objVal,[],1);
            for i=1:solNum
                s = objVal(i,:);
                temp1 = min(abs(s-r)./W,[],2)';        
                tensor(i,:) = temp1;     
            end
            mintensor = tensor;
                                    
            selVal = zeros(selNum,M);
            for num = 1:selNum
                mintensor = min(mintensor, tensor);
                r2hvc = sum(mintensor.^M,2);
                [~,bestindex] = max(r2hvc);
                
                for i=1:solNum
                    s = objVal(i,:);
                    temp1 = max((objVal(bestindex,:)-s)./W,[],2)';        
                    tensor(i,:) = temp1;     
                end  
                selVal(num,:) = objVal(bestindex,:);
            end    
            Subset = selVal;
            time = toc;
end
