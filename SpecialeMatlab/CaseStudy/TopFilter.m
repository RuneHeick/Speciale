function [ FHHMsignal ] = TopFilter( FHHMsignal, minTopLength )
%TOPFILTER Summary of this function goes here
%   Detailed explanation goes here

    State_isTop = FHHMsignal(1) > 20;
    State_startI = 1; 

    for i = 2:length(FHHMsignal)

        State_sample_isTop  = FHHMsignal(i) > 20; 
        
        if State_isTop ~= State_sample_isTop
            l = i-State_startI;
            if(l < minTopLength)
                FHHMsignal(State_startI:i-1) = 0; 
            end
            State_isTop = State_sample_isTop; 
            State_startI = i; 
        end
    end

end

