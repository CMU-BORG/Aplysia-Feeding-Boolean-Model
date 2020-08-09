classdef AplysiaFeeding
    %%
    properties        
        %Timing variables
        TimeStep = 0.05;            %time step in seconds
        StartingTime = 0;           %simulation start time (in seconds)
        EndTime = 40;               %simulation end time (in seconds)
        
        %Maximum muscle forces
        max_I4 = 1.75;              %Maximum pressure grasper can exert on food
        max_I3ant = 0.6;            %Maximum I3 anterior force
        max_I3 = 1;                 %Maximum I3 force
        max_I2 = 1.5;               %Maximum I2 force
        max_hinge = 0.2;            %Maximum hinge force
        
        %Muscle time constants
        tau_I4 = 1.0/sqrt(2);              %time constant (in seconds) for I4 activation
        tau_I3anterior = 2.0/sqrt(2);      %time constant (in seconds) for I3anterior activation
        tau_I2_ingestion = 0.5*1/sqrt(2);  %time constant (in seconds) for I2 activation during ingestion
        tau_I2_egestion = 1.4*1/sqrt(2);   %time constant (in seconds) for I2 activation during egestion
        tau_I3 = 1.0/sqrt(2);              %time constant (in seconds) for I3 activation
        tau_hinge  = 1.0/sqrt(2);          %time constant (in seconds) for hinge activation
        
        %body time constants
        c_g = 1.0;                  %time constant (in seconds) for grapser motion
        c_h = 1.0;                  %time constant (in seconds) for body motion
        
        %Spring constants
        K_sp_h = 2.0;       %spring constant representing neck and body between head and ground
        K_sp_g = 0.1;       %spring constant representing attachment between buccal mass and head
        
        %Reference points for springs
        x_h_ref = 0.0;      %head spring reference position
        x_gh_ref = 0.4;     %grasper spring reference position
        
        %Friction coefficients
        mu_s_g = 0.4;               %mu_s coefficient of static friction at grasper
        mu_k_g = 0.3;               %mu_k coefficient of kinetic friction at grasper
        mu_s_h = 0.3;               %mu_s coefficient of static friction at jaws
        mu_k_h = 0.3;               %mu_k coefficient of kinetic friction at jaws
        
        %Sensory feedback thresholds (theshold_neuron name_behavior_type)
        thresh_B64_bite_protract = 0.89;
        thresh_B64_swallow_protract = 0.4;
        thresh_B64_reject_protract = 0.5;
        
        thresh_B4B5_protract = 0.7;
        
        thresh_B31_bite_off = 0.55;
        thresh_B31_swallow_off = 0.4;
        thresh_B31_reject_off = 0.6;
        thresh_B31_bite_on = 0.9;
        thresh_B31_swallow_on = 0.75;
        thresh_B31_reject_on = 0.89;
        
        thresh_B7_bite_protract = 0.9;
        thresh_B7_reject_protract = 0.7;
        
        thresh_B6B9B3_bite_pressure = 0.2;
        thresh_B6B9B3_swallow_pressure = 0.25;
        thresh_B6B9B3_reject_pressure = 0.75;
        
        thresh_B38_retract = 0.4;
        
        %neural state variables
        MCC
        CBI2
        CBI3
        CBI4
        B64
        B4B5
        B40B30
        B31B32
        B6B9B3
        B8
        B7
        B38
        B20
        
        %neural timing variables
        refractory_CBI3 = 5000;                 %refractory period (in milliseconds) of CBI3 post strong B4B5 excitation
        postActivityExcitation_B40B30 = 3000;   %time (in milliseconds) post B40B30 activity that slow excitation lasts
        
        %muscle state variables
        P_I4
        A_I4
        P_I3_anterior
        A_I3_anterior
        T_I3
        A_I3
        T_I2
        A_I2
        T_hinge
        A_hinge
        
        %body state variables
        x_h
        x_g
        grasper_friction_state      %0 = kinetic friction, 1 = static friction
        jaw_friction_state          %0 = kinetic friction, 1 = static friction
        
        
        %environment variables
        seaweed_strength = 10;
        fixation_type = 1;          %default initialization is seaweed fixed to the force transducer (use for swallowing)
        force_on_object
        
        %sensory state vectors
        sens_chemical_lips
        sens_mechanical_lips
        sens_mechanical_grasper
        
        %switches
        use_hypothesized_connections = 0; %1 = yes, 0 = no
        
        %stimulation electrodes
        stim_B4B5 %0 = off, 1 = on
        stim_CBI2 %0 = off, 1 = on
        
    end
    %%
    methods
        %%
        function obj = AplysiaFeeding()
            %% Preallocate arrays
            t=obj.StartingTime:obj.TimeStep:obj.EndTime;
            nt=length(t); % number of time points

            %neural state variables
            obj.MCC = zeros(1,nt);
            obj.CBI2 = zeros(1,nt);
            obj.CBI3 = zeros(1,nt);
            obj.CBI4 = zeros(1,nt);
            obj.B64 = zeros(1,nt);
            obj.B4B5 = zeros(1,nt);
            obj.B40B30 = zeros(1,nt);
            obj.B31B32 = zeros(1,nt);
            obj.B6B9B3 = zeros(1,nt);
            obj.B8 = zeros(1,nt);
            obj.B7 = zeros(1,nt);
            obj.B38 = zeros(1,nt);
            obj.B20 = zeros(1,nt);

            %muscle state variables
            obj.P_I4 = zeros(1,nt);
            obj.A_I4 = zeros(1,nt);
            obj.P_I3_anterior = zeros(1,nt);
            obj.A_I3_anterior = zeros(1,nt);
            obj.T_I3 = zeros(1,nt);
            obj.A_I3 = zeros(1,nt);
            obj.T_I2 = zeros(1,nt);
            obj.A_I2 = zeros(1,nt);
            obj.T_hinge = zeros(1,nt);
            obj.A_hinge = zeros(1,nt);

            %body state variables
            obj.x_h = zeros(1,nt);
            obj.x_g = zeros(1,nt);
            obj.grasper_friction_state = zeros(1,nt);
            obj.jaw_friction_state = zeros(1,nt);

            %environment variables
            obj.force_on_object = zeros(1,nt);
            
            
            %Specify initial conditions
            obj.MCC(1) = 1;
            obj.CBI2(1) = 1;
            obj.CBI3(1) = 0;
            obj.CBI4(1) = 0;
            obj.B64(1) = 0;
            obj.B4B5(1) = 0;
            obj.B40B30(1) = 0;
            obj.B31B32(1) = 1;
            obj.B6B9B3(1) = 0;
            obj.B8(1) = 0;
            obj.B7(1) = 0;
            obj.B38(1) = 1;
            obj.B20(1) = 0;
            
            obj.P_I4(1) = 0;
            obj.A_I4(1) = 0.05;
            obj.P_I3_anterior(1) = 0;
            obj.A_I3_anterior(1) = 0.05;
            obj.T_I3(1) = 0.05;
            obj.A_I3(1) = 0.05;
            obj.T_I2(1) = 0.05;
            obj.A_I2(1) = 0.05;
            obj.T_hinge(1) = 0;
            obj.A_hinge(1) = 0.05;
            
            
            obj.x_h(1) = 0;
            obj.x_g(1) = 0.1;
            obj.grasper_friction_state(1) = 0;
            obj.jaw_friction_state(1) = 0;
            obj.force_on_object(1) = 0;
            
            %initialize electrodes to zero
            obj.stim_B4B5(1:nt) = zeros(1,nt);
            obj.stim_CBI2(1:nt) = zeros(1,nt);
            
        end
        %%
        function obj = runSimulation(obj)
            t=obj.StartingTime:obj.TimeStep:obj.EndTime;
            nt=length(t); % number of time points

            %% Initialize internal tracking variables
            CBI3_stimON = 0;
            CBI3_stimOFF = 0;
            CBI3_refractory = 0;
            B40B30_offTime = 0;
            unbroken = 1; %tracking variable to keep track of seaweed being broken off during feeding

            %% Main Loop

            for j=1:(nt-1)
                
                x_gh = obj.x_g(j)-obj.x_h(j);
                
                %% Update Metacerebral cell: 
                % assume here feeding arousal continues
                % indefinitely, once started. 
                %{
                MCC is active IF
                    General Food arousal is on
                %}

                obj.MCC(j+1)=obj.MCC(j);

                %% Update CBI-2
                %{
                CBI2 is active IF
                    MCC is on 
                    AND (
                        (Mechanical Stimulation at Lips AND Chemical Stimulation at Lips AND No mechanical stimuli in grasper)
                        OR 
                        (Mechanical in grasper and no Chemical Stimulation at Lips)
                        OR
                        (B4/B5 is firing strongly (>=2)))
                %}

                %CBI2 - updated 6/7/2020
                %with hypothesized connections from B4/B5
                if (obj.use_hypothesized_connections ==1)
                     obj.CBI2(j+1) = (obj.stim_CBI2(j)==0)*... if electrode above CBI-2 is off, do this:
                         obj.MCC(j)*(~obj.B64(j))*((obj.sens_mechanical_lips(j) && obj.sens_chemical_lips(j) &&(~obj.sens_mechanical_grasper(j)))||(obj.sens_mechanical_grasper(j) &&(~obj.sens_chemical_lips(j)))||(obj.B4B5(j)>=2))+...
                         (obj.stim_CBI2(j)==1);
                else
                %without hypothesized connections from B4/B5
                    obj.CBI2(j+1) = (obj.stim_CBI2(j)==0)*... if electrode above CBI-2 is off, do this:
                        obj.MCC(j)*(~obj.B64(j))*((obj.sens_mechanical_lips(j) && obj.sens_chemical_lips(j) &&(~obj.sens_mechanical_grasper(j)))||(obj.sens_mechanical_grasper(j)&&(~obj.sens_chemical_lips(j))))+...
                        (obj.stim_CBI2(j)==1);
                end

                %% Update CBI-3
                % requires stimuli_mech_last AND stimuli_chem_last
                %{
                CBI3 is active IF
                    MCC is on
                    AND
                    Mechanical Simulation at Lips
                    AND
                    Chemical Stimulation at Lips
                    AND
                    B4/B5 is NOT firing strongly
                    AND
                    CBI3 is NOT in a refractory period
                %}

                %CBI3 can experieince a refractory period following strong inhibition from B4/B5
                %check if a refractory period is occuring

            %modified to only turn on refreactory after the strong stimulation
                if((obj.B4B5(j)>=2) && (CBI3_stimON==0))
                   CBI3_stimON = j;   
                   %CBI3_refractory = 1;
                end
                if ((CBI3_stimON ~=0) && (obj.B4B5(j)<2))
                   CBI3_refractory = 1;
                   CBI3_stimOFF = j;  
                   CBI3_stimON = 0;    
                end 

                if(CBI3_refractory && j<(CBI3_stimOFF+obj.refractory_CBI3/1000/obj.TimeStep))
                   CBI3_refractory = 1; 
                else
                    CBI3_stimOFF = 0;
                    CBI3_refractory = 0; 
                end


                %CBI3 - updated 6/7/2020    
                %with hypothesized connections from B4/B5    
                if (obj.use_hypothesized_connections ==1)
                    obj.CBI3(j+1) = obj.MCC(j)*(obj.sens_mechanical_lips(j)*obj.sens_chemical_lips(j))*((obj.B4B5(j)<2))*(~CBI3_refractory);   
                else
                %without hypothesized connections from B4/B5  
                    obj.CBI3(j+1) = obj.MCC(j)*(obj.sens_mechanical_lips(j)*obj.sens_chemical_lips(j)); 
                end



                %% Update CBI4 - added 2/27/2020
                %{
                CBI4 is active IF – mediates swallowing and rejection
                    MCC is on
                    AND
                        (Mechanical Stimulation at Lips
                        OR
                        Chemical Stimulation at Lips)
                    AND
                    Mechanical Stimulation in grasper
                %}
                obj.CBI4(j+1) = obj.MCC(j)*(obj.sens_mechanical_lips(j) || obj.sens_chemical_lips(j))*obj.sens_mechanical_grasper(j);

                %% Update B64
                % list of inputs
                % Protraction threshold excites
                % grasper pressure excites - still figuring out how to implement
                % retraction threshold inhibits
                % B31/32 inhibits

                %If there is mechanical and chemical stimuli at the lips and there is
                %seaweed in the grasper -> swallow

                %If there is mechanical and chemical stimuli at the lips and there is
                %NOT seaweed in the grasper -> bite

                %If there is not chemical stimuli at the lips but there is mechanical
                %stimuli ->reject

                %{
                B64 is active IF
                    MCC is on
                    AND
                    IF CBI3 is active (ingestion)
                        IF mechanical stimulation is in grasper (swallowing)
                            Relative Grasper Position is Greater than B64 Swallowing Protraction threshold
                        IF mechanical stimulation is NOT in grasper (biting)
                            Relative Grasper Position is Greater than B64 Biting Protraction threshold
                    IF CBI3 is NOT active (rejection)
                        Relative Grasper Position is Greater than B64 Rejection Protraction threshold
                    AND
                    B31/B32 is NOT active
                    AND
                    IF CBI3 is active (ingestion)
                        IF mechanical stimulation is in grasper (swallowing)
                            NOT (Relative Grasper Position is less than B64 Swallow Retraction threshold)
                        IF mechanical stimulation is NOT in grasper (biting)
                            NOT(Relative Grasper Position is less than B64 Biting Retraction threshold)
                    IF CBI3 is NOT active (rejection)
                        NOT(Relative Grasper Position is less than B64 Rejection Retraction threshold)
                %}

                B64_proprioception = (obj.CBI3(j)*(... % checks protraction threshold - original 0.5
                                                (  obj.sens_mechanical_grasper(j) *(x_gh>obj.thresh_B64_swallow_protract))||...
                                                ((~obj.sens_mechanical_grasper(j))*(x_gh>obj.thresh_B64_bite_protract))))...
                                            ||...
                                                ((~obj.CBI3(j))                   *(x_gh>obj.thresh_B64_reject_protract));

                %B64
                obj.B64(j+1)=obj.MCC(j)*(~obj.B31B32(j))*... % update B64
                    B64_proprioception;

                %% Update B4/B5: 
                %{
                B4/B5 is active IF
                    MCC is ON
                    AND
                    IF stimulating electrode is off
                        Strongly firing IF CBI3 is NOT active (rejection)
                            AND
                            B64 is active (retraction)
                            AND
                            Relative grasper position is greater than B4/B5 threshold (early retraction)
                        weakly firing IF CBI3 is active (ingestion)
                            AND
                            B64 is active (retraction)
                            AND
                            mechanical stimulation is in grasper (swallowing)
                    If stimulating electrode is on
                        Activity is set to 2 to designate strong firing
                %}

                %B4B5
                obj.B4B5(j+1)=obj.MCC(j)*...
                            ((~obj.stim_B4B5(j))*... % when B4/B5 electrode is off
                                (2*(~obj.CBI3(j))*...% if egestion
                                    obj.B64(j)*(x_gh>obj.thresh_B4B5_protract)) +... 
                                ((obj.CBI3(j))*(obj.sens_mechanical_grasper(j))*obj.B64(j)))... % if swallowing
                    +2*obj.stim_B4B5(j); % when B4/B5 electrode is on (and +1) then turn B4/B5 on to "emergency" mode

                %% Update B20 - updated 2/27/2020
                % Not active if CB1-3 is on (strongly inhibited)
                %excited by CBI2 but excitation is weaker than inhibition from CBI3
                %{
                (CBI2 is active
                    OR	
                    CBI4 is active
                    OR
                    B63 (B31/32) is active)
                        AND
                        CBI3 is NOT active
                        AND
                        B64 is NOT active

                %}
                obj.B20(j+1) = obj.MCC(j)*((obj.CBI2(j) || obj.CBI4(j)) || obj.B31B32(j))*(~obj.CBI3(j))*(~obj.B64(j));

               %% Update B40/B30
                %{
                B40/B30 is active IF
                    MCC is ON
                    AND
                    (CBI2 is active
                    OR 
                    CBI4 is active
                    OR 
                    B63 (B31/32) is active)
                    AND 
                    B64 is not active
                %}

                % B30/B40 have a fast inhibitory and slow excitatory connection with
                % B8a/b. To accomodate this, we track when B30/B40 goes from a active
                % state to a quiescent state 

                obj.B40B30(j+1) = obj.MCC(j)*((obj.CBI2(j) || obj.CBI4(j)) || obj.B31B32(j))*(~obj.B64(j));

                %check if B30/B40 has gone from active to quiescent
                if((obj.B40B30(j) ==1) && (obj.B40B30(j+1)==0))
                   B40B30_offTime = j;
                end

                %% Update B31/B32: -updated 2/27/2020
                % activated if grasper retracted enough, inhibited if
                % pressure exceeds a threshold or grasper is protracted far enough
                %{
                B31/B32 is active IF
                    MCC is ON
                    AND
                    IF CBI3 is active (ingestion)
                        B64 is NOT active (protraction)
                        AND
                            Graper pressure is less than half of its maximum (open)
                            OR
                            CBI2 is active (biting)
                        AND
                        IF B31/B32 is NOT firing (switching to protraction)
                            The relative grasper position is less than the retraction threshold
                        IF B31/B32 is firing (protraction)
                            The relative grasper position is less than the protraction threshold
                    IF CBI3 is NOT active (rejection)
                        B64 is NOT active (protraction)
                        AND
                        Grasper Pressure is greater than a quarter of the maximum (closing or closed)
                        AND
                            CBI2 is active
                            OR
                            CBI4 is active
                        AND
                        IF B31/B32 is NOT firing (switching to protraction)
                            The relative grasper position is less than the retraction threshold
                        IF B31/B32 is firing (protraction)
                            The relative grasper position is less than the protraction threshold
                %}

                %B31/B32s thresholds may vary for different behaviors. These are set
                %here
                if (obj.sens_mechanical_grasper(j) && obj.CBI3(j)) %swallowing
                    on_thresh = obj.thresh_B31_swallow_on;
                    off_thresh = obj.thresh_B31_swallow_off;
                elseif (obj.sens_mechanical_grasper(j) && (~obj.CBI3(j))) %rejection
                    on_thresh = obj.thresh_B31_reject_on;
                    off_thresh = obj.thresh_B31_reject_off;
                else %biting
                    on_thresh = obj.thresh_B31_bite_on;
                    off_thresh = obj.thresh_B31_bite_off;        
                end

                obj.B31B32(j+1)=obj.MCC(j)*(...
                    obj.CBI3(j)*... %if ingestion
                        ((~obj.B64(j))*((obj.P_I4(j)<(1/2))||obj.CBI2(j))*... 
                            ((~obj.B31B32(j))*(x_gh<off_thresh)+...
                               obj.B31B32(j) *(x_gh<on_thresh)))+...
                  (~obj.CBI3(j))*... %if egestion
                        ((~obj.B64(j))*(obj.P_I4(j)>(1/4))*(obj.CBI2(j)||obj.CBI4(j))*...
                            ((~obj.B31B32(j))*(x_gh<off_thresh)+...
                               obj.B31B32(j) *(x_gh<on_thresh))));

                %% Update B6/B9/B3: 
                % activate once pressure is high enough in ingestion, or low enough in
                % rejection
                %{
                NEW VERSION:
                B6/B9/B3 is active IF
                    MCC is active
                    AND
                    B4/B5 is NOT firing strongly
                    AND
                    IF CBI3 is active (ingestion)
                        B64 is active (retraction)
                        AND
                        Grasper pressure is greater than B6/B3/B9 pressure threshold (closed)
                    IF CBI3 is not active (rejection)
                        B64 is active (retraction)
                        AND
                        Grasper pressure is less than B6/B3/B9 pressure threshold (open)
                %}
                %{
                B6/B9/B3 is active IF
                    MCC is active
                    AND
                    B64 is active (retraction)
                    AND
                    B4/B5 is NOT firing strongly
                    AND (
                    (CBI3 is active (ingestion)
                     AND
                     There is NOT mechanical stimulation in mouth (biting)
                     AND
                     Grasper pressure is greater than B6/B3/B9 biting pressure
                     threshold (closed))
                    OR
                    (CBI3 is active (ingestion)
                     AND
                     There is mechanical stimulation in mouth (swallowing)
                     AND
                     Grasper pressure is greater than B6/B3/B9 swallowing pressure
                     threshold (closed))
                    OR
                    (CBI3 is NOT active (rejection)
                     AND
                     Grasper pressure is NOT greater than B6/B3/B9 rejection pressure
                     threshold (open))
                    )
                %}

                %B6/B9/B3
                obj.B6B9B3(j+1)= obj.MCC(j)*obj.B64(j)*(~(obj.B4B5(j)>=2))*(...
                                (obj.CBI3(j) && ~obj.sens_mechanical_grasper(j))*... biting
                                    (obj.P_I4(j)>obj.thresh_B6B9B3_bite_pressure)...
                                +...
                                (obj.CBI3(j) && obj.sens_mechanical_grasper(j))*... swallowing
                                    (obj.P_I4(j)>obj.thresh_B6B9B3_swallow_pressure)...
                                +...
                                (~obj.CBI3(j))*... rejection
                                    (~(obj.P_I4(j)>obj.thresh_B6B9B3_reject_pressure)));


                %% Update B8a/b
                % active if excitation from B6/B9/B3 plus protracted
                % sensory feedback exceeds threshold of 1.9, and not inhibited by
                % either B31/B32 or by sensory feedback from being retracted. If B4/B5 is
                % highly excited (activation level is 2 instead of just 1) then shut
                % down B8a/b.
                %{
                B8a/b is active IF
                    MCC is on
                    AND
                        B64 is active
                        OR
                        B40/B30 is NOT active
                        OR
                        B20 is active
                    AND
                    B4/B5 is not active
                    AND
                        B20 is active
                        OR
                        B31/B32 is NOT active
                %}

                %B8a/b recieves slow exitatory input from B30/B40 functionally this
                %causes strong firing immediatly following B30/B40 cessation in biting
                %and swallowing
                if(obj.B40B30(j)==0 && j<(B40B30_offTime+obj.postActivityExcitation_B40B30/1000/obj.TimeStep))
                    B40B30_excite = 1; 
                else
                    B40B30_excite = 0; 
                end

                %B8a/b - updated 5/25/2020   
                obj.B8(j+1) = obj.MCC(j)*(~(obj.B4B5(j)>=2))*(...%B4/5 inhibits when strongly active
                            obj.CBI3(j)*(... % if ingestion
                                obj.B20(j) || (B40B30_excite)*(~obj.B31B32(j)))+...
                            (~obj.CBI3(j))*(... % if rejection
                                obj.B20(j))); 

                %% Update B7 - ONLY ACTIVE DURING EGESTION and BITING
                % turn on as you get to peak protraction
                %in biting this has a threshold that it stops applying effective force -
                %biomechanics
                %{
                B7 is active IF
                    ((CBI3 is NOT active (rejection)
                    OR
                    There is mechanical stimulation in mouth
                    AND
                        (The relative position of the grasper is greater than the rejection protraction threshold
                        OR
                        Grasper pressure is very high) (closed))
                    OR
                    (CBI3 is active
                    AND
                    There is NOT mechanical stimulation in mouth (biting)
                    AND
                        (The relative position of the grasper is greater than the bite protraction threshold
                        OR
                        Grasper pressure is very high) (closed))
                %}
                obj.B7(j+1) = obj.MCC(j)*( ...
                                  (((~obj.CBI3(j)) ||  (obj.sens_mechanical_grasper(j)))*((x_gh>=obj.thresh_B7_reject_protract)||(obj.P_I4(j)>(.97)))) + ...
                                  (  (obj.CBI3(j)  && (~obj.sens_mechanical_grasper(j)))*((x_gh>=obj.thresh_B7_bite_protract)  ||(obj.P_I4(j)>(.97)))) ...
                                  );

                %% Update B38: 
                % If already active, remain active until protracted past
                % 0.5.  If inactive, become active if retracted to 0.1 or further. 
                %{
                B38 is active IF
                    MCC is ON
                    AND
                    mechanical stimulation in the grasper (swallowing or rejection)
                    AND
                    IF CBI3 is active (ingestion)
                        Relative grasper position is less than B38 ingestion threshold
                    IF CBI3 is not active (rejection)
                        Turn off B38
                %}

                %B38

                obj.B38(j+1)=obj.MCC(j)*(obj.sens_mechanical_grasper(j))*(...
                    (obj.CBI3(j))*(... % if CBI3 active do the following:
                        ((x_gh)<obj.thresh_B38_retract)));

                %% Update I4: If food present, and grasper closed, then approaches
                % pmax pressure as dp/dt=(B8*pmax-p)/tau_p.  Use a quasi-backward-Euler
                obj.P_I4(j+1)=((obj.tau_I4*obj.P_I4(j)+obj.A_I4(j)*obj.TimeStep)/(obj.tau_I4+obj.TimeStep));%old -- keep this version
                obj.A_I4(j+1)=((obj.tau_I4*obj.A_I4(j)+obj.B8(j)*obj.TimeStep)/(obj.tau_I4+obj.TimeStep));

                %% Update pinch force: If food present, and grasper closed, then approaches
                % pmax pressure as dp/dt=(B8*pmax-p)/tau_p.  Use a quasi-backward-Euler
                obj.P_I3_anterior(j+1)=(obj.tau_I3anterior*obj.P_I3_anterior(j)+obj.A_I3_anterior(j)*obj.TimeStep)/(obj.tau_I3anterior+obj.TimeStep);
                obj.A_I3_anterior(j+1)=(obj.tau_I3anterior*obj.A_I3_anterior(j)+(obj.B38(j)+obj.B6B9B3(j))*obj.TimeStep)/(obj.tau_I3anterior+obj.TimeStep);

                %% Update I3 (retractor) activation: dm/dt=(B6-m)/tau_m
                obj.T_I3(j+1)=(obj.tau_I3*obj.T_I3(j)+obj.TimeStep*obj.A_I3(j))/(obj.tau_I3+obj.TimeStep);
                obj.A_I3(j+1)=(obj.tau_I3*obj.A_I3(j)+obj.TimeStep*obj.B6B9B3(j))/(obj.tau_I3+obj.TimeStep);

                %% Update I2 (protractor) activation: dm/dt=(B31-m)/tau_m.  quasi-B-Eul.
                obj.T_I2(j+1)=((obj.tau_I2_ingestion*obj.CBI3(j)+obj.tau_I2_egestion*(1-obj.CBI3(j)))*obj.T_I2(j)+obj.TimeStep*obj.A_I2(j))/((obj.tau_I2_ingestion*obj.CBI3(j)+obj.tau_I2_egestion*(1-obj.CBI3(j)))+obj.TimeStep);
                obj.A_I2(j+1)=((obj.tau_I2_ingestion*obj.CBI3(j)+obj.tau_I2_egestion*(1-obj.CBI3(j)))*obj.A_I2(j)+obj.TimeStep*obj.B31B32(j))/((obj.tau_I2_ingestion*obj.CBI3(j)+obj.tau_I2_egestion*(1-obj.CBI3(j)))+obj.TimeStep);

                %% Update Hinge activation: dm/dt=(B7-m)/tau_m.  quasi-B-Eul.
                %bvec(12,j+1)=(tau_m*hinge_last+dt*B7_last)/(tau_m+dt);%old
                obj.T_hinge(j+1)=(obj.tau_hinge*obj.T_hinge(j)+obj.TimeStep*obj.A_hinge(j))/(obj.tau_hinge+obj.TimeStep);%new
                obj.A_hinge(j+1)=(obj.tau_hinge*obj.A_hinge(j)+obj.TimeStep*obj.B7(j))/(obj.tau_hinge+obj.TimeStep);

            %% Biomechanics

            %% Grasper Forces
            %all forces in form F = Ax+b
                F_I2 = obj.max_I2*obj.T_I2(j)*[1,-1]*[obj.x_h(j);obj.x_g(j)] + obj.max_I2*obj.T_I2(j)*1; %FI2 = FI2_max*T_I2*(1-(xg-xh))
                F_I3 = obj.max_I3*obj.T_I3(j)*[-1,1]*[obj.x_h(j);obj.x_g(j)]-obj.max_I3*obj.T_I3(j)*0; %FI3 = FI3_max*T_I3*((xg-xh)-0)
                F_hinge = (x_gh>0.5)*obj.max_hinge*obj.T_hinge(j)*[-1,1]*[obj.x_h(j);obj.x_g(j)]-(x_gh>0.5)*obj.max_hinge*obj.T_hinge(j)*0.5; %F_hinge = [hinge stretched]*F_hinge_Max*T_hinge*((xg-xh)-0.5)
                F_sp_g = obj.K_sp_g*[1,-1]*[obj.x_h(j);obj.x_g(j)]+obj.K_sp_g*obj.x_gh_ref; %F_sp,g = K_g((xghref-(xg-xh))

                F_I4 = obj.max_I4*obj.P_I4(j);
                F_I3_ant = obj.max_I3ant*obj.P_I3_anterior(j)*[1,-1]*[obj.x_h(j);obj.x_g(j)]+obj.max_I3ant*obj.P_I3_anterior(j)*1;%: pinch force

                %calculate F_f for grasper
                if(obj.fixation_type(j) == 0) %object is not fixed to a contrained surface
                    %F_g = F_I2+F_sp_g-F_I3-F_hinge; %if the object is unconstrained it does not apply a resistive force back on the grasper. Therefore the force is just due to the muscles

                    A2 = 1/obj.c_g*(obj.max_I2*obj.T_I2(j)*[1,-1]+obj.K_sp_g*[1,-1]-obj.max_I3*obj.T_I3(j)*[-1,1]-obj.max_hinge*obj.T_hinge(j)*(x_gh>0.5)*[-1,1]);
                    B2 = 1/obj.c_g*(obj.max_I2*obj.T_I2(j)*1+obj.K_sp_g*obj.x_gh_ref+obj.max_I3*obj.T_I3(j)*0+(x_gh>0.5)*obj.max_hinge*obj.T_hinge(j)*0.5);

                    A21 = A2(1);
                    A22 = A2(2);

                    %the force on the object is approximated based on the friction
                    if(abs(F_I2+F_sp_g-F_I3-F_hinge) <= abs(obj.mu_s_g*F_I4)) % static friction is true
                        %disp('static')
                        F_f_g = -obj.sens_mechanical_grasper(j)*(F_I2+F_sp_g-F_I3-F_hinge);
                        obj.grasper_friction_state(j+1) = 1;
                    else
                        %disp('kinetic')
                        F_f_g = obj.sens_mechanical_grasper(j)*obj.mu_k_g*F_I4;
                        %specify sign of friction force
                        F_f_g = -(F_I2+F_sp_g-F_I3-F_hinge)/abs(F_I2+F_sp_g-F_I3-F_hinge)*F_f_g;
                        obj.grasper_friction_state(j+1) = 0;
                    end

                elseif (obj.fixation_type(j) == 1) %object is fixed to a contrained surface
                    if unbroken
                        if(abs(F_I2+F_sp_g-F_I3-F_hinge) <= abs(obj.mu_s_g*F_I4)) % static friction is true
                            %disp('static')
                            F_f_g = -obj.sens_mechanical_grasper(j)*(F_I2+F_sp_g-F_I3-F_hinge);
                            %F_g = F_I2+F_sp_g-F_I3-F_hinge + F_f_g;
                            obj.grasper_friction_state(j+1) = 1;

                            %identify matrix components for semi-implicit integration
                            A21 = 0;
                            A22 = 0;
                            B2 = 0;
                            
                        else
                            %disp('kinetic')
                            F_f_g = -sign(F_I2+F_sp_g-F_I3-F_hinge)*obj.sens_mechanical_grasper(j)*obj.mu_k_g*F_I4;
                            %specify sign of friction force
                            %F_g = F_I2+F_sp_g-F_I3-F_hinge + F_f_g;
                            obj.grasper_friction_state(j+1) = 0;


                            %identify matrix components for semi-implicit integration
                            A2 = 1/obj.c_g*(obj.max_I2*obj.T_I2(j)*[1,-1]+obj.K_sp_g*[1,-1]-obj.max_I3*obj.T_I3(j)*[-1,1]-obj.max_hinge*obj.T_hinge(j)*(x_gh>0.5)*[-1,1]);
                            B2 = 1/obj.c_g*(obj.max_I2*obj.T_I2(j)*1+obj.K_sp_g*obj.x_gh_ref+obj.max_I3*obj.T_I3(j)*0+(x_gh>0.5)*obj.max_hinge*obj.T_hinge(j)*0.5+F_f_g);

                            A21 = A2(1);
                            A22 = A2(2);
                            
                        end
                    else
                        %F_g = F_I2+F_sp_g-F_I3-F_hinge; %if the object is unconstrained it does not apply a resistive force back on the grasper. Therefore the force is just due to the muscles

                        A2 = 1/obj.c_g*(obj.max_I2*obj.T_I2(j)*[1,-1]+obj.K_sp_g*[1,-1]-obj.max_I3*obj.T_I3(j)*[-1,1]-obj.max_hinge*obj.T_hinge(j)*(x_gh>0.5)*[-1,1]);
                        B2 = 1/obj.c_g*(obj.max_I2*obj.T_I2(j)*1+obj.K_sp_g*obj.x_gh_ref+obj.max_I3*obj.T_I3(j)*0+(x_gh>0.5)*obj.max_hinge*obj.T_hinge(j)*0.5);

                        A21 = A2(1);
                        A22 = A2(2);

                        %the force on the object is approximated based on the friction
                        if(abs(F_I2+F_sp_g-F_I3-F_hinge) <= abs(obj.mu_s_g*F_I4)) % static friction is true
                            %disp('static')
                            F_f_g = -obj.sens_mechanical_grasper(j)*(F_I2+F_sp_g-F_I3-F_hinge);
                            obj.grasper_friction_state(j+1) = 1;
                        else
                            %disp('kinetic')
                            F_f_g = obj.sens_mechanical_grasper(j)*obj.mu_k_g*F_I4;
                            %specify sign of friction force
                            F_f_g = -(F_I2+F_sp_g-F_I3-F_hinge)/abs(F_I2+F_sp_g-F_I3-F_hinge)*F_f_g;
                            obj.grasper_friction_state(j+1) = 0;
                        end
                    end
                end
                %[j*dt position_grasper_relative I2 F_sp I3 hinge GrapserPressure_last F_g]

            %% Body Forces
            %all forces in the form F = Ax+b
                F_sp_h = obj.K_sp_h*[-1,0]*[obj.x_h(j);obj.x_g(j)]+obj.x_h_ref*obj.K_sp_h;
                %all muscle forces are equal and opposite
                if(obj.fixation_type(j) == 0)     %object is not constrained
                    %F_h = F_sp_h; %If the object is unconstrained it does not apply a force back on the head. Therefore the force is just due to the head spring.

                    A1 = 1/obj.c_h*obj.K_sp_h*[-1,0];
                    B1 = 1/obj.c_h*obj.x_h_ref*obj.K_sp_h;

                    A11 = A1(1);
                    A12 = A1(2);

                    if(abs(F_sp_h+F_f_g) <= abs(obj.mu_s_h*F_I3_ant)) % static friction is true
                        %disp('static2')
                        F_f_h = -obj.sens_mechanical_grasper(j)*(F_sp_h+F_f_g); %only calculate the force if an object is actually present
                        obj.jaw_friction_state(j+1) = 1;
                    else
                        %disp('kinetic2')
                        F_f_h = -sign(F_sp_h+F_f_g)*obj.sens_mechanical_grasper(j)*obj.mu_k_h*F_I3_ant; %only calculate the force if an object is actually present
                        obj.jaw_friction_state(j+1) = 0;
                    end
                elseif (obj.fixation_type(j) == 1)
                    %calcuate friction due to jaws
                    if unbroken %if the seaweed is intact
                        if(abs(F_sp_h+F_f_g) <= abs(obj.mu_s_h*F_I3_ant)) % static friction is true
                            %disp('static2')
                            F_f_h = -obj.sens_mechanical_grasper(j)*(F_sp_h+F_f_g); %only calculate the force if an object is actually present
                            %F_h = F_sp_h+F_f_g + F_f_h;
                            obj.jaw_friction_state(j+1) = 1;

                            A11 = 0;
                            A12 = 0;
                            B1 = 0;

                        else
                            %disp('kinetic2')
                            F_f_h = -sign(F_sp_h+F_f_g)*obj.sens_mechanical_grasper(j)*obj.mu_k_h*F_I3_ant; %only calculate the force if an object is actually present
                            %F_h = F_sp_h+F_f_g + F_f_h;

                            obj.jaw_friction_state(j+1) = 0;

                            if (obj.grasper_friction_state(j+1) == 1) %object is fixed and grasper is static  
                            % F_f_g = -mechanical_in_grasper*(F_I2+F_sp_g-F_I3-F_Hi);
                                A1 = 1/obj.c_h*(obj.K_sp_h*[-1,0]+(-obj.sens_mechanical_grasper(j)*(obj.max_I2*obj.T_I2(j)*[1,-1]+obj.K_sp_g*[1,-1]-obj.max_I3*obj.T_I3(j)*[-1,1]-obj.max_hinge*obj.T_hinge(j)*(x_gh>0.5)*[-1,1]))...
                                    -sign(F_sp_h+F_f_g)*obj.sens_mechanical_grasper(j)*obj.mu_k_h*obj.max_I3ant*obj.P_I3_anterior(j)*[1,-1]);
                                B1 = 1/obj.c_h*(obj.x_h_ref*obj.K_sp_h+(-obj.sens_mechanical_grasper(j)*(obj.max_I2*obj.T_I2(j)*1+obj.K_sp_g*obj.x_gh_ref+obj.max_I3*obj.T_I3(j)*0+(x_gh>0.5)*obj.max_hinge*obj.T_hinge(j)*0.5))...
                                    -sign(F_sp_h+F_f_g)*obj.sens_mechanical_grasper(j)*obj.mu_k_h*obj.max_I3ant*obj.P_I3_anterior(j)*1);

                            else %both are kinetic
                            %F_f_g = -sign(F_I2+F_sp_g-F_I3-F_Hi)*mechanical_in_grasper*mu_k_g*F_I4;
                                A1 = 1/obj.c_h*(obj.K_sp_h*[-1,0]-sign(F_sp_h+F_f_g)*obj.sens_mechanical_grasper(j)*obj.mu_k_h*obj.max_I3ant*obj.P_I3_anterior(j)*[1,-1]);
                                B1 = 1/obj.c_h*(obj.x_h_ref*obj.K_sp_h-sign(F_I2+F_sp_g-F_I3-F_hinge)*obj.sens_mechanical_grasper(j)*obj.mu_k_g*F_I4...
                                    -sign(F_sp_h+F_f_g)*obj.sens_mechanical_grasper(j)*obj.mu_k_h*obj.max_I3ant*obj.P_I3_anterior(j)*1);                
                            end
                            A11= A1(1);
                            A12 = A1(2);
                        end
                    else % if the seaweed is broken the jaws act as if unconstrained
                        if(abs(F_sp_h+F_f_g) <= abs(obj.mu_s_h*F_I3_ant)) % static friction is true
                        %disp('static2')
                            F_f_h = -obj.sens_mechanical_grasper(j)*(F_sp_h+F_f_g); %only calculate the force if an object is actually present
                            obj.jaw_friction_state(j+1) = 1;
                        else
                            %disp('kinetic2')
                            F_f_h = -sign(F_sp_h+F_f_g)*obj.sens_mechanical_grasper(j)*obj.mu_k_h*F_I3_ant; %only calculate the force if an object is actually present
                            obj.jaw_friction_state(j+1) = 0;
                        end
                        
                        A1 = 1/obj.c_h*obj.K_sp_h*[-1,0];
                        B1 = 1/obj.c_h*obj.x_h_ref*obj.K_sp_h;

                        A11 = A1(1);
                        A12 = A1(2);
                        obj.jaw_friction_state(j+1) = 0;

                    end
                end
                %[position_buccal_last F_h F_sp I3 hinge force_pinch F_H]


            %% Integrate body motions
            %uncomment to remove periphery
            %F_g = 0;
            %F_H = 0;

            A = [A11,A12;A21,A22];
            B = [B1;B2];

            x_last = [obj.x_h(j);obj.x_g(j)];

            x_new = 1/(1-obj.TimeStep*trace(A))*((eye(2)+obj.TimeStep*[-A22,A12;A21,-A11])*x_last+obj.TimeStep*B);

            obj.x_g(j+1) = x_new(2); 
            obj.x_h(j+1) = x_new(1);
            
            %% calculate force on object
            obj.force_on_object(j+1) = F_f_g+F_f_h;

            %check if seaweed is broken
            if (obj.fixation_type(j) ==1)
                if (obj.force_on_object(j+1)>obj.seaweed_strength)
                    unbroken = 0;
                end
                %check to see if a new cycle has started
                x_gh_next = obj.x_g(j+1)-obj.x_h(j+1);
                
                if (~unbroken && x_gh <0.3 && x_gh_next>x_gh)%x_gh<0.3)
                   unbroken = 1; 
                end
                obj.force_on_object(j+1)= unbroken*obj.force_on_object(j+1);
            end


             

            end

        end
        %%
        function obj = setSensoryStates(obj,varargin)
            t=obj.StartingTime:obj.TimeStep:obj.EndTime;
            nt=length(t); % number of time points
            
            if (nargin == 2)
                behavior = varargin{1};
                if (strcmp(behavior,'bite'))
                    obj.sens_chemical_lips = ones(1,nt);
                    obj.sens_mechanical_lips = ones(1,nt);
                    obj.sens_mechanical_grasper = zeros(1,nt);
                    obj.fixation_type = zeros(1,nt);
                elseif (strcmp(behavior,'swallow'))
                    obj.sens_chemical_lips = ones(1,nt);
                    obj.sens_mechanical_lips = ones(1,nt);
                    obj.sens_mechanical_grasper = ones(1,nt);
                    obj.fixation_type = ones(1,nt);
                elseif (strcmp(behavior,'reject'))
                    obj.sens_chemical_lips = zeros(1,nt);
                    obj.sens_mechanical_lips = ones(1,nt);
                    obj.sens_mechanical_grasper = ones(1,nt);
                    obj.fixation_type = zeros(1,nt);
                end
                
            elseif (nargin == 4)
                behavior_1 = varargin{1};
                behavior_2 = varargin{2};
                t_switch = varargin{3}; 
                
                step_switch = round(t_switch/obj.TimeStep);
                
                if (strcmp(behavior_1,'bite'))
                    obj.sens_chemical_lips = ones(1,nt);
                    obj.sens_mechanical_lips = ones(1,nt);
                    obj.sens_mechanical_grasper = zeros(1,nt);
                    obj.fixation_type = zeros(1,nt);
                elseif (strcmp(behavior_1,'swallow'))
                    obj.sens_chemical_lips = ones(1,nt);
                    obj.sens_mechanical_lips = ones(1,nt);
                    obj.sens_mechanical_grasper = ones(1,nt);
                    obj.fixation_type = ones(1,nt);
                elseif (strcmp(behavior_1,'reject'))
                    obj.sens_chemical_lips = zeros(1,nt);
                    obj.sens_mechanical_lips = ones(1,nt);
                    obj.sens_mechanical_grasper = ones(1,nt);
                    obj.fixation_type = zeros(1,nt);
                end
                
                
                if (strcmp(behavior_2,'bite'))
                    obj.sens_chemical_lips(1,step_switch:nt) = ones(1,length(step_switch:nt));
                    obj.sens_mechanical_lips(1,step_switch:nt) = ones(1,length(step_switch:nt));
                    obj.sens_mechanical_grasper(1,step_switch:nt) = zeros(1,length(step_switch:nt));
                    obj.fixation_type = zeros(1,step_switch:nt);
                elseif (strcmp(behavior_2,'reject'))
                    obj.sens_chemical_lips(1,step_switch:nt) = zeros(1,length(step_switch:nt));
                    obj.sens_mechanical_lips(1,step_switch:nt) = ones(1,length(step_switch:nt));
                    obj.sens_mechanical_grasper(1,step_switch:nt) = ones(1,length(step_switch:nt));
                    obj.fixation_type(1,step_switch:nt) = zeros(1,length(step_switch:nt));
                elseif (strcmp(behavior_2,'swallow'))
                    obj.sens_chemical_lips(1,step_switch:nt) = ones(1,length(step_switch:nt));
                    obj.sens_mechanical_lips(1,step_switch:nt) = ones(1,length(step_switch:nt));
                    obj.sens_mechanical_grasper(1,step_switch:nt) = ones(1,length(step_switch:nt));
                    obj.fixation_type(1,step_switch:nt) = ones(1,length(step_switch:nt)); 
                end
            end
            
        end
        %%
        function obj = setStimulationTrains(obj,neuron,onTime,duration)
            t=obj.StartingTime:obj.TimeStep:obj.EndTime;
            nt=length(t); % number of time points

            if (strcmp(neuron,'B4B5'))
                obj.stim_B4B5(1:nt) = zeros(1,nt); % initialize extracellular stimulation of B4/B5
                obj.stim_B4B5(onTime:(onTime+duration)) = ones(1,length(obj.stim_B4B5(onTime:(onTime+duration))));
                obj.stim_B4B5((onTime+duration):end) = zeros(1,length(obj.stim_B4B5((onTime+duration):end)));   
            end
            
            if (strcmp(neuron,'CBI2'))
                obj.stim_CBI2(1:nt) = zeros(1,nt); % initialize extracellular stimulation of CBI-2
                obj.stim_CBI2(onTime:(onTime+duration)) = ones(1,length(obj.stim_CBI2(onTime:(onTime+duration))));
                obj.stim_CBI2((onTime+duration):end) = zeros(1,length(obj.stim_CBI2((onTime+duration):end)));   
            end
            
        end
        %%
        function generatePlots(obj,label,xlimits)
            t=obj.StartingTime:obj.TimeStep:obj.EndTime;

            figure('Position', [10 10 1200 600]);
            set(gcf,'Color','white')
            xl=xlimits; % show full time scale
            ymin = 0;
            ymax = 1;
            shift = 0.0475;%0.04;
            top = 0.95;
            i=0;
            left = 0.25;
            width = 0.7;
            height = 0.02;

            subplot(15,1,1)
            %External Stimuli
            subplot('position',[left top width height])
            i=i+1;
            plot(t,obj.sens_mechanical_grasper, 'Color', [56/255, 232/255, 123/255],'LineWidth',2) %mechanical in grasper
            set(gca,'FontSize',16)

            set(gca,'xtick',[])
            set(gca,'ytick',[0,1])
            set(gca,'YTickLabel',[]);
            ylabel('Mech. in Grasper')
            ylim([0 1])
            grid on
            xlim(xl)
            hYLabel = get(gca,'YLabel');
            set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])

            set(gca,'XColor','none')

            subplot('position',[left top-i*shift width height])
            i=i+1;
            plot(t,obj.sens_chemical_lips, 'Color', [70/255, 84/255, 218/255],'LineWidth',2) %chemical at lips
            set(gca,'FontSize',16)
            set(gca,'xtick',[])
            set(gca,'ytick',[0,1])
            set(gca,'YTickLabel',[]);
            ylabel('Chem. at Lips')
            ylim([0 1])
            grid on
            xlim(xl)
            hYLabel = get(gca,'YLabel');
            set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])

            set(gca,'XColor','none')

            subplot('position',[left top-i*shift width height])
            i=i+1;
            plot(t,obj.sens_mechanical_lips, 'Color', [47/255, 195/255, 241/255],'LineWidth',2) %mechanical at lips
            set(gca,'FontSize',16)
            set(gca,'xtick',[])
            set(gca,'ytick',[0,1])
            set(gca,'YTickLabel',[]);
            ylabel('Mech. at Lips')
            ylim([0 1])
            grid on
            xlim(xl)
            hYLabel = get(gca,'YLabel');
            set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
            set(gca,'XColor','none')


            subplot('position',[left top-i*shift width height])
            plot(t,obj.CBI2,'k','LineWidth',2) % CBI2
            i=i+1;
            set(gca,'FontSize',16)
            set(gca,'xtick',[])
            set(gca,'ytick',[0,1])
            set(gca,'YTickLabel',[]);
            ylabel('CBI-2')
            ylim([ymin ymax])
            xlim(xl)
            hYLabel = get(gca,'YLabel');
            set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
            set(gca,'XColor','none')


            subplot('position',[left top-i*shift width height])
            plot(t,obj.CBI3,'k','LineWidth',2) % CBI3
            i=i+1;
            set(gca,'FontSize',16)
            set(gca,'xtick',[])
            set(gca,'ytick',[0,1])
            set(gca,'YTickLabel',[]);
            ylabel('CBI-3')
            ylim([ymin ymax])
            xlim(xl)
            hYLabel = get(gca,'YLabel');
            set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
            set(gca,'XColor','none')


            subplot('position',[left top-i*shift width height])
            plot(t,obj.CBI4,'k','LineWidth',2) % CBI4
            i=i+1;
            set(gca,'FontSize',16)
            set(gca,'xtick',[])
            set(gca,'ytick',[0,1])
            set(gca,'YTickLabel',[]);
            ylabel('CBI-4')
            ylim([ymin ymax])
            xlim(xl)
            hYLabel = get(gca,'YLabel');
            set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
            set(gca,'XColor','none')

            %Interneurons
            subplot('position',[left top-i*shift width height])
            plot(t,obj.B64,'LineWidth',2, 'Color',[90/255, 131/255, 198/255]) % B64
            i=i+1;
            set(gca,'FontSize',16)
            set(gca,'xtick',[])
            set(gca,'ytick',[0,1])
            set(gca,'YTickLabel',[]);
            ylabel('B64', 'Color',[90/255, 131/255, 198/255])
            ylim([ymin ymax])
            xlim(xl)
            hYLabel = get(gca,'YLabel');
            set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
            set(gca,'XColor','none')


            subplot('position',[left top-i*shift width height])
            plot(t,obj.B20,'LineWidth',2, 'Color',[44/255, 166/255, 90/255]) % B20
            i=i+1;
            set(gca,'FontSize',16)
            set(gca,'xtick',[])
            set(gca,'ytick',[0,1])
            set(gca,'YTickLabel',[]);
            ylabel('B20', 'Color',[44/255, 166/255, 90/255])
            ylim([ymin ymax])
            xlim(xl)
            hYLabel = get(gca,'YLabel');
            set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
            set(gca,'XColor','none')


            subplot('position',[left top-i*shift width height])
            plot(t,obj.B40B30,'LineWidth',2, 'Color',[192/255, 92/255, 185/255]) % B40/B30
            i=i+1.5;
            set(gca,'FontSize',16)
            set(gca,'xtick',[])
            set(gca,'ytick',[0,1])
            set(gca,'YTickLabel',[]);
            ylabel('B40/B30', 'Color',[192/255, 92/255, 185/255])
            ylim([ymin ymax])
            xlim(xl)
            hYLabel = get(gca,'YLabel');
            set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
            set(gca,'XColor','none')


            subplot('position',[left top-i*shift width height*2])
            plot(t,obj.B4B5,'LineWidth',2, 'Color', [51/255, 185/255, 135/255]) % B4/5
            i=i+1;
            set(gca,'FontSize',16)
            set(gca,'xtick',[])
            set(gca,'ytick',[0,1,2])
            set(gca,'YTickLabel',[]);
            ylabel('B4/B5', 'Color', [51/255, 185/255, 135/255])
            ylim([ymin 2])
            xlim(xl)
            hYLabel = get(gca,'YLabel');
            set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
            set(gca,'XColor','none')


            %motor neurons
            subplot('position',[left top-i*shift width height])
            plot(t,obj.B31B32,'LineWidth',2, 'Color', [220/255, 81/255, 81/255]) % I2 input
            i=i+1;
            set(gca,'FontSize',16)
            set(gca,'xtick',[])
            set(gca,'ytick',[0,1])
            set(gca,'YTickLabel',[]);
            ylabel('B31/B32','Color',[220/255, 81/255, 81/255])
            ylim([ymin ymax])
            xlim(xl)
            hYLabel = get(gca,'YLabel');
            set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
            set(gca,'XColor','none')


            subplot('position',[left top-i*shift width height])
            plot(t,obj.B8,'LineWidth',2, 'Color', [213/255, 155/255, 196/255]) % B8a/b
            i=i+1;
            set(gca,'FontSize',16)
            set(gca,'xtick',[])
            set(gca,'ytick',[0,1])
            set(gca,'YTickLabel',[]);
            ylabel('B8a/b', 'Color', [213/255, 155/255, 196/255])
            ylim([ymin ymax])
            xlim(xl)
            hYLabel = get(gca,'YLabel');
            set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
            set(gca,'XColor','none')


            subplot('position',[left top-i*shift width height])
            plot(t,obj.B38,'LineWidth',2, 'Color', [238/255, 191/255, 70/255]) % B38
            i=i+1;
            set(gca,'FontSize',16)
            set(gca,'xtick',[])
            set(gca,'ytick',[0,1])
            set(gca,'YTickLabel',[]);
            ylabel('B38', 'Color', [238/255, 191/255, 70/255])
            ylim([ymin ymax])
            xlim(xl)
            hYLabel = get(gca,'YLabel');
            set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
            set(gca,'XColor','none')


            subplot('position',[left top-i*shift width height])
            plot(t,obj.B6B9B3,'LineWidth',2, 'Color', [90/255, 155/255, 197/255]) % B6/9/3
            i=i+1;
            set(gca,'FontSize',16)
            set(gca,'xtick',[])
            set(gca,'ytick',[0,1])
            set(gca,'YTickLabel',[]);
            ylabel('B6/B9/B3', 'Color', [90/255, 155/255, 197/255])
            ylim([ymin ymax])
            xlim(xl)
            set(get(gca,'ylabel'),'rotation',0) 
            hYLabel = get(gca,'YLabel');
            set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
            set(gca,'XColor','none')


            subplot('position',[left top-i*shift width height])
            plot(t,obj.B7,'LineWidth',2, 'Color', [56/255, 167/255, 182/255]) % B7
            i=i+2.5;
            set(gca,'FontSize',16)
            set(gca,'xtick',[])
            set(gca,'ytick',[0,1])
            set(gca,'YTickLabel',[]);
            ylabel('B7', 'Color', [56/255, 167/255, 182/255])
            ylim([ymin ymax])
            xlim(xl)
            hYLabel = get(gca,'YLabel');
            set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
            set(gca,'XColor','none')


            %Determine locations of protraction retraction boxes
            tstep = obj.TimeStep;
            startnum = round(xl(1)/tstep);
            endnum = round(xl(2)/tstep);
            grasper_rel_pos = (obj.x_g-obj.x_h);
            numProtractionBoxes = 0;
            numRetractionBoxes = 0;
            protraction = 1;
            protractionRectangles=[0,0];
            retractionRectangles=[0,0];
            for ind=startnum+2:endnum
            if grasper_rel_pos(ind) > grasper_rel_pos(ind-1)
                %protraction
                if(protraction == 0)
                    numProtractionBoxes=numProtractionBoxes+1;
                    protraction = 1;
                    %end the last retractionrectangle
                    if(numRetractionBoxes>0)
                        retractionRectangles(numRetractionBoxes,2) = ind;
                    end
                    %start a new protractionrectangle
                    protractionRectangles(numProtractionBoxes,1) = ind;
                end
            else
                %retraction
                if(protraction == 1)
                    numRetractionBoxes=numRetractionBoxes+1;
                    protraction = 0;
                    %end the last retractionrectangle            
                    retractionRectangles(numRetractionBoxes,1) = ind;
                    %start a new protractionrectangle
                    if(numProtractionBoxes>0)
                        protractionRectangles(numProtractionBoxes,2) = ind; 
                    end
                end     
            end
            end

            if retractionRectangles(end,2) ==0
             retractionRectangles(end,2) = endnum;
            end

            if protractionRectangles(end,2) ==0
             protractionRectangles(end,2) = endnum;
            end

            %Grasper Motion
            subplot('position',[left top-i*shift width height*3.5])
            grasper_motion = (obj.x_g-obj.x_h);
            grasper_pressure = obj.grasper_friction_state;
            idx = grasper_pressure >=1;%pmax*0.6;
            idy = grasper_pressure <1;%pmax*0.6;

            grasper_motion_pressure(idx) = grasper_motion(idx);
            grasper_motion_pressure(idy)=NaN;

            plot(t,grasper_motion_pressure,'b','LineWidth',4)
            hold on
            plot(t,grasper_motion,'b','LineWidth',2)
            hold off

            i=i+2.5;
            set(gca,'FontSize',16)
            set(gca,'xtick',[])
            set(gca,'YTickLabel',[]);
            ylabel({'Grasper';'Motion'}, 'Color', [0/255, 0/255, 255/255])
            xlim(xl)
            set(gca,'XColor','none')
            hYLabel = get(gca,'YLabel');
            set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
            set(gca,'XColor','none')

            hold on
            for retract = 1:length(retractionRectangles)
            h=rectangle('Position', [retractionRectangles(retract,1)*tstep 1.25 (retractionRectangles(retract,2)-retractionRectangles(retract,1))*tstep 0.1]);  
            h.FaceColor = 'black';
            end
            hold off

            hold on
            for protract = 1:length(protractionRectangles)
            h=rectangle('Position', [protractionRectangles(protract,1)*tstep 1.25 (protractionRectangles(protract,2)-protractionRectangles(protract,1))*tstep 0.1]);  
            h.FaceColor = 'white';
            end
            hold off


            %subplot(15,1,15)
            subplot('position',[left top-i*shift width height*3.5])

            plot(t,obj.force_on_object,'k','LineWidth',2)
            yticks([-1 0 1])
            yticklabels({'','0',''})

            set(gca,'FontSize',16)
            set(gca,'xtick',[])
            ylabel('Force', 'Color', [0/255, 0/255, 0/255])
            xlim(xl)
            set(gca,'XColor','none')
            hYLabel = get(gca,'YLabel');
            set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
            set(gca,'XColor','none')

            if ~exist('fig', 'dir')
                mkdir('fig');
            end
            saveas(gcf,['fig/' label '_all.png'])            
        end
        
    end
    
end
