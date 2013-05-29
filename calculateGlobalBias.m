function [ globalBias , cTypeGlobalBiases] = calculateGlobalBias( ratingsVector )

index = 0;

for i = 1 : length(ratingsVector)
    
    score = ratingsVector(i);
    
    if index == 0
        globalBias = score;
        
    else
        N = index;
        globalBias = globalBias * N/(N+1) + score / (N+1);
    end
    cTypeGlobalBiases(index+1) = globalBias;
    index = index +1;
    
end

end

