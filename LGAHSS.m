function [Subset,time,examinedVec]= LGAHSS(Set,selNum,ref)
    tic
    num_vec = 100; 
    PopObj = Set;
    [a,M] = size(PopObj);          
    [W,num_vec] = UniformVector(num_vec, M);
    examinedVec = zeros(1,selNum);
    tensor = zeros(a,num_vec);
    r = ref*max(PopObj,[],1);
    for i=1:a
        s = PopObj(i,:);
        temp1 = min(abs(s-r)./W,[],2)';        
        tensor(i,:) = temp1;     
    end
    mintensor = tensor;
    
    selectedPop = zeros(selNum,M);
    selectedNum = 0;
    
    %% heap initialization       
    heap.index = 1:a;
    heap.hvc = (sum(mintensor,2));
    heap.size = a;
    heap.current = zeros(1,a);    
       
    si = heap.size;
    while(si >= 1)
        heap = heap_down_sink(si, heap);
        si = si - 1;
    end
    %% Select first solution
    top = heap.index(1);
    selectedNum = selectedNum+1;
    selectedPop(selectedNum,:) = PopObj(top, :);
    heap = min_heap_popup(heap);
    examinedVec(selectedNum) = 1;

    %% Select other solutions
    while selectedNum < selNum
        examined = 0;
        while true
            last_index = heap.index(1);
            top = last_index;          
            tempNum = selectedNum - heap.current(1);
            tensor = zeros(tempNum,num_vec);
            if tempNum ~= 0
               for i=1:tempNum
                    s = selectedPop(selectedNum+1-i,:);
                    temp1 = max((s-PopObj(top, :))./W,[],2)';        
                    tensor(end+1-i,:) = temp1;     
               end
                
               mintensor(top,:) = min([mintensor(top,:); tensor]);
               heap.hvc(1) = sum(mintensor(top,:));
               heap.current(1) = selectedNum;
               examined = examined+1;
            end
            
            heap = heap_down_sink(1, heap);
            if(heap.index(1) == last_index)                 
                selectedNum = selectedNum+1;
                selectedPop(selectedNum,:) = PopObj(last_index, :);
                heap = min_heap_popup(heap);
                examinedVec(selectedNum) = examined;
                break;  
            end
                
        end   
        
    end
    %% output 
    Subset = selectedPop;
    time = toc;
end
    

function heap = heap_down_sink(self, heap)
lchild =self*2;
rchild =self*2+1;
if(lchild <= heap.size && rchild <= heap.size)
    if(heap.hvc(self) < heap.hvc(lchild) || heap.hvc(self) < heap.hvc(rchild))
        if(heap.hvc(lchild) >= heap.hvc(rchild))
            
            heap = heap_swap_node(lchild,self,heap);
            heap = heap_down_sink(lchild, heap);
        else
            heap = heap_swap_node(rchild,self, heap);
            heap = heap_down_sink(rchild, heap);
        end
    end
elseif(lchild <= heap.size)
    if(heap.hvc(self) < heap.hvc(lchild))
        heap = heap_swap_node(lchild,self, heap);
    end
end
end

function heap = heap_swap_node(node1,node2, heap)
    t_index = heap.index(node1);
    t_hvc = heap.hvc(node1);
    t_current = heap.current(node1);
    
    heap.index(node1) = heap.index(node2);
    heap.hvc(node1) = heap.hvc(node2);
    heap.current(node1) = heap.current(node2);

    heap.index(node2) = t_index;
    heap.hvc(node2) = t_hvc;
    heap.current(node2) = t_current;    
end


function heap = min_heap_popup(heap)
heap = heap_swap_node(1,heap.size, heap);
heap.size =heap.size -1;
heap = heap_down_sink(1,heap);
end

